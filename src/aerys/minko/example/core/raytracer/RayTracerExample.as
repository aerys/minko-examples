package aerys.minko.example.core.raytracer
{
	import aerys.minko.scene.node.mesh.geometry.primitive.QuadGeometry;

	public class RayTracerExample extends MinkoExampleApplication
	{
		override protected function initializeScene():void
		{
			super.initializeScene();
			
			scene.addChild(new EffectGroup(
				new SinglePassRenderingEffect(new RayTracerShader()),
				new QuadGeometry()
			));
		}
	}
}