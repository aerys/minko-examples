package aerys.minko.example.physics.stack
{
	import aerys.minko.example.physics.pyramid.BallGarbageCollectorScript;
	import aerys.minko.example.physics.pyramid.ThrowScript;
	import aerys.minko.physics.api.ColliderController;
	import aerys.minko.physics.collider.Collider;
	import aerys.minko.physics.dynamics.DynamicsProperties;
	import aerys.minko.physics.dynamics.PhysicsMaterialProfile;
	import aerys.minko.physics.shape.description.container.MultiprofileShape;
	import aerys.minko.physics.shape.description.primitive.BallShape;
	import aerys.minko.physics.shape.description.primitive.BoxShape;
	import aerys.minko.render.geometry.primitive.CubeGeometry;
	import aerys.minko.render.geometry.primitive.SphereGeometry;
	import aerys.minko.render.material.Material;
	import aerys.minko.render.material.phong.PhongMaterial;
	import aerys.minko.scene.controller.AbstractScriptController;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.type.math.Matrix4x4;
	import aerys.minko.type.math.Vector4;

	public class StackExample extends AbstractPhysicsExampleApplication
	{
		private static const GARBAGE_SCRIPT	: AbstractScriptController = new BallGarbageCollectorScript(-100);
		
		override protected function initializeScene() : void
		{
			super.initializeScene();

            physicsWorld.numConstraintIterations = 15;
            
			initializeStacks();
			initializeBall();
		}
		
		private function initializeStacks() : void
		{
			var material : Material = new PhongMaterial({ diffuseColor : 0x444444ff, castShadows : true });
            const numRows : uint = 5;
			const numStacks : uint = 10;
            const stackHeight : uint = 8;
			
            for (var j : uint = 0; j < numRows; ++j)
            {
    			for (var i : uint = 0; i < numStacks; ++i)
    			{
    				createStack(
    					stackHeight,
    					material,
    					new Matrix4x4()
    						.appendUniformScale(2)
    						.appendTranslation(
                                (-numStacks * .5 + i * 1.5) * 2,
                                0,
                                ((-numRows * .5 + j * 1.5) * 2)
                            )
    				);
    			}
            }
		}
		
		private function initializeBall() : void
		{
			var ball : Mesh = new Mesh(
				SphereGeometry.sphereGeometry,
				new PhongMaterial({ diffuseColor : 0x0000ffff, castShadows : true })
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
			ball.addController(GARBAGE_SCRIPT);
			
			scene.addController(new ThrowScript(ball));			
		}
		
		private function createStack(height 	: uint,
									 material	: Material,
									 position 	: Matrix4x4) : void
		{
			var unit : Vector4 = position.deltaTransformVector(Vector4.ONE);
			
			for (var blockId : uint = 0; blockId < height; ++blockId)
			{
				var block : Mesh = new Mesh(CubeGeometry.cubeGeometry, material);
			
				block.transform.copyFrom(position);
				block.transform.appendTranslation(0, .5 + unit.y * (blockId + .5), 0.);
				block.addController(new ColliderController(
					new Collider(
						new MultiprofileShape(
							new BoxShape(unit.x * .5, unit.y * .5, unit.z * .5),
							null,
							new PhysicsMaterialProfile(2, 1, 0)
						),
						new DynamicsProperties()),
					true,
					true
				));
				block.addController(GARBAGE_SCRIPT);
				scene.addChild(block);
			}
		}
	}
}