package aerys.minko.example.core.texture
{
	import aerys.minko.Minko;
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
			Minko.debugLevel = DebugLevel.SHADER_AGAL;
			
			var m1 : Mesh = new Mesh(
				CubeGeometry.cubeGeometry,
				{
					diffuseMap 			: TextureLoader.loadClass(ASSET_TEXTURE),
					diffuseFiltering	: SamplerFiltering.NEAREST
				}
			);
			
			m1.transform.appendTranslation(1);
			
			var m2 : Mesh = new Mesh(
				CubeGeometry.cubeGeometry,
				{
					diffuseMap 			: TextureLoader.loadClass(ASSET_TEXTURE),
					diffuseFiltering	: SamplerFiltering.LINEAR
				}
			);
			
			m2.transform.appendTranslation(-1);
			
			scene.addChild(m1).addChild(m2);
		}
	}
}