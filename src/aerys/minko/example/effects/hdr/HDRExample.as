package aerys.minko.example.effects.hdr
{
	import aerys.minko.example.lighting.spot.SpotLightExample;
	import aerys.minko.render.effect.hdr.HDREffect;
	import aerys.minko.render.effect.hdr.HDRQuality;
	
	public class HDRExample extends SpotLightExample
	{
		override protected function initializeScene() : void
		{
			super.initializeScene();
			
			cameraController.distance = 100;
			cameraController.distanceStep = 0.;
			cameraController.pitch -= .2;
			
			scene.postProcessingEffect = new HDREffect(HDRQuality.MEDIUM, 6);
			scene.postProcessingProperties.setProperties({
				hdrIntensity 	: .6,
				hdrExponent		: 1.2
			});
		}
	}
}