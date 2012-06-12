package aerys.minko.example.lighting.directional
{
	import aerys.minko.scene.node.Sprite;
	import aerys.minko.scene.node.light.AmbientLight;
	import aerys.minko.scene.node.light.DirectionalLight;
	import aerys.minko.type.enum.ShadowMappingType;
	import aerys.minko.type.math.Matrix4x4;
	import aerys.minko.type.math.Vector4;
	
	import flash.events.Event;
	import aerys.minko.example.lighting.AbstractLightExampleApplication;

	public class DirectionalLightExample extends AbstractLightExampleApplication
	{
		private var _light : DirectionalLight;
		
		override protected function initializeLights() : void
		{
			_light = new DirectionalLight();
			
			_light.shadowCastingType	= ShadowMappingType.MATRIX;
			_light.shadowMapSize		= 2048;
			
			scene.addChild(_light).addChild(new AmbientLight());
		}
	}
}
