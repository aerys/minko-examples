package aerys.minko.example.lighting
{
	import aerys.minko.render.Effect;
	import aerys.minko.render.effect.lighting.LightingEffect;
	import aerys.minko.render.effect.lighting.LightingProperties;
	import aerys.minko.render.material.Material;
	import aerys.minko.render.material.basic.BasicProperties;
	import aerys.minko.render.material.phong.PhongMaterial;
	import aerys.minko.scene.node.Group;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.render.geometry.primitive.CubeGeometry;
	import aerys.minko.render.geometry.primitive.TeapotGeometry;
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
			super.initializeScene();
			
			_lightingEffect	= new LightingEffect(scene);
			
			initializeLights();
			
			var mat : PhongMaterial = new PhongMaterial(scene);
			
			mat.castShadows = true;
			mat.receiveShadows = true;
			
			var bigCubeMat : PhongMaterial = mat.clone() as PhongMaterial;
			var bigCube : Mesh = new Mesh(CubeGeometry.cubeGeometry, bigCubeMat);
			
			bigCube.transform.setScale(100, 100, 100);
			bigCubeMat.triangleCulling = TriangleCulling.FRONT;
			bigCubeMat.diffuseColor = 0xbbbbffff;
			bigCubeMat.castShadows = false;
			
			scene.addChild(bigCube);
			
			var teapotGeometry : TeapotGeometry = new TeapotGeometry(3);

			_teapotGroup = new Group();
			
			
			for (var teapotId : uint = 0; teapotId < 50; ++teapotId)
			{
				var smallTeapot : Mesh = new Mesh(teapotGeometry);
				
				mat.diffuseColor = ((Math.random() * 0xffffff) << 8) || 0xff;
				smallTeapot.material = mat.clone() as Material;
				
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