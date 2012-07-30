package aerys.minko.example.core.spritesheet
{
	import aerys.minko.render.Effect;
	import aerys.minko.render.geometry.primitive.BillboardsGeometry;
	import aerys.minko.render.material.Material;
	import aerys.minko.scene.controller.AnimationController;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.type.animation.timeline.ITimeline;
	import aerys.minko.type.animation.timeline.ScalarRegularTimeline;
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
				new Material(
					new Effect(new SpritesheetShader()),
					{ diffuseMap : TextureLoader.loadClass(ASSET_SPRITESHEET) }
				),
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