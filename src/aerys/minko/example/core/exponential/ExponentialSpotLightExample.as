package aerys.minko.example.core.exponential
{
	import aerys.minko.render.shader.part.phong.attenuation.LightBleedingInterpolation;
	import aerys.minko.scene.node.light.SpotLight;
	import aerys.minko.type.enum.ShadowMappingQuality;
	import aerys.minko.type.enum.ShadowMappingType;
	import aerys.minko.type.math.Vector4;

	public class ExponentialSpotLightExample extends AbstractLightExampleApplication
	{
		override protected function initializeLights() : void
		{
			super.initializeLights();
			
			var spotLight	: SpotLight	= new SpotLight();
			
            spotLight.color             			= 0xffeeddff;
			spotLight.shadowCastingType				= ShadowMappingType.EXPONENTIAL;
			spotLight.shadowMapSize					= 2048;
			spotLight.outerRadius					= Math.PI / 2;
			spotLight.innerRadius					= 0;
			spotLight.shadowZNear					= 0.1;
			spotLight.shadowZFar					= 200;
			spotLight..exponentialFactor			= 4.0;
            
			spotLight.transform.lookAt(Vector4.Z_AXIS, new Vector4(0., 0., -70));
            
			scene.addChild(spotLight);
		}
	}
}
