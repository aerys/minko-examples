package aerys.minko.example.core.controller
{
	import aerys.minko.render.effect.Effect;
	import aerys.minko.render.effect.basic.BasicShader;
	import aerys.minko.scene.controller.AnimationController;
	import aerys.minko.scene.node.Group;
	import aerys.minko.scene.node.ISceneNode;
	import aerys.minko.scene.node.mesh.Mesh;
	import aerys.minko.scene.node.mesh.geometry.primitive.CubeGeometry;
	import aerys.minko.type.animation.timeline.ITimeline;
	import aerys.minko.type.animation.timeline.MatrixRegularTimeline;
	import aerys.minko.type.loader.TextureLoader;
	import aerys.minko.type.math.Matrix4x4;
	import aerys.minko.type.math.Vector4;
	
	import flash.events.Event;
	import flash.net.URLRequest;

	public class ControllerExample extends MinkoExampleApplication
	{
		[Embed("../assets/checker.jpg")]
		private static const EMBED_TEXTURE : Class;
		
		override protected function initializeScene():void
		{
			var cube : Group = new Group(
				new Mesh(
					CubeGeometry.cubeGeometry,
					{ diffuseMap : TextureLoader.loadClass(EMBED_TEXTURE) }
				)
			);
		
			scene.addChild(cube);
			
			var matrices : Vector.<Matrix4x4>	= new <Matrix4x4>[
				new Matrix4x4(),
				new Matrix4x4(),
				new Matrix4x4()
			];
		
			matrices[0].appendTranslation(-1);
			matrices[1].appendTranslation(1)
					   .prependRotation(Math.PI, Vector4.Y_AXIS);
			matrices[2].appendTranslation(-1)
					   .prependRotation(Math.PI * 2, Vector4.Y_AXIS);
			
			cube.addController(
				new AnimationController(
					new <ITimeline>[new MatrixRegularTimeline("transform", 1000, matrices)]
				)
			);
		}
		
		override protected function enterFrameHandler(event : Event) : void
		{
			super.enterFrameHandler(event);
		}
	}
}