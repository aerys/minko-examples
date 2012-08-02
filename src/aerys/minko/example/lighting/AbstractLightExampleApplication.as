package aerys.minko.example.lighting
{
	import aerys.minko.render.geometry.primitive.CubeGeometry;
	import aerys.minko.render.geometry.primitive.TeapotGeometry;
	import aerys.minko.render.material.Material;
	import aerys.minko.render.material.phong.PhongMaterial;
	import aerys.minko.scene.node.Group;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.scene.node.light.AmbientLight;
	import aerys.minko.type.enum.TriangleCulling;
	import aerys.minko.type.math.Vector4;
	
	import flash.events.Event;
	
	public class AbstractLightExampleApplication extends MinkoExampleApplication
	{
		private var _teapotGroup		: Group;
		
		private var _cubeMaterial		: Material;
		private var _teapotsMaterial	: Material;
		
		override protected function initializeScene() : void
		{
			super.initializeScene();
			
			initializeLights();
			
			scene.addChild(new AmbientLight());
			
			var mat : PhongMaterial = new PhongMaterial(scene);
			
			mat.castShadows = true;
			mat.receiveShadows = true;
			
			_cubeMaterial = mat.clone() as PhongMaterial;
			
			var bigCube : Mesh = new Mesh(CubeGeometry.cubeGeometry, _cubeMaterial);
			
			bigCube.transform.setScale(100, 100, 100);
			_cubeMaterial.triangleCulling = TriangleCulling.FRONT;
			_cubeMaterial.diffuseColor = 0xbbbbffff;
			_cubeMaterial.castShadows = false;
			
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