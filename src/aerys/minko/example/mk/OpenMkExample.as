package aerys.minko.example.mk
{
	import aerys.minko.physics.World;
	import aerys.minko.physics.api.ColliderController;
	import aerys.minko.physics.constraint.force.DirectionalLinearConstantForce;
	import aerys.minko.render.Viewport;
	import aerys.minko.render.material.Material;
	import aerys.minko.render.material.basic.BasicMaterial;
	import aerys.minko.render.material.basic.BasicProperties;
	import aerys.minko.render.material.phong.PhongMaterial;
	import aerys.minko.scene.controller.camera.ArcBallController;
	import aerys.minko.scene.node.ISceneNode;
	import aerys.minko.scene.node.Scene;
	import aerys.minko.scene.node.camera.Camera;
	import aerys.minko.scene.node.light.AmbientLight;
	import aerys.minko.scene.node.light.PointLight;
	import aerys.minko.type.enum.TriangleCulling;
	import aerys.minko.type.loader.SceneLoader;
	import aerys.minko.type.loader.parser.ParserOptions;
	import aerys.minko.type.math.Vector4;
	import aerys.minko.type.parser.mk.MKParser;
	
	import com.bit101.components.Panel;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	
	public class OpenMkExample extends Sprite
	{
//		[Embed(source="/sponza/Sponza_lite.mk", mimeType="application/octet-stream")]
//		[Embed(source="BP/23092013/environment_terrain_60_60.mk", mimeType="application/octet-stream")]
		[Embed(source="BP/nofallback/environment_terrain_60_60.mk", mimeType="application/octet-stream")]
		private static const MK : Class;
		
		private var _viewport 	: Viewport 	= new Viewport(2);
		private var _scene		: Scene		= new Scene();
		private var _camera		: Camera;
		private var _cameraController:ArcBallController;
		
		private var _materialDict	: Dictionary = new Dictionary();
		
		
		private function initializeMaterialDictionary() : void
		{
			_materialDict["mat_terrain_default"] = new PhongMaterial( {diffuseColor: 0xff0000ff});
			_materialDict["mat_building_default"] = new PhongMaterial( {diffuseColor: 0x888888ff});
			_materialDict["mat_city_default"] = new PhongMaterial( {diffuseColor: 0x555555ff});
			_materialDict["mat_sky_default"] = new PhongMaterial( {diffuseColor: 0x0000ffff});
			_materialDict["mat_city_alpha"] = new PhongMaterial( {diffuseColor: 0x770000ff});
			_materialDict["mat_water_default"] = new PhongMaterial( {diffuseColor: 0x000077ff});
			_materialDict["fallbackMaterial"] = new PhongMaterial( {diffuseColor: 0xffffffff});
			
			for each (var m : Object in _materialDict)
			{
				var mat : Material = Material(m);
				mat.setProperty(BasicProperties.TRIANGLE_CULLING, TriangleCulling.NONE);
			}
		}
		
		private function myMaterialFunction(materialName	: String,
											material		: Material) : Material
		{
			trace("material name = " + materialName);
			
			var mat : Material = _materialDict[materialName];
			if (mat == null)
				throw new Error("could not find associated material");
			
			return _materialDict[materialName];
			
//			return new BasicMaterial({ diffuseColor: 0xff0000ff }) as Material;
		}
		
		private function initializeLighting() : void
		{
			var plight : PointLight = new PointLight();
			plight.color = 0xffffffff;
			plight.transform.setTranslation(20, 20, -20);
			_scene.addChild(plight);
			
			var aLight	: AmbientLight = new AmbientLight();
			aLight.color = 0xffffffff;
			aLight.ambient	= 0.5;
			_scene.addChild(aLight);
		}
		
		public function OpenMkExample()
		{
			if (stage)
				initialize();
			else
				addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		public function initialize(event : Event = null) : void
		{
			initializeMaterialDictionary();
			initializeLighting();
			
			removeEventListener(Event.ADDED_TO_STAGE, initialize);
			stage.addChildAt(_viewport, 0);
			_viewport.backgroundColor = 0x666666ff;
			
			initializeScene();
			
			stage.frameRate = 30;
			stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			
			_camera = new Camera();
			_cameraController = new ArcBallController();
			_cameraController.bindDefaultControls(_viewport);
			_cameraController.minDistance = 1;
			_cameraController.yaw = Math.PI * -.5;
			_cameraController.pitch = Math.PI / 2;
			_cameraController.distance = 5;
			_camera.addController(_cameraController);
			
			_scene.addChild(_camera);
		}
		
		protected function initializeScene() : void
		{			
			// register plugin & parser
			MKParser.registerPluginController(ColliderController, ColliderController.MK_ENTRY_NAME);
			SceneLoader.registerParser(MKParser);

			// create physics world
			var physicsWorld : World = new World();
			physicsWorld.addGlobalForceGenerator(new DirectionalLinearConstantForce(new Vector4(0, -9.81)));
			_scene.addController(physicsWorld);
			
			// load file
			var options : ParserOptions		= new ParserOptions();
			options.material				= new PhongMaterial();
			options.materialFunction	=  myMaterialFunction;
			_scene.loadClass(MK, options).complete.add(sceneLoaded);
		}
		
		private function sceneLoaded(sceneLoader : SceneLoader, dat : ISceneNode) : void
		{
			var _cameraController : ArcBallController = new ArcBallController();
			_cameraController.bindDefaultControls(_viewport);
			_cameraController.minDistance = 1;
			_cameraController.yaw = Math.PI * -.5;
			_cameraController.pitch = Math.PI / 2 - 0.2;
			_cameraController.distance = 2.5;
			_scene.activeCamera.addController(_cameraController);
		}
		
		protected function enterFrameHandler(event : Event) : void
		{
			_scene.render(_viewport);
		}
	}
}
