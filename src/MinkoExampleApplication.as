package
{
	import aerys.minko.render.Viewport;
	import aerys.minko.scene.controller.camera.ArcBallController;
	import aerys.minko.scene.node.Camera;
	import aerys.minko.scene.node.Scene;
	import aerys.monitor.Monitor;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class MinkoExampleApplication extends Sprite
	{
		private var _viewport			: Viewport			= new Viewport(4);
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
			
			addChild(_viewport);
			_viewport.backgroundColor = 0;
			
			var camera		: Camera = new Camera(Math.PI / 4, 0.1, 200);
			var controller	: ArcBallController = new ArcBallController();
			controller.bindDefaultControls(stage);
			controller.theta = Math.PI / 3;
			controller.phi = Math.PI / 2;
			controller.distance = 10;
			camera.addController(controller);
			
			_scene.addChild(camera);
			initializeScene();
			initializeUI();
			
			stage.addChild(Monitor.monitor.watch(_scene, ['numDescendants', 'numTriangles']));
			stage.frameRate = 60;
			stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		protected function initializeScene() : void
		{
			// nothing
		}
		
		protected function initializeUI() : void
		{
			// nothing
		}
		
		protected function enterFrameHandler(event : Event) : void
		{
			_scene.render(_viewport);
		}
	}
}