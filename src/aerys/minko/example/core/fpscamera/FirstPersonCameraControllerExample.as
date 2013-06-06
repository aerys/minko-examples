package aerys.minko.example.core.fpscamera
{
	import com.bit101.utils.MinimalConfigurator;
	
	import flash.display.StageDisplayState;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	
	import aerys.minko.scene.controller.camera.FirstPersonCameraController;
	import aerys.minko.scene.node.light.AmbientLight;
	import aerys.minko.scene.node.light.DirectionalLight;
	import aerys.minko.type.math.Vector4;
	
	public class FirstPersonCameraControllerExample extends AbstractLightExampleApplication
	{
		private var _fpsCameraController	: FirstPersonCameraController	= null;
		
		override protected function initializeScene() : void
		{
			super.initializeScene();

			// Remove default ArcBallController and add a FirstPersonCameraController.
			_fpsCameraController = new FirstPersonCameraController(stage);
			camera.removeController(cameraController);
			camera.addController(_fpsCameraController);
			// Bind controls (use stage instead of viewport when using MouseLock API).
			_fpsCameraController.bindDefaultControls(stage);
			
			// Move back the camera.
			_fpsCameraController.walk(-99);
			
			// Handle fullscreen mode.
			stage.addEventListener(FullScreenEvent.FULL_SCREEN, fullScreenChangedHandler);			
		}
		
		protected override function initializeLights() : void
		{
			var ambientLight		: AmbientLight		= new AmbientLight(0xffffffff, 0.6);
			scene.addChild(ambientLight);
			
			var directionalLight	: DirectionalLight	= new DirectionalLight();
			directionalLight.transform.lookAt(Vector4.Z_AXIS, Vector4.ZERO);
			scene.addChild(directionalLight);
		}
		
		override protected function initializeUI() : void
		{
			var cfg : MinimalConfigurator = new MinimalConfigurator(this);
			
			cfg.parseXML(
				<comps>
					<PushButton label="FullScreen + Mouse lock" width="120"
								event="click:fullScreenClickHandler"/>
				</comps>
			);
		}
		
		public function fullScreenClickHandler(event : MouseEvent) : void
		{
			if (stage.displayState == StageDisplayState.FULL_SCREEN)
			{
				stage.displayState = StageDisplayState.NORMAL;
			}
			else
			{
				stage.displayState = StageDisplayState.FULL_SCREEN;
			}
		}
		
		public function fullScreenChangedHandler(event : FullScreenEvent) : void
		{
			// Enable mouse lock in fullscreen.
			if (event.fullScreen)
				stage.mouseLock = true;
		}
	}
}