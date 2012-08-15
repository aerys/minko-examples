package aerys.minko.example.lighting.directional
{
	import aerys.minko.example.lighting.AbstractLightExampleApplication;
	import aerys.minko.render.material.phong.PhongProperties;
	import aerys.minko.scene.node.light.DirectionalLight;
	import aerys.minko.type.enum.ShadowMappingQuality;
	import aerys.minko.type.enum.ShadowMappingType;

	public class DirectionalLightExample extends AbstractLightExampleApplication
	{
		private var _light : DirectionalLight;
		
		override protected function initializeLights() : void
		{
			super.initializeLights();
			
			_light = new DirectionalLight();
			_light.transform.setTranslation(0, 0, -100);
			
			_light.shadowCastingType			= ShadowMappingType.MATRIX;
			_light.shadowMapSize				= 1024;
			_light.shadowMapQuality				= ShadowMappingQuality.LOW;
			_light.shadowMapSamplingDistance	= 2;
			_light.shadowMapWidth				= 100;
			
			scene.properties.setProperty(PhongProperties.SHADOW_BIAS, 1 / 256);
			
			scene.addChild(_light);
		}
	}
}
