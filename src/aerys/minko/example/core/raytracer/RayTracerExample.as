package aerys.minko.example.core.raytracer
{
	import aerys.minko.scene.node.mesh.primitive.QuadMesh;

	public class RayTracerExample extends MinkoExampleApplication
	{
		override protected function initializeScene():void
		{
			super.initializeScene();
			
			scene.addChild(new EffectGroup(
				new SinglePassRenderingEffect(new RayTracerShader()),
				new QuadMesh()
			));
		}
	}
}