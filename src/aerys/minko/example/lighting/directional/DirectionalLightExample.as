package aerys.minko.example.lighting.directional
{
	import aerys.minko.example.lighting.AbstractLightExampleApplication;
	import aerys.minko.scene.node.light.AmbientLight;
	import aerys.minko.scene.node.light.DirectionalLight;
	import aerys.minko.type.enum.ShadowMappingType;

	public class DirectionalLightExample extends AbstractLightExampleApplication
	{
		private var _light : DirectionalLight;
		
		override protected function initializeLights() : void
		{
			_light = new DirectionalLight();
			
			_light.shadowCastingType	= ShadowMappingType.MATRIX;
			_light.shadowMapSize		= 512;
			
			scene.addChild(_light);
		}
	}
}
