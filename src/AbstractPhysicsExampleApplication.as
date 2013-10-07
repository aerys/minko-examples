package
{
	import aerys.minko.physics.World;
	import aerys.minko.physics.api.ColliderController;
	import aerys.minko.physics.collider.Collider;
	import aerys.minko.physics.constraint.force.DirectionalLinearConstantForce;
	import aerys.minko.physics.dynamics.PhysicsMaterialProfile;
	import aerys.minko.physics.shape.description.container.MultiprofileShape;
	import aerys.minko.physics.shape.description.primitive.BoxShape;
	import aerys.minko.render.geometry.primitive.CubeGeometry;
	import aerys.minko.render.material.Material;
	import aerys.minko.render.material.basic.BasicMaterial;
	import aerys.minko.render.material.phong.PhongMaterial;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.scene.node.light.AmbientLight;
	import aerys.minko.scene.node.light.DirectionalLight;
	import aerys.minko.type.enum.ShadowMappingQuality;
	import aerys.minko.type.enum.ShadowMappingType;
	import aerys.minko.type.math.Vector4;

	public class AbstractPhysicsExampleApplication extends AbstractExampleApplication
	{
		protected static const DEFAULT_GRAVITY 	: Vector4 		= new Vector4(0, -9.81, 0);

		protected var physicsWorld	: World								= null;
		protected var gravity		: DirectionalLinearConstantForce	= null;
		
		override protected function initializeScene():void
		{
			super.initializeScene();
			
			// create physic world
			gravity	= new DirectionalLinearConstantForce(DEFAULT_GRAVITY);
			
			physicsWorld = new World();
			physicsWorld.addGlobalForceGenerator(gravity);
			
			scene.addController(physicsWorld);
			// create floor
			var floor : Mesh = new Mesh(
				CubeGeometry.cubeGeometry,
				new PhongMaterial({
						diffuseColor	: 0xeeeeeeff,
						specular		: Vector4.ZERO,
						receiveShadows 	: true,
						castShadows		: false
                })
			);
			
			floor.transform.appendScale(100, 1, 100);
			
			var floorGeometry	: BoxShape				= new BoxShape(50, 0.5, 50);
			var floorCollider	: Collider				= new Collider(floorGeometry);
			var floorController	: ColliderController	= new ColliderController(floorCollider, true, true);
			
			floor.addController(floorController);
			scene.addChild(floor);
			
			initializeLights();
		}
		
		protected function initializeLights() : void
		{
			var directional	: DirectionalLight = new DirectionalLight();
			
			directional = new DirectionalLight();
			directional.transform.lookAt(Vector4.ZERO, new Vector4(100, 100, 100));
			directional.shadowMappingType = ShadowMappingType.PCF;
			directional.shadowMapSize = 2048;
			directional.shadowWidth = 150;
			directional.shadowQuality = ShadowMappingQuality.LOW;
			scene.addChild(directional);
			
			scene.addChild(new AmbientLight());
		}
	}
}