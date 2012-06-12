package aerys.minko.example.core.spritesheet
{
	import aerys.minko.render.effect.Effect;
	import aerys.minko.scene.controller.AnimationController;
	import aerys.minko.scene.node.mesh.Mesh;
	import aerys.minko.scene.node.mesh.geometry.primitive.BillboardsGeometry;
	import aerys.minko.type.animation.timeline.ITimeline;
	import aerys.minko.type.animation.timeline.ScalarRegularTimeline;
	import aerys.minko.type.enum.Blending;
	import aerys.minko.type.loader.TextureLoader;

	public class SpritesheetExample extends MinkoExampleApplication
	{
		[Embed("../assets/explosion.png")]
		private static const ASSET_SPRITESHEET	: Class;
		
		override protected function initializeScene():void
		{
			super.initializeScene();
			
//			camera.position.z = -2;
			
			scene.addChild(new Mesh(
				new BillboardsGeometry(1),
				{ diffuseMap : TextureLoader.loadClass(ASSET_SPRITESHEET) },
				new Effect(new SpritesheetShader()),
				new AnimationController(new <ITimeline>[
					new ScalarRegularTimeline(
						'properties.spritesheetFrameId',
						1000,
						new <Number>[0, 24]
					)
				])
			));
		}
	}
}