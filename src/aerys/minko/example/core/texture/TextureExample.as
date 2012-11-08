package aerys.minko.example.core.texture
{
	import aerys.minko.render.geometry.primitive.CubeGeometry;
	import aerys.minko.render.material.basic.BasicMaterial;
	import aerys.minko.render.material.basic.BasicProperties;
	import aerys.minko.render.resource.texture.TextureResource;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.type.enum.Blending;
	import aerys.minko.type.enum.SamplerFiltering;
	import aerys.minko.type.enum.TriangleCulling;
	import aerys.minko.type.loader.TextureLoader;
	
	public class TextureExample extends AbstractExampleApplication
	{
		[Embed("../assets/checker.jpg")]
		private static const ASSET_TEXTURE	: Class;
		
		[Embed (source="../assets/atf/leafNoAlpha.atf", mimeType="application/octet-stream")]
		private static const TEXTURE_DESKTOP_ONLY_DXT1 : Class;
		
		[Embed (source="../assets/atf/leafBlock.atf", mimeType="application/octet-stream")]
		private static const TEXTURE_DESKTOP_ONLY_DXT5 : Class;
		
		[Embed (source="../assets/atf/leaf.atf", mimeType="application/octet-stream")]
		private static const TEXTURE_ALL_PLATFORM_JPEGXR : Class;
		
		override protected function initializeScene() : void
		{
			super.initializeScene();
			
			var texture 		: TextureResource 		= TextureLoader.loadClass(ASSET_TEXTURE);
			var textureDX1 		: TextureResource		= TextureLoader.loadClass(TEXTURE_DESKTOP_ONLY_DXT1);
			var textureDX5 		: TextureResource		= TextureLoader.loadClass(TEXTURE_DESKTOP_ONLY_DXT5);
			var textureJPEFXR	: TextureResource		= TextureLoader.loadClass(TEXTURE_ALL_PLATFORM_JPEGXR);
			
			var m1 : Mesh = new Mesh(
				CubeGeometry.cubeGeometry,
				new BasicMaterial({
					diffuseMap 			: texture,
					diffuseFiltering	: SamplerFiltering.NEAREST
				})
			);
			
			m1.transform.appendTranslation(1);
			
			var m2 : Mesh = new Mesh(
				CubeGeometry.cubeGeometry,
				new BasicMaterial({
					diffuseMap 			: texture,
					diffuseFiltering	: SamplerFiltering.LINEAR
				})
			);
			
			m2.transform.appendTranslation(-1);
						
			var cubeDX1 : Mesh = new Mesh(
				CubeGeometry.cubeGeometry,
				new BasicMaterial({
					diffuseMap 		: textureDX1,
					diffuseFormat	: textureDX1.samplerFormat,
					blending		: Blending.ALPHA
				})
			);
			
			cubeDX1.transform.appendTranslation(-2, 2);

			var cubeDX5 : Mesh = new Mesh(
				CubeGeometry.cubeGeometry,
				new BasicMaterial({
					diffuseMap 		: textureDX5,
					diffuseFormat	: textureDX5.samplerFormat,
					blending		: Blending.ALPHA
				})
			);
			
			cubeDX5.transform.appendTranslation(0, 2);

			var cubeJPEGXR : Mesh = new Mesh(
				CubeGeometry.cubeGeometry,
				new BasicMaterial({
					diffuseMap 		: textureJPEFXR,
					diffuseFormat	: textureJPEFXR.samplerFormat,
					blending		: Blending.ALPHA
				})
			);
			
			cubeJPEGXR.transform.appendTranslation(2, 2);
			
			scene.addChild(m1)
				.addChild(m2)
				.addChild(cubeDX1)
				.addChild(cubeDX5)
				.addChild(cubeJPEGXR);
		}
	}
}