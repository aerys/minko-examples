package aerys.minko.example.core.postprocessing
{
	import aerys.minko.example.core.redcube.RedCubeExample;
	import aerys.minko.render.Effect;

	public class PostProcessingExample extends RedCubeExample
	{
		override protected function initializeScene() : void
		{
			super.initializeScene();
			
			scene.postProcessingEffect = new Effect(new NoisePostProcessingShader());
		}
	}
}