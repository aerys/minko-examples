package aerys.minko.example.collada.astroboy
{
	import aerys.minko.render.geometry.stream.StreamUsage;
	import aerys.minko.type.animation.SkinningMethod;
	import aerys.minko.type.loader.ILoader;
	import aerys.minko.type.loader.TextureLoader;
	import aerys.minko.type.loader.parser.ParserOptions;
	import aerys.minko.type.parser.collada.ColladaParser;

	public class AstroboyExample extends MinkoExampleApplication
	{
		[Embed(source="../assets/seymour/astroboy.dae", mimeType="application/octet-stream")]
		private static const DAE : Class;
		
		[Embed (source="../assets/seymour/boy_10.jpg")]
		private static const TEXTURE : Class;
		
		override protected function initializeScene() : void
		{
			super.initializeScene();
			
			cameraController.distance = 15;
			cameraController.distanceStep = 0.02;
			cameraController.lookAt.set(0, 3, 0);
			
			var options : ParserOptions		= new ParserOptions();
			
			options.parser						= ColladaParser;
			options.loadDependencies			= true;
			options.mipmapTextures				= true;
			options.dependencyLoaderFunction	= loadDependency;
			options.vertexStreamUsage			= StreamUsage.READ;
			options.skinningMethod				= SkinningMethod.SOFTWARE_MATRIX;
			
			scene.loadClass(DAE, options);
		}
		
		private function loadDependency(dependencyPath	: String,
										isTexture		: Boolean,
										options			: ParserOptions) : ILoader
		{
			var loader : ILoader = new TextureLoader(options.mipmapTextures)
				
			loader.loadClass(TEXTURE);
			
			return loader;
		}
	}
}
