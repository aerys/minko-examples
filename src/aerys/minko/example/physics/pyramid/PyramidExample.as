package aerys.minko.example.physics.pyramid
{
	import aerys.minko.physics.api.ColliderController;
	import aerys.minko.physics.collider.Collider;
	import aerys.minko.physics.dynamics.DynamicsProperties;
	import aerys.minko.physics.dynamics.PhysicsMaterialProfile;
	import aerys.minko.physics.shape.description.container.MultiprofileShape;
	import aerys.minko.physics.shape.description.primitive.BallShape;
	import aerys.minko.physics.shape.description.primitive.BoxShape;
	import aerys.minko.render.geometry.primitive.CubeGeometry;
	import aerys.minko.render.geometry.primitive.SphereGeometry;
	import aerys.minko.render.material.phong.PhongMaterial;
	import aerys.minko.scene.node.ISceneNode;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.type.clone.CloneOptions;
	import aerys.minko.type.clone.ControllerCloneAction;

	public class PyramidExample extends AbstractPhysicsExampleApplication
	{
		override protected function initializeScene() : void
		{
			super.initializeScene();
            
            cameraController.distance = 75.;
            cameraController.pitch = 1.2;
            cameraController.yaw = -.75;
			
            var ball : Mesh = new Mesh(
                SphereGeometry.sphereGeometry,
                new PhongMaterial({ diffuseColor : 0x0000ffff })
            );
            
            var ballCollider : Collider = new Collider(
                new MultiprofileShape(
                    new BallShape(.5),
                    null,
                    new PhysicsMaterialProfile(10)
                ),
                new DynamicsProperties()
            );
           
            ball.addController(new ColliderController(ballCollider, true, true));
            ball.addController(new BallGarbageCollectorScript(-200.));
            
            scene.addController(new ThrowScript(ball));

			initializePyramid(15, 15);
		}
        
		private function initializePyramid(width	: uint,
										   height	: uint) : void
		{
			var oddMaterial						: PhongMaterial	 = new PhongMaterial(
                { diffuseColor :  0xffeffaff, receiveShadows : true, castShadows : true }
            );
			var evenMaterial					: PhongMaterial	 = new PhongMaterial(
                { diffuseColor :  0xffeeaaff, receiveShadows : true, castShadows : true }
            );
			var pyramidOddMeshTemplate			: Mesh				 = new Mesh(CubeGeometry.cubeGeometry, oddMaterial);
			var pyramidEvenMeshTemplate			: Mesh				 = new Mesh(CubeGeometry.cubeGeometry, evenMaterial);
			var pyramidBoxColliderController	: ColliderController = initializeMovingBoxController();

			pyramidOddMeshTemplate.transform.appendScale(1, 1, 2);
			pyramidOddMeshTemplate.addController(pyramidBoxColliderController);
			pyramidEvenMeshTemplate.transform.appendScale(1, 1, 2);
			pyramidEvenMeshTemplate.addController(pyramidBoxColliderController);

            var cloneOptions : CloneOptions = CloneOptions.defaultOptions
                .setActionForControllerClass(ColliderController, ControllerCloneAction.REASSIGN);
            
			for (var i : uint = 0; i < width; ++i)
			{
				for (var j : uint = i; j < height; ++j)
				{
					var pyramidBoxMesh	: ISceneNode = j % 2
                        ? pyramidOddMeshTemplate.clone(cloneOptions)
                        : pyramidEvenMeshTemplate.clone(cloneOptions);

					pyramidBoxMesh.transform.appendTranslation(0, i + 1.0, j * 2. - i - width);
					scene.addChild(pyramidBoxMesh);
				}
			}
		}

		private function initializeMovingBoxController() : ColliderController
		{
			var boxGeometry		: BoxShape      		= new BoxShape(0.5, 0.5, 1.0);
			var boxDynamics		: DynamicsProperties	= new DynamicsProperties();
			var boxCollider		: Collider				= new Collider(boxGeometry, boxDynamics);
			var boxController	: ColliderController	= new ColliderController(boxCollider, true, true);
			
			return boxController;
		}
	} 
}