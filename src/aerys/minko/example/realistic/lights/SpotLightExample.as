package aerys.minko.example.realistic.lights
{
	import aerys.minko.Minko;
	import aerys.minko.scene.node.Group;
	import aerys.minko.scene.node.Sprite;
	import aerys.minko.scene.node.light.AmbientLight;
	import aerys.minko.scene.node.light.SpotLight;
	import aerys.minko.type.enum.ShadowMappingType;
	import aerys.minko.type.log.DebugLevel;
	import aerys.minko.type.math.Vector4;
	
	import flash.events.Event;

	public class SpotLightExample extends AbstractLightExampleApplication
	{
		override protected function initializeLights() : void
		{
			Minko.debugLevel = DebugLevel.CONTEXT;
			
			var ambientLight	: AmbientLight	= new AmbientLight();
			var spotLight		: SpotLight		= new SpotLight();
			
			spotLight.shadowCastingType	= ShadowMappingType.MATRIX;
			spotLight.shadowMapSize		= 1024;
			spotLight.outerRadius		= Math.PI / 2;
			spotLight.innerRadius		= 0;
			
			scene.addChild(ambientLight).addChild(spotLight);
			
			spotLight.transform.view(
				new Vector4(0, 0, 0),
				new Vector4(1, 1, 1)
			);
		}
	}
}
