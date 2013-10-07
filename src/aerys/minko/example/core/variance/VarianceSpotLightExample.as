package aerys.minko.example.core.variance
{
	import aerys.minko.render.shader.part.phong.attenuation.LightBleedingInterpolation;
	import aerys.minko.scene.node.light.SpotLight;
	import aerys.minko.type.enum.ShadowMappingType;
	import aerys.minko.type.math.Vector4;

	public class VarianceSpotLightExample extends AbstractLightExampleApplication
	{
		override protected function initializeLights() : void
		{
			super.initializeLights();
			
			var spotLight	: SpotLight	= new SpotLight();
			
            spotLight.color             			= 0xffeeddff;
			spotLight.shadowMappingType				= ShadowMappingType.VARIANCE;
			spotLight.shadowMapSize					= 2048;
			spotLight.outerRadius					= Math.PI / 2;
			spotLight.innerRadius					= 0;
			spotLight.shadowZNear					= 0.1;
			spotLight.shadowZFar					= 200;
			spotLight.lightBleedingBias				= 0.1;
			spotLight.lightBleedingInterpolation	= LightBleedingInterpolation.SMOOTHSTEP;
            
			spotLight.transform.lookAt(Vector4.Z_AXIS, new Vector4(0., 0., -70));
            
			scene.addChild(spotLight);
		}
	}
}
