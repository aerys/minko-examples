package aerys.minko.example.core.animationcontroller
{
	import aerys.minko.example.core.cubes.CubesExample;
	import aerys.minko.scene.controller.animation.AnimationController;
	import aerys.minko.scene.node.Group;
	import aerys.minko.scene.node.ISceneNode;
	import aerys.minko.type.animation.timeline.ITimeline;
	import aerys.minko.type.animation.timeline.MatrixTimeline;
	import aerys.minko.type.math.Matrix4x4;
	import aerys.minko.type.math.Vector4;

	public class AnimationControllerExample extends CubesExample
	{
		private var _animation	: AnimationController;
		
		override protected function initializeScene() : void
		{
			super.initializeScene();
			
            var time : Vector.<uint> = new <uint>[0, 1000, 2000];
            
			var transforms : Vector.<Matrix4x4>	= new <Matrix4x4>[
				new Matrix4x4(),
				new Matrix4x4().appendRotation(Math.PI, Vector4.Y_AXIS),
				new Matrix4x4().appendRotation(2 * Math.PI, Vector4.Y_AXIS)
			];
			
			_animation = new AnimationController(
				new <ITimeline>[
					new MatrixTimeline('transform', time, transforms, true)
				]
			);
		}
		
		override protected function createCube() : ISceneNode
		{
			var cube : ISceneNode = super.createCube();
			
			cube = new Group(cube);
			cube.addController(_animation);
			
			return cube;
		}
	}
}