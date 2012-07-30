package aerys.minko.example.effects.blur
{
	import aerys.minko.example.lighting.directional.DirectionalLightExample;
	import aerys.minko.render.effect.blur.BlurEffect;
	import aerys.minko.render.effect.blur.BlurQuality;
	
	public class BlurExample extends DirectionalLightExample
	{
		override protected function initializeScene() : void
		{
			super.initializeScene();
			
			scene.postProcessingEffect = new BlurEffect(BlurQuality.NORMAL, 4);
		}
	}
}