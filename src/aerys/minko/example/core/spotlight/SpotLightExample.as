package aerys.minko.example.core.spotlight
{
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
			
            spotLight.color             = 0xffeeddff;
			spotLight.shadowCastingType	= ShadowMappingType.PCF;
			spotLight.shadowMapSize		= 2048;
			spotLight.outerRadius		= Math.PI / 2;
			spotLight.innerRadius		= 0;
			spotLight.shadowQuality		= ShadowMappingQuality.VERY_HIGH;
            spotLight.shadowSpread      = 2;
			spotLight.shadowColor		= 0xff0000ff;
            
			spotLight.transform.lookAt(Vector4.Z_AXIS, new Vector4(0., 0., -70));
            
			scene.addChild(spotLight);
		}
	}
}
