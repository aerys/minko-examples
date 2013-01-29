package aerys.minko.example.core.directionallight
{
	import aerys.minko.render.material.phong.PhongProperties;
	import aerys.minko.scene.node.light.DirectionalLight;
	import aerys.minko.type.enum.ShadowMappingQuality;
	import aerys.minko.type.enum.ShadowMappingType;
	import aerys.minko.type.math.Vector4;

	public class DirectionalLightExample extends AbstractLightExampleApplication
	{
		override protected function initializeLights() : void
		{
			super.initializeLights();
			
			var directionalLight : DirectionalLight = new DirectionalLight();
			
            directionalLight.shadowCastingType	= ShadowMappingType.PCF;
            directionalLight.shadowMapSize		= 1024;
            directionalLight.shadowQuality		= ShadowMappingQuality.LOW;
            directionalLight.shadowSpread		= 2;
            directionalLight.shadowWidth		= 100;
            directionalLight.shadowZFar         = 200;
            directionalLight.shadowBias         = 1 / 256;
			
            directionalLight.transform.lookAt(Vector4.Z_AXIS, new Vector4(0., 0., -70));
            
			scene.addChild(directionalLight);
		}
	}
}
