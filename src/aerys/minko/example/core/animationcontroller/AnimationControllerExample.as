package aerys.minko.example.core.animationcontroller
{
	import aerys.minko.render.geometry.primitive.CubeGeometry;
	import aerys.minko.render.material.basic.BasicMaterial;
	import aerys.minko.scene.controller.AnimationController;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.type.animation.timeline.ITimeline;
	import aerys.minko.type.animation.timeline.MatrixTimeline;
	import aerys.minko.type.enum.Blending;
	import aerys.minko.type.loader.TextureLoader;
	import aerys.minko.type.math.HSLAMatrix4x4;
	import aerys.minko.type.math.Matrix4x4;

	public class AnimationControllerExample extends AbstractExampleApplication
	{
		[Embed("../assets/checker.jpg")]
		private static const EMBED_TEXTURE : Class;
		
		override protected function initializeScene() : void
		{
			super.initializeScene();
			
//			cameraController.enabled = false;
			
            var time : Vector.<uint> = new <uint>[0, 1000, 2000];
            
			var transforms : Vector.<Matrix4x4>	= new <Matrix4x4>[
				new Matrix4x4(),
				new Matrix4x4().appendScale(0.5, 0.5, 0.5),
				new Matrix4x4()
			];
			
			var colors : Vector.<Matrix4x4> = new <Matrix4x4>[
                new HSLAMatrix4x4(),
                new HSLAMatrix4x4(0., 1., 1., .25),
                new HSLAMatrix4x4()
            ];;

			var animationCtrl : AnimationController = new AnimationController(
				new <ITimeline>[
					new MatrixTimeline('transform', time, transforms, true, true),
					new MatrixTimeline('material.diffuseTransform', time, colors, true, true, true)
				]
			);
			
			var cube : Mesh = new Mesh(
				CubeGeometry.cubeGeometry,
				new BasicMaterial({
					diffuseMap 			: TextureLoader.loadClass(EMBED_TEXTURE),
					diffuseColor		: 0xffffffff,
					diffuseTransform	: new HSLAMatrix4x4(),
					blending			: Blending.ALPHA
				})
			);
			
			cube.addController(animationCtrl);
			
			scene.addChild(cube);
		}
	}
}