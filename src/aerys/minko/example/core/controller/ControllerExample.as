package aerys.minko.example.core.controller
{
	import aerys.minko.scene.node.IScene;
	import aerys.minko.scene.node.ITransformableScene;
	import aerys.minko.scene.node.camera.Camera;
	import aerys.minko.scene.node.group.LoaderGroup;
	import aerys.minko.scene.node.group.TransformGroup;
	import aerys.minko.scene.node.mesh.primitive.CubeMesh;
	import aerys.minko.scene.node.texture.ColorTexture;
	import aerys.minko.type.animation.timeline.ITimeline;
	import aerys.minko.type.animation.timeline.MatrixLinearRegularTimeline;
	import aerys.minko.type.math.Matrix4x4;
	
	import flash.events.Event;
	import flash.net.URLRequest;
	import aerys.minko.type.controller.AnimationController;
	import aerys.minko.type.controller.ArcBallController;

	public class ControllerExample extends MinkoExampleApplication
	{
		private var _controller	: ArcBallController		= null;
		private var _ac			: AnimationController	= null;
		
		override protected function initializeScene():void
		{
			var camera : Camera = new Camera();
			var arcBallCamera : TransformGroup = new TransformGroup(camera);
			
			camera.lookAt.set(0., 0., 0.);
			camera.position.set(0., 0., -5.);
			
			_controller = new ArcBallController(arcBallCamera);
			_controller.bindDefaultControls(stage);
			
			var cube : TransformGroup = new TransformGroup(
				new LoaderGroup().load(new URLRequest("../assets/checker.jpg"))
								 .addChild(CubeMesh.cubeMesh)
			);
			
			scene.removeChild(this.camera)
				 .addChild(arcBallCamera)
				 .addChild(cube);
			
			var matrices : Vector.<Matrix4x4>	= new <Matrix4x4>[
				new Matrix4x4(),
				new Matrix4x4(),
				new Matrix4x4()
			];
			
			matrices[0].appendTranslation(-1);
			matrices[1].appendTranslation(1);
			matrices[2].appendTranslation(-1);
			
			_ac = new AnimationController(
				new <ITimeline>[new MatrixLinearRegularTimeline("transform", 1000, matrices)],
				new <IScene>[cube]
			);
		}
		
		override protected function enterFrameHandler(event : Event) : void
		{
			_ac.step(30);
			
			super.enterFrameHandler(event);
		}
	}
}