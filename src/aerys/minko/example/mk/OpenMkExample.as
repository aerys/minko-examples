package aerys.minko.example.mk
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import aerys.minko.physics.World;
	import aerys.minko.physics.api.ColliderController;
	import aerys.minko.physics.constraint.force.DirectionalLinearConstantForce;
	import aerys.minko.render.Viewport;
	import aerys.minko.render.material.phong.PhongMaterial;
	import aerys.minko.scene.controller.camera.ArcBallController;
	import aerys.minko.scene.node.ISceneNode;
	import aerys.minko.scene.node.Scene;
	import aerys.minko.scene.node.camera.Camera;
	import aerys.minko.type.loader.SceneLoader;
	import aerys.minko.type.loader.parser.ParserOptions;
	import aerys.minko.type.math.Vector4;
	import aerys.minko.type.parser.mk.MKParser;
	
	public class OpenMkExample extends Sprite
	{
		[Embed(source="/sponza/Sponza_lite.mk", mimeType="application/octet-stream")]
		private static const MK : Class;
		
		private var _viewport 	: Viewport 	= new Viewport(2);
		private var _scene		: Scene		= new Scene();
		private var _camera		: Camera;
		private var _cameraController:ArcBallController;
		
		public function OpenMkExample()
		{
			if (stage)
				initialize();
			else
				addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		public function initialize(event : Event = null) : void
		{
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
