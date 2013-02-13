package 
{
	import aerys.minko.render.geometry.primitive.CubeGeometry;
	import aerys.minko.render.geometry.primitive.TeapotGeometry;
	import aerys.minko.render.material.Material;
	import aerys.minko.render.material.phong.PhongMaterial;
	import aerys.minko.scene.node.Group;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.scene.node.light.AmbientLight;
	import aerys.minko.type.enum.NormalMappingType;
	import aerys.minko.type.loader.TextureLoader;
	import aerys.minko.type.math.Vector4;
	
	import flash.events.Event;
	
	public class AbstractLightExampleApplication extends AbstractExampleApplication
	{
		[Embed(source="../assets/sponza_bricks/spnza_bricks_a_diff.jpg")]
		private static const BRICK_DIFFUSE	: Class;
		[Embed(source="../assets/sponza_bricks/spnza_bricks_a_ddn.jpg")]
		private static const BRICK_NORMALS	: Class;
        [Embed(source="../assets/sponza_bricks/spnza_bricks_a_spec.jpg")]
        private static const BRICK_SPECULAR	: Class;
		
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
			cameraController.yaw = -1.;
			cameraController.distanceStep = 0;
			
			var mat : PhongMaterial = new PhongMaterial();
			
			mat.castShadows = true;
			mat.receiveShadows = true;
			
			_cubeMaterial = mat.clone() as PhongMaterial;
			
			var bigCube : Mesh = new Mesh(new CubeGeometry(), _cubeMaterial);
			
			bigCube.geometry
				.computeTangentSpace()
				.invertWinding()
                .flipNormals()
				.disposeLocalData();
			bigCube.transform.setScale(200, 200, 200);
			_cubeMaterial.diffuseMap = TextureLoader.loadClass(BRICK_DIFFUSE);
			_cubeMaterial.normalMap = TextureLoader.loadClass(BRICK_NORMALS);
            _cubeMaterial.specularMap = TextureLoader.loadClass(BRICK_SPECULAR);
            _cubeMaterial.uvScale = new Vector4(3, 3);
			_cubeMaterial.normalMappingType = NormalMappingType.NORMAL;
			_cubeMaterial.diffuseMultiplier = 0.5;
			_cubeMaterial.ambientMultiplier = 0.5;
			_cubeMaterial.diffuseColor = 0xbbbbbbff;
			_cubeMaterial.castShadows = false;
			
			scene.addChild(bigCube);
			
			var teapotGeometry : TeapotGeometry = new TeapotGeometry(4);
			
			teapotGeometry.computeNormals().disposeLocalData();
			
			_teapotGroup = new Group();
			
			for (var teapotId : uint = 0; teapotId < 50; ++teapotId)
			{
				var smallTeapot : Mesh = new Mesh(
                    teapotGeometry,
                    mat.clone() as Material,
                    'teapot'
                );
				
				smallTeapot.material.diffuseColor = ((Math.random() * 0xffffff) << 8) | 0xff;
				
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