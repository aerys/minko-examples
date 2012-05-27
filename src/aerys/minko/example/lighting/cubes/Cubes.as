package aerys.minko.example.lighting.cubes
{
	import aerys.minko.Minko;
	import aerys.minko.render.effect.Effect;
	import aerys.minko.render.effect.basic.BasicProperties;
	import aerys.minko.render.effect.lighting.LightingEffect;
	import aerys.minko.render.effect.lighting.LightingProperties;
	import aerys.minko.scene.node.Sprite;
	import aerys.minko.scene.node.light.AbstractLight;
	import aerys.minko.scene.node.light.AmbientLight;
	import aerys.minko.scene.node.light.DirectionalLight;
	import aerys.minko.scene.node.light.PointLight;
	import aerys.minko.scene.node.light.SpotLight;
	import aerys.minko.scene.node.mesh.Mesh;
	import aerys.minko.scene.node.mesh.geometry.primitive.CubeGeometry;
	import aerys.minko.scene.node.mesh.geometry.primitive.TeapotGeometry;
	import aerys.minko.type.enum.ShadowMappingType;
	import aerys.minko.type.enum.TriangleCulling;
	import aerys.minko.type.log.DebugLevel;
	import aerys.minko.type.math.Vector4;
	
	import flash.events.Event;

	public class Cubes extends MinkoExampleApplication
	{
		private var _lightingEffect : Effect;
		private var _light			: AbstractLight;
		
		override protected function initializeScene() : void
		{
			Minko.debugLevel = DebugLevel.CONTEXT | DebugLevel.SHADER_AGAL;
			
			_lightingEffect	= new LightingEffect(scene);
			_light			= new PointLight();
			_light.shadowCastingType = ShadowMappingType.CUBE;
			_light.shadowMapSize		= 1024;
//			_light.transform.rotationX = Math.PI / 8;
			
			scene.addChild(new AmbientLight());
			scene.addChild(_light);
			
			var bigCube : Mesh = new Mesh(CubeGeometry.cubeGeometry, null, _lightingEffect);
			bigCube.transform.setScale(100, 100, 100);
			bigCube.properties[BasicProperties.TRIANGLE_CULLING]	= TriangleCulling.FRONT;
			bigCube.properties[BasicProperties.DIFFUSE_COLOR]		= 0xbbbbffff;
			bigCube.properties[LightingProperties.RECEIVE_SHADOWS]	= true;
			
			scene.addChild(bigCube);
			
			var teapotGeometry	: TeapotGeometry = new TeapotGeometry(5);
			
			for (var teapotId : uint = 0; teapotId < 50; ++teapotId)
			{
				var smallTeapot : Mesh = new Mesh(teapotGeometry, null, _lightingEffect);
				
				smallTeapot.properties[BasicProperties.DIFFUSE_COLOR] =
					new Vector4(Math.random(), Math.random(), Math.random(), 1);
				
				smallTeapot.properties[LightingProperties.CAST_SHADOWS] = true;
				
				smallTeapot.transform.setTranslation(
					80 * (Math.random() - .5),
					80 * (Math.random() - .5),
					80 * (Math.random() - .5)
				);
				
				smallTeapot.transform.setRotation(
					2 * Math.PI * Math.random(),
					2 * Math.PI * Math.random(),
					2 * Math.PI * Math.random()
				);
				
				scene.addChild(smallTeapot);
			}
		}
		
		override protected function enterFrameHandler(event:Event):void
		{
			super.enterFrameHandler(event);
			
			_light.transform.appendRotation(0.01, Vector4.Y_AXIS);
		}
	}
}