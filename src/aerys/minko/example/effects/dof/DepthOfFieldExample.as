package aerys.minko.example.effects.dof
{
	import aerys.minko.example.lighting.directional.DirectionalLightExample;
	import aerys.minko.render.effect.blur.BlurQuality;
	import aerys.minko.render.effect.dof.DepthOfFieldEffect;
	
	public class DepthOfFieldExample extends DirectionalLightExample
	{
		override protected function initializeScene() : void
		{
			super.initializeScene();
			
			var dof : DepthOfFieldEffect = new DepthOfFieldEffect(BlurQuality.LOW, 8);
			
			scene.postProcessingEffect = dof;
			
			
		}
	}
}