package aerys.minko.example.effects.hdr
{
	import aerys.minko.example.lighting.spot.SpotLightExample;
	import aerys.minko.render.effect.hdr.HDREffect;
	import aerys.minko.render.effect.hdr.HDRQuality;
	import aerys.minko.scene.node.light.SpotLight;
	import aerys.minko.type.enum.ShadowMappingQuality;
	import aerys.minko.type.enum.ShadowMappingType;
	import aerys.minko.type.math.Vector4;
	
	public class HDRExample extends SpotLightExample
	{
		override protected function initializeScene() : void
		{
			super.initializeScene();
			
			cameraController.distance = 100;
			cameraController.distanceStep = 0.;
			cameraController.pitch -= .2;
			
			scene.postProcessingEffect = new HDREffect(HDRQuality.LOW, 4);
			scene.postProcessingProperties.setProperties({
				hdrIntensity : 0.6
			});
		}
		
		override protected function initializeLights() : void
		{
			var spotLight	: SpotLight	= new SpotLight();
			
			spotLight.diffuse					= 1;
			spotLight.shadowCastingType			= ShadowMappingType.MATRIX;
			spotLight.shadowMapSize				= 1024;
			spotLight.outerRadius				= Math.PI / 2;
			spotLight.innerRadius				= 0;
			spotLight.shadowMapQuality			= ShadowMappingQuality.LOW;
			spotLight.shadowMapSamplingDistance = 2;
			
			scene.addChild(spotLight);
			
			spotLight.transform
				.appendTranslation(0, 0, -70)
				.lookAt(new Vector4(0, 0, 1));
		}
	}
}