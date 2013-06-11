package aerys.minko.example.physics.primitive
{
	import aerys.minko.physics.api.ColliderController;
	import aerys.minko.physics.api.event.CollisionStartedEvent;
	import aerys.minko.physics.collider.Collider;
	import aerys.minko.physics.dynamics.DynamicsProperties;
	import aerys.minko.physics.shape.description.AbstractPhysicsShape;
	import aerys.minko.physics.shape.description.primitive.BallShape;
	import aerys.minko.physics.shape.description.primitive.BoxShape;
	import aerys.minko.physics.shape.description.primitive.ConeShape;
	import aerys.minko.physics.shape.description.primitive.CylinderShape;
	import aerys.minko.render.geometry.primitive.ConeGeometry;
	import aerys.minko.render.geometry.primitive.CubeGeometry;
	import aerys.minko.render.geometry.primitive.CylinderGeometry;
	import aerys.minko.render.geometry.primitive.SphereGeometry;
	import aerys.minko.render.material.Material;
	import aerys.minko.render.material.basic.BasicMaterial;
	import aerys.minko.render.material.basic.BasicProperties;
	import aerys.minko.scene.controller.AbstractController;
	import aerys.minko.scene.controller.AbstractScriptController;
	import aerys.minko.scene.node.ISceneNode;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.scene.node.Scene;
	import aerys.minko.type.math.Vector4;
	
	import flash.ui.Keyboard;
	
	public class PhysicsPrimitiveCreationController extends AbstractScriptController
	{
		private var _colliderControllers 	: Vector.<ColliderController> 	= new Vector.<ColliderController>;
		private var _colliderColors			: Array 						= [];
		
		public function PhysicsPrimitiveCreationController(targetType:Class=null)
		{
			super(targetType);
			
			initializeColliders();
		}
		
		private function initializeColliders() : void
		{
			_colliderControllers.push(
				initalizePhysicsControllerFromShape(new BoxShape(0.5, 0.5, 0.5)),
				initalizePhysicsControllerFromShape(new BallShape(0.5)),
				initalizePhysicsControllerFromShape(new ConeShape(0.5, 1)),
				initalizePhysicsControllerFromShape(new CylinderShape(0.5, 1)));
			
			_colliderColors = [
				Math.random() * 0xFFFFFFFF,
				Math.random() * 0xFFFFFFFF,
				Math.random() * 0xFFFFFFFF,
				Math.random() * 0xFFFFFFFF
			];
			
		}
		
		private function initalizePhysicsControllerFromShape(shape : AbstractPhysicsShape) : ColliderController
		{
			var shapeDynamics	: DynamicsProperties	= new DynamicsProperties();
			var shapeCollider	: Collider				= new Collider(shape, shapeDynamics);
			var shapeController	: ColliderController	= new ColliderController(shapeCollider, true, true);
			
			return shapeController;
		}
		
		public function getNodeFromCollider(collider : Collider) : ISceneNode
		{
			for each (var colliderController : ColliderController in _colliderControllers)
			{
				var node : ISceneNode = colliderController.colliderToNode(collider);
				if (node != null)
					return node;
			}
			return null;
		}
		
		public function getColliderFromNode(node : ISceneNode) : Collider
		{
			for each (var colliderController : ColliderController in _colliderControllers)
			{
				var collider : Collider = colliderController.nodeToCollider(node);
				if (collider != null)
					return collider;
			}
			return null;
		}
		
		
		public function reinit(node : ISceneNode, collider : Collider, position : Vector4) : void
		{
			var mesh 			: Mesh 	= Mesh(node);
			var controllerIndex : int 	= -1;
			
			if (mesh.geometry is CubeGeometry)
				controllerIndex = 0;
			if (mesh.geometry is SphereGeometry)
				controllerIndex = 1;
			if (mesh.geometry is ConeGeometry)
				controllerIndex = 2;
			if (mesh.geometry is CylinderGeometry)
				controllerIndex = 3;
			
			var physicInformation : DynamicsProperties = collider.dynamics;
			
			mesh.removeController(_colliderControllers[controllerIndex]);
			
			mesh.transform.setTranslation(position.x, position.y - 1, position.z);
			mesh.addController(_colliderControllers[controllerIndex]);
			
			getColliderFromNode(mesh).dynamics = physicInformation.clone();
		}
		
		override protected function update(target:ISceneNode):void
		{
			var scene 			: Scene = target as Scene;
			var mesh 			: Mesh  = null;
			var controllerIndex	: int 	= -1;
			
			if (keyboard.keyIsDown(Keyboard.RIGHT))
			{
				mesh 			= new Mesh(CubeGeometry.cubeGeometry, new BasicMaterial());			
				controllerIndex = 0;
			}
			
			if (keyboard.keyIsDown(Keyboard.LEFT))
			{
				mesh 			= new Mesh(SphereGeometry.sphereGeometry, new BasicMaterial());			
				controllerIndex = 1;
			}
			
			if (keyboard.keyIsDown(Keyboard.UP))
			{
				mesh 			= new Mesh(new ConeGeometry(), new BasicMaterial());			
				controllerIndex = 2;
			}
			
			if (keyboard.keyIsDown(Keyboard.DOWN))
			{
				mesh 			= new Mesh(CylinderGeometry.cylinderGeometry, new BasicMaterial());			
				controllerIndex = 3;
			}
			
			if (mesh != null)
			{
				mesh.material.setProperty(BasicProperties.DIFFUSE_COLOR, _colliderColors[controllerIndex]);
				mesh.transform.appendTranslation(0, 25, 0);
				mesh.addController(_colliderControllers[controllerIndex]);
				scene.addChild(mesh);
			}
		}
	}
}