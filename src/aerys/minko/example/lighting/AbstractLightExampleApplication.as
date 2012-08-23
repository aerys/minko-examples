package aerys.minko.example.lighting
{
	import aerys.minko.render.geometry.primitive.CubeGeometry;
	import aerys.minko.render.geometry.primitive.TeapotGeometry;
	import aerys.minko.render.material.Material;
	import aerys.minko.render.material.phong.PhongMaterial;
	import aerys.minko.scene.node.Group;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.scene.node.light.AmbientLight;
	import aerys.minko.type.enum.NormalMappingType;
	import aerys.minko.type.enum.TriangleCulling;
	import aerys.minko.type.loader.TextureLoader;
	import aerys.minko.type.math.Vector4;
	
	import flash.events.Event;
	
	public class AbstractLightExampleApplication extends MinkoExampleApplication
	{
		[Embed(source="../assets/textures/brickwork-texture.jpg")]
		private static const BRICK_DIFFUSE	: Class;
		[Embed(source="../assets/textures/brickwork_normal-map.jpg")]
		private static const BRICK_NORMALS	: Class;
		
		private var _teapotGroup		: Group;
		
		private var _cubeMaterial		: PhongMaterial;
		private var _teapotsMaterial	: Material;
		
		public function get cubeMaterial() : PhongMaterial
		{
			return _cubeMaterial;
		}
		
		override protected function initializeScene() : void
		{
			super.initializeScene();
			
			cameraController.distance = 100;
			cameraController.distanceStep = 0;
			
			var mat : PhongMaterial = new PhongMaterial(scene);
			
			mat.castShadows = true;
			mat.receiveShadows = true;
			
			_cubeMaterial = mat.clone() as PhongMaterial;
			
			var bigCube : Mesh = new Mesh(new CubeGeometry(), _cubeMaterial);
			
			bigCube.geometry
				.computeTangentSpace()
				.flipNormals()
				.disposeLocalData();
			bigCube.transform.setScale(200, 200, 200);
			_cubeMaterial.diffuseMap = TextureLoader.loadClass(BRICK_DIFFUSE);
			_cubeMaterial.normalMap = TextureLoader.loadClass(BRICK_NORMALS);
			_cubeMaterial.normalMappingType = NormalMappingType.NORMAL;
			_cubeMaterial.diffuseMultiplier = 0.5;
			_cubeMaterial.ambientMultiplier = 0.5;
			_cubeMaterial.triangleCulling = TriangleCulling.FRONT;
			_cubeMaterial.diffuseColor = 0xbbbbbbff;
			_cubeMaterial.castShadows = false;
			
			scene.addChild(bigCube);
			
			var teapotGeometry : TeapotGeometry = new TeapotGeometry(8);
			
			teapotGeometry.computeNormals().disposeLocalData();
			
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
			
			initializeLights();
		}
		
		protected function initializeLights() : void
		{
			scene.addChild(new AmbientLight(0xffffffff, 0.6));
		}
		
		override protected function enterFrameHandler(e : Event):void
		{
			super.enterFrameHandler(e);
			
			_teapotGroup.transform.appendRotation(0.01, Vector4.Y_AXIS);
		}
	}
}