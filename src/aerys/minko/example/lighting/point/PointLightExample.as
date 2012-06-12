package aerys.minko.example.lighting.point
{
	import aerys.minko.scene.node.Sprite;
	import aerys.minko.scene.node.light.AmbientLight;
	import aerys.minko.scene.node.light.PointLight;
	import aerys.minko.type.enum.ShadowMappingType;
	import aerys.minko.type.math.Vector4;
	
	import flash.events.Event;
	import aerys.minko.example.lighting.AbstractLightExampleApplication;

	public class PointLightExample extends AbstractLightExampleApplication
	{
		private var _done : Boolean = false;
		
		override protected function initializeLights() : void
		{
			var pointLight : PointLight		= new PointLight();
			pointLight.shadowCastingType	= ShadowMappingType.CUBE;
			pointLight.shadowMapSize		= 1024;
			
			pointLight.transform.view(
				new Vector4(20, 20, 20),
				new Vector4(-30, 234, 2)
			);
			
			scene.addChild(new AmbientLight()).addChild(pointLight);
		}
	}
}
