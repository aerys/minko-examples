package aerys.minko.example.lighting
{
	import aerys.minko.render.effect.Effect;
	import aerys.minko.render.effect.basic.BasicProperties;
	import aerys.minko.render.effect.lighting.LightingEffect;
	import aerys.minko.render.effect.lighting.LightingProperties;
	import aerys.minko.scene.node.Group;
	import aerys.minko.scene.node.mesh.Mesh;
	import aerys.minko.scene.node.mesh.geometry.primitive.CubeGeometry;
	import aerys.minko.scene.node.mesh.geometry.primitive.TeapotGeometry;
	import aerys.minko.type.enum.TriangleCulling;
	import aerys.minko.type.math.Vector4;
	
	import flash.events.Event;
	
	public class AbstractLightExampleApplication extends MinkoExampleApplication
	{
		private var _lightingEffect : Effect;
		private var _teapotGroup	: Group;
		
		public function get lightingEffect() : Effect
		{
			return _lightingEffect;
		}
		
		override protected function initializeScene() : void
		{
			_lightingEffect	= new LightingEffect(scene);
			
			initializeLights();
			
			var bigCube : Mesh = new Mesh(CubeGeometry.cubeGeometry, null, _lightingEffect);
			bigCube.transform.setScale(100, 100, 100);
			bigCube.properties[BasicProperties.TRIANGLE_CULLING]	= TriangleCulling.FRONT;
			bigCube.properties[BasicProperties.DIFFUSE_COLOR]		= 0xbbbbffff;
			bigCube.properties[LightingProperties.RECEIVE_SHADOWS]	= true;
			bigCube.properties[LightingProperties.CAST_SHADOWS]		= true;
			
			scene.addChild(bigCube);
			
			var teapotGeometry : TeapotGeometry = new TeapotGeometry(3);
			_teapotGroup = new Group();
			
			for (var teapotId : uint = 0; teapotId < 50; ++teapotId)
			{
				var smallTeapot : Mesh = new Mesh(teapotGeometry, null, _lightingEffect);
				
				smallTeapot.properties[BasicProperties.DIFFUSE_COLOR] =
					new Vector4(Math.random(), Math.random(), Math.random(), 1);
				
				smallTeapot.properties[LightingProperties.CAST_SHADOWS] = true;
				smallTeapot.properties[LightingProperties.RECEIVE_SHADOWS]	= true;
				
				smallTeapot.transform.setTranslation(
					50 * (Math.random() - .5),
					50 * (Math.random() - .5),
					50 * (Math.random() - .5)
				);
				
				smallTeapot.transform.setRotation(
					2 * Math.PI * Math.random(),
					2 * Math.PI * Math.random(),
					2 * Math.PI * Math.random()
				);
				
				_teapotGroup.addChild(smallTeapot);
			}
			
			scene.addChild(_teapotGroup);
		}
		
		protected function initializeLights() : void
		{
		}
		
		override protected function enterFrameHandler(e : Event):void
		{
			super.enterFrameHandler(e);
			
			_teapotGroup.transform.appendRotation(0.01, Vector4.Y_AXIS);
		}
	}
}