package aerys.minko.example.core.exponential
{
	import aerys.minko.render.shader.part.depth.DepthAlgorithm;
	import aerys.minko.render.shader.part.phong.attenuation.LightBleedingInterpolation;
	import aerys.minko.scene.node.light.DirectionalLight;
	import aerys.minko.type.enum.ShadowMappingType;
	import aerys.minko.type.math.Vector4;

	public final class ExponentialDirectionalLight extends AbstractLightExampleApplication
	{
		override protected function initializeLights() : void
		{
			super.initializeLights();
			
			var directionalLight : DirectionalLight = new DirectionalLight();
			
			directionalLight.shadowCastingType			= ShadowMappingType.EXPONENTIAL;
			directionalLight.shadowMapSize				= 1024;
			directionalLight.shadowWidth				= 100;
			directionalLight.shadowZFar        			= 250;
			directionalLight.depthAlgorithm				= DepthAlgorithm.LINEAR;
			directionalLight.exponentialFactor			= 4.0;
			
			directionalLight.transform.lookAt(Vector4.Z_AXIS, new Vector4(0., 0., -70));
			
			scene.addChild(directionalLight);
		}
	}
}