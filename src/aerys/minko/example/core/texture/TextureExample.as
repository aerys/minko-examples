package aerys.minko.example.core.texture
{
	import aerys.minko.render.effect.Effect;
	import aerys.minko.render.effect.basic.BasicShader;
	import aerys.minko.scene.node.mesh.primitive.CubeMesh;
	import aerys.minko.type.loader.TextureLoader;

	public class TextureExample extends MinkoExampleApplication
	{
		[Embed("../assets/checker.jpg")]
		private static const ASSET_TEXTURE	: Class;
		
		override protected function initializeScene() : void
		{
			scene.addChild(
				new CubeMesh(
					new Effect(new BasicShader()),
					{ "diffuse map" : TextureLoader.loadClass(ASSET_TEXTURE) }
				)
			);
		}
	}
}