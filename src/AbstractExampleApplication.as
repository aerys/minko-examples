package
{
	import aerys.minko.render.Viewport;
	import aerys.minko.scene.controller.camera.ArcBallController;
	import aerys.minko.scene.node.Scene;
	import aerys.minko.scene.node.camera.Camera;
	import aerys.monitor.Monitor;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class AbstractExampleApplication extends Sprite
	{
		private var _viewport			: Viewport			= new Viewport();
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
		
		public function AbstractExampleApplication()
		{
			if (stage)
				initialize();
			else
				addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		private function initialize(event : Event = null) : void
		{
			removeEventListener(Event.ADDED_TO_STAGE, initialize);

			stage.addChildAt(_viewport, 0);
			_viewport.backgroundColor = 0x666666ff;
			
			initializeScene();
			initializeUI();
			
			stage.frameRate = 30;
			stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		protected function initializeScene() : void
		{
			_camera = new Camera();
			_cameraController = new ArcBallController();
			_cameraController.bindDefaultControls(_viewport);
			_cameraController.minDistance = 1;
			_cameraController.yaw = Math.PI * -.5;
			_cameraController.pitch = Math.PI / 2;
			_cameraController.distance = 5;
			camera.addController(_cameraController);
			
			_scene.addChild(camera);
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