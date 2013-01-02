package aerys.minko.example.physics.stack
{
	import aerys.minko.example.physics.BoxExample;
	import aerys.minko.physics.api.ColliderController;
	import aerys.minko.physics.collider.Collider;
	import aerys.minko.physics.dynamics.DynamicsProperties;
	import aerys.minko.physics.geometry.description.primitive.BoxGeometry;
	import aerys.minko.render.geometry.primitive.CubeGeometry;
	import aerys.minko.render.material.realistic.RealisticMaterial;
	import aerys.minko.scene.node.ISceneNode;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.scene.node.light.AmbientLight;
	import aerys.minko.scene.node.light.DirectionalLight;
	import aerys.minko.type.math.Vector4;

	public class PyramidExample extends BoxExample
	{
		override protected function initializeScene() : void
		{
			super.initializeScene();
			
			initializePyramid(15, 15);
		}
		
		private function initializePyramid(width			: uint,
										   height			: uint) : void
		{
			var oddMaterial						: RealisticMaterial	 = new RealisticMaterial(scene, { diffuseColor :  0xffeffaff });
			var evenMaterial					: RealisticMaterial	 = new RealisticMaterial(scene, { diffuseColor :  0xffeeaaff});
			var pyramidOddMeshTemplate			: Mesh				 = new Mesh(CubeGeometry.cubeGeometry, oddMaterial);
			var pyramidEvenMeshTemplate			: Mesh				 = new Mesh(CubeGeometry.cubeGeometry, evenMaterial);
			var pyramidBoxColliderController	: ColliderController = initializeMovingBoxController();

			pyramidOddMeshTemplate.transform.appendScale(1, 1, 2);
			pyramidOddMeshTemplate.addController(pyramidBoxColliderController);
			pyramidEvenMeshTemplate.transform.appendScale(1, 1, 2);
			pyramidEvenMeshTemplate.addController(pyramidBoxColliderController);
			
			for (var i : uint = 0; i < width; ++i)
			{
				for (var j : uint = i; j < height; ++j)
				{
					var pyramidBoxMesh	: ISceneNode = j % 2 ? pyramidOddMeshTemplate.clone()
															 : pyramidEvenMeshTemplate.clone();

					pyramidBoxMesh.transform.appendTranslation(0, i + 1.0, j * 2. - i * 1.);
					scene.addChild(pyramidBoxMesh);
				}
			}
		}

		private function initializeMovingBoxController()	: ColliderController
		{
			var boxGeometry		: BoxGeometry			= new BoxGeometry(0.5, 0.5, 1.0);
			var boxDynamics		: DynamicsProperties	= new DynamicsProperties();
			var boxCollider		: Collider				= new Collider(boxGeometry, boxDynamics);
			var boxController	: ColliderController	= new ColliderController(boxCollider, true, true);
			
			return boxController;
		}
	} 
}