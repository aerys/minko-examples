package aerys.minko.example.core.spritesheet
{
	import aerys.minko.render.Effect;
	import aerys.minko.render.geometry.primitive.BillboardsGeometry;
	import aerys.minko.render.material.Material;
	import aerys.minko.scene.controller.animation.AnimationController;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.type.animation.timeline.ITimeline;
	import aerys.minko.type.animation.timeline.ScalarTimeline;
	import aerys.minko.type.loader.TextureLoader;

	public class SpritesheetExample extends AbstractExampleApplication
	{
		[Embed("../assets/explosion.png")]
		private static const ASSET_SPRITESHEET	: Class;
		
		override protected function initializeScene():void
		{
			super.initializeScene();
			
//			camera.position.z = -2;
			
			var m : Mesh = new Mesh(
				new BillboardsGeometry(1),
				new Material(
					new Effect(new SpritesheetShader()),
					{ diffuseMap : TextureLoader.loadClass(ASSET_SPRITESHEET) }
				)
			);

			m.addController(new AnimationController(new <ITimeline>[
				new ScalarTimeline(
					'material.spritesheetFrameId',
					new <uint>[0, 1000],
					new <Number>[0, 24]
				)
			]));
			
			scene.addChild(m);
		}
	}
}