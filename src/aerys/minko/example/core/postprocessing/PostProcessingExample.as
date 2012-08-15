package aerys.minko.example.core.postprocessing
{
	import aerys.minko.example.core.primitives.PrimitivesExample;
	import aerys.minko.render.Effect;

	public class PostProcessingExample extends PrimitivesExample
	{
		override protected function initializeScene() : void
		{
			super.initializeScene();
			
			scene.postProcessingEffect = new Effect(new NoisePostProcessingShader());
		}
	}
}