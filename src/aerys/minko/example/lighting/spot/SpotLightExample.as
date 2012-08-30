package aerys.minko.example.lighting.spot
{
	import aerys.minko.example.lighting.AbstractLightExampleApplication;
	import aerys.minko.scene.node.light.SpotLight;
	import aerys.minko.type.enum.ShadowMappingQuality;
	import aerys.minko.type.enum.ShadowMappingType;
	import aerys.minko.type.math.Vector4;

	public class SpotLightExample extends AbstractLightExampleApplication
	{
		override protected function initializeLights() : void
		{
			super.initializeLights();
			
			var spotLight	: SpotLight	= new SpotLight();
			
			spotLight.diffuse					= 1;
			spotLight.shadowCastingType			= ShadowMappingType.MATRIX;
			spotLight.shadowMapSize				= 1024;
			spotLight.outerRadius				= Math.PI / 2;
			spotLight.innerRadius				= 0;
			spotLight.shadowMapQuality			= ShadowMappingQuality.LOW;
			
			scene.addChild(spotLight);
			
			spotLight.transform
				.appendTranslation(0, 0, -70)
				.lookAt(new Vector4(0, 0, 1));
		}
	}
}
