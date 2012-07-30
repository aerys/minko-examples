package aerys.minko.example.core.animationcontroller
{
	import aerys.minko.render.geometry.primitive.CubeGeometry;
	import aerys.minko.render.material.basic.BasicMaterial;
	import aerys.minko.scene.controller.AnimationController;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.type.animation.timeline.ITimeline;
	import aerys.minko.type.animation.timeline.MatrixRegularTimeline;
	import aerys.minko.type.loader.TextureLoader;
	import aerys.minko.type.math.Matrix4x4;
	import aerys.minko.type.math.Vector4;

	public class AnimationControllerExample extends MinkoExampleApplication
	{
		[Embed("../assets/checker.jpg")]
		private static const EMBED_TEXTURE : Class;
		
		override protected function initializeScene() : void
		{
//			cameraController.enabled = false;
			
			var matrices : Vector.<Matrix4x4>	= new <Matrix4x4>[
				new Matrix4x4().appendTranslation(-1),
				new Matrix4x4().appendTranslation(1)
							   .prependRotation(Math.PI, Vector4.Y_AXIS),
				new Matrix4x4().appendTranslation(-1)
							   .prependRotation(Math.PI * 2, Vector4.Y_AXIS)
			];
			
			scene.addChild(
				new Mesh(
					CubeGeometry.cubeGeometry,
					new BasicMaterial({diffuseMap : TextureLoader.loadClass(EMBED_TEXTURE)}),
					new AnimationController(
						new <ITimeline>[new MatrixRegularTimeline('transform', 1000, matrices)]
					)
				)
			);
		}
	}
}