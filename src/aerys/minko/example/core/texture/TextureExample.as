package aerys.minko.example.core.texture
{
	import aerys.minko.Minko;
	import aerys.minko.render.resource.texture.TextureResource;
	import aerys.minko.scene.node.mesh.Mesh;
	import aerys.minko.scene.node.mesh.geometry.primitive.CubeGeometry;
	import aerys.minko.type.enum.SamplerFiltering;
	import aerys.minko.type.loader.TextureLoader;
	import aerys.minko.type.log.DebugLevel;

	public class TextureExample extends MinkoExampleApplication
	{
		[Embed("../assets/checker.jpg")]
		private static const ASSET_TEXTURE	: Class;
		
		override protected function initializeScene() : void
		{
			super.initializeScene();
			
			var texture : TextureResource = TextureLoader.loadClass(ASSET_TEXTURE);
			
			var m1 : Mesh = new Mesh(
				CubeGeometry.cubeGeometry,
				{
					diffuseMap 			: texture,
					diffuseFiltering	: SamplerFiltering.NEAREST
				}
			);
			
			m1.transform.appendTranslation(1);
			
			var m2 : Mesh = new Mesh(
				CubeGeometry.cubeGeometry,
				{
					diffuseMap 			: texture,
					diffuseFiltering	: SamplerFiltering.LINEAR
				}
			);
			
			m2.transform.appendTranslation(-1);
			
			scene.addChild(m1).addChild(m2);
		}
	}
}