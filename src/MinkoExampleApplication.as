package
{
	import aerys.minko.Minko;
	import aerys.minko.render.Viewport;
	import aerys.minko.scene.controller.camera.ArcBallController;
	import aerys.minko.scene.node.Camera;
	import aerys.minko.scene.node.OrientationAxis;
	import aerys.minko.scene.node.Scene;
	import aerys.minko.type.log.DebugLevel;
	import aerys.monitor.Monitor;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class MinkoExampleApplication extends Sprite
	{
		private var _viewport			: Viewport			= new Viewport(2);
		private var _camera				: Camera			= null;
		private var _cameraController	: ArcBallController	= null;
		
		private var _scene				: Scene				= new Scene();
		
		private var _cursor				: Point				= new Point();
		
		protected function get viewport() : Viewport
		{
			return _viewport;
		}
		
		protected function get camera() : Camera
		{
			return _camera;
		}
		
		protected function get cameraController() : ArcBallController
		{
			return _cameraController;
		}
		
		protected function get scene() : Scene
		{
			return _scene;
		}
		
		public function MinkoExampleApplication()
		{
			if (stage)
				initialize();
			else
				addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		private function initialize(event : Event = null) : void
		{
			removeEventListener(Event.ADDED_TO_STAGE, initialize);
			
			Minko.debugLevel = DebugLevel.SHADER_AGAL;
			
			addChild(_viewport);
			_viewport.backgroundColor = 0x666666ff;
			
			initializeScene();
			initializeUI();
			
			stage.frameRate = 60;
			stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		protected function initializeScene() : void
		{
			_camera = new Camera();
			_cameraController = new ArcBallController();
			_cameraController.bindDefaultControls(stage);
			_cameraController.yaw = Math.PI * -.5;
			_cameraController.pitch = Math.PI / 2;
			_cameraController.distance = 5;
			camera.addController(_cameraController);
			
			_scene.addChild(camera);
			
//			_scene.addChild(new OrientationAxis());
		}
		
		protected function initializeUI() : void
		{
			stage.addChild(Monitor.monitor.watch(_scene, ['numDescendants', 'numTriangles', 'numPasses']));
		}
		
		protected function enterFrameHandler(event : Event) : void
		{
			_scene.render(_viewport);
		}
	}
}