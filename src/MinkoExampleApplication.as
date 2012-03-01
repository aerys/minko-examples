package
{
	import aerys.minko.render.Viewport;
	import aerys.minko.scene.controller.ArcBallController;
	import aerys.minko.scene.node.Camera;
	import aerys.minko.scene.node.Group;
	import aerys.minko.scene.node.Scene;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class MinkoExampleApplication extends Sprite
	{
		private var _viewport			: Viewport			= null;
		private var _camera				: Camera			= null;
		private var _cameraController	: ArcBallController	= null;
		private var _scene				: Scene				= new Scene();
		
		private var _cursor				: Point				= new Point();
		
		protected function get viewport() : Viewport
		{
			return _viewport;
		}
		
		protected function get scene() : Scene
		{
			return _scene;
		}
		
		protected function get camera() : Camera
		{
			return _camera;
		}

		protected function get cameraController() : ArcBallController
		{
			return _cameraController;
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
			
			_viewport = new Viewport(stage);
			
			_camera = new Camera(_viewport);
			_camera.lookAt.set(0., 0., 0.);
			_camera.position.set(0., 0., -5.);
			
			var cameraGroup : Group = new Group(_camera);
			
			_cameraController = new ArcBallController();
			_cameraController.bindDefaultControls(stage);
			cameraGroup.addController(_cameraController);
			
			_scene.addChild(cameraGroup);
			
			initializeScene();
			
			stage.frameRate = 60;
//			stage.addChild(_viewport);
			/*stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);*/
			stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		protected function initializeScene() : void
		{
			// nothing
		}
		
		protected function enterFrameHandler(event : Event) : void
		{
			_viewport.render(_scene);
		}
		
		/*protected function mouseMoveHandler(event : MouseEvent) : void
		{
			// nothing
		}
		
		protected function mouseWheelHandler(event : MouseEvent) : void
		{
			// nothing
		}
		
		protected function keyDownHandler(event : KeyboardEvent) : void
		{
			// nothing
		}*/
	}
}