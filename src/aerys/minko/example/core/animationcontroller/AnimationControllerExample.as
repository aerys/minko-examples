package aerys.minko.example.core.animationcontroller
{
	import aerys.minko.render.geometry.primitive.CubeGeometry;
	import aerys.minko.render.material.basic.BasicMaterial;
	import aerys.minko.scene.controller.AnimationController;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.type.animation.timeline.ITimeline;
	import aerys.minko.type.animation.timeline.MatrixRegularTimeline;
	import aerys.minko.type.animation.timeline.ScalarRegularTimeline;
	import aerys.minko.type.enum.Blending;
	import aerys.minko.type.loader.TextureLoader;
	import aerys.minko.type.math.HLSAMatrix4x4;
	import aerys.minko.type.math.Matrix4x4;

	public class AnimationControllerExample extends AbstractExampleApplication
	{
		[Embed("../assets/checker.jpg")]
		private static const EMBED_TEXTURE : Class;
		
		override protected function initializeScene() : void
		{
			super.initializeScene();
			
//			cameraController.enabled = false;
			
			var transforms : Vector.<Matrix4x4>	= new <Matrix4x4>[
				new Matrix4x4(),
				new Matrix4x4().appendScale(0.5, 0.5, 0.5),
				new Matrix4x4()
			];
			
			var alphas : Vector.<Number> = new <Number>[1., .25, 1.];

			var animationCtrl : AnimationController = new AnimationController(
				new <ITimeline>[
					new MatrixRegularTimeline('transform', 1000, transforms, true),
					new ScalarRegularTimeline('material.diffuseTransform.alpha', 1000, alphas)
				]
			);
			
			var cube : Mesh = new Mesh(
				CubeGeometry.cubeGeometry,
				new BasicMaterial({
					diffuseMap 			: TextureLoader.loadClass(EMBED_TEXTURE),
					diffuseColor		: 0xffffffff,
					diffuseTransform	: new HLSAMatrix4x4(),
					blending			: Blending.ALPHA
				})
			);
			
			cube.addController(animationCtrl);
			
			scene.addChild(cube);
		}
	}
}