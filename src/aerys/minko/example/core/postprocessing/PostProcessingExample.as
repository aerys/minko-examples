package aerys.minko.example.core.postprocessing
{
	import aerys.minko.example.core.light.DirectionalLightExample;
	import aerys.minko.render.effect.Effect;

	public class PostProcessingExample extends DirectionalLightExample
	{
		override protected function initializeScene() : void
		{
			super.initializeScene();
			
			scene.postProcessingEffect = new Effect(new NoisePostProcessingShader());
		}
	}
}