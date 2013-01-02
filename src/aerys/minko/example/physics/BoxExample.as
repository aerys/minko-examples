package aerys.minko.example.physics
{
	import aerys.minko.physics.World;
	import aerys.minko.physics.api.ColliderController;
	import aerys.minko.physics.collider.Collider;
	import aerys.minko.physics.constraint.force.DirectionalLinearConstantForce;
	import aerys.minko.physics.geometry.description.primitive.BoxGeometry;
	import aerys.minko.render.geometry.primitive.CubeGeometry;
	import aerys.minko.render.material.realistic.RealisticMaterial;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.scene.node.light.AmbientLight;
	import aerys.minko.scene.node.light.DirectionalLight;
	import aerys.minko.type.math.Vector4;

	public class BoxExample extends AbstractExampleApplication
	{
		protected var gravity		: Vector4 = new Vector4(0, -9.81, 0);
		protected var physicsWorld	: World;

		public function BoxExample()
		{
			super();
		}

		override protected function initializeScene() : void
		{
			super.initializeScene();
			
			initializePhysicsEngine();
			initializeLights();
			initializeGround();
		}
		
		protected function initializePhysicsEngine() : void
		{
			var gravity	: DirectionalLinearConstantForce = new DirectionalLinearConstantForce(gravity);

			physicsWorld = new World();
			physicsWorld.addGlobalForceGenerator(gravity);
			
			scene.addController(physicsWorld);
		}
		
		protected function initializeLights() : void
		{
			var directional	: DirectionalLight = new DirectionalLight();
			
			directional = new DirectionalLight();
			directional.transform.lookAt(Vector4.ZERO, new Vector4(100, 100, 100));
			scene.addChild(new AmbientLight());
			scene.addChild(new DirectionalLight());
		}
		
		protected function initializeGround()	: void
		{
			var groundMaterial				: RealisticMaterial		= new RealisticMaterial(scene, { diffuseColor : 0xeeeeeeff });
			var groundMesh					: Mesh					= new Mesh(CubeGeometry.cubeGeometry, groundMaterial);
			var groundColliderController	: ColliderController	= initializeGroundBoxController();
			
			groundMesh.transform.appendScale(100, 1, 100);
			groundMesh.addController(groundColliderController);
			
			scene.addChild(groundMesh);
		}
		
		private function initializeGroundBoxController()	: ColliderController
		{
			var groundGeometry		: BoxGeometry			= new BoxGeometry(100, 0.5, 100);
			var groundCollider		: Collider				= new Collider(groundGeometry);
			var groundController	: ColliderController	= new ColliderController(groundCollider, true, true);
			
			return groundController;
		}
	}
}