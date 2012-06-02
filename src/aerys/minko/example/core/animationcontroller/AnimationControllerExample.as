package aerys.minko.example.core.animationcontroller
{
	import aerys.minko.render.effect.Effect;
	import aerys.minko.render.effect.basic.BasicShader;
	import aerys.minko.scene.controller.AnimationController;
	import aerys.minko.scene.node.mesh.Mesh;
	import aerys.minko.scene.node.mesh.geometry.primitive.CubeGeometry;
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
					{ diffuseMap : TextureLoader.loadClass(EMBED_TEXTURE) },
					new Effect(new BasicShader),
					new AnimationController(
						new <ITimeline>[new MatrixRegularTimeline("transform", 1000, matrices)]
					)
				)
			);
		}
	}
}