package aerys.minko.example.core.texture
{
	import aerys.minko.render.effect.Effect;
	import aerys.minko.render.effect.basic.BasicShader;
	import aerys.minko.scene.node.mesh.Mesh;
	import aerys.minko.scene.node.mesh.geometry.primitive.CubeGeometry;
	import aerys.minko.type.loader.TextureLoader;

	public class TextureExample extends MinkoExampleApplication
	{
		[Embed("../assets/checker.jpg")]
		private static const ASSET_TEXTURE	: Class;
		
		override protected function initializeScene() : void
		{
			scene.addChild(
				new Mesh(
					CubeGeometry.cubeGeometry,
					{ diffuseMap : TextureLoader.loadClass(ASSET_TEXTURE) }
				)
			);
		}
	}
}