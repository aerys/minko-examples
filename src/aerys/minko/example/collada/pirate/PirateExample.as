package aerys.minko.example.collada.pirate
{
	import aerys.minko.render.geometry.stream.StreamUsage;
	import aerys.minko.type.animation.SkinningMethod;
	import aerys.minko.type.loader.ILoader;
	import aerys.minko.type.loader.TextureLoader;
	import aerys.minko.type.loader.parser.ParserOptions;
	import aerys.minko.type.parser.collada.ColladaParser;
	
	public class PirateExample extends AbstractExampleApplication
	{
		[Embed(source="../assets/pirate/pirate.dae", mimeType="application/octet-stream")]
		private static const DAE : Class;
		
		[Embed(source="../assets/pirate/pirate_diffuse.jpg")]
		private static const TEXTURE : Class;
		
		override protected function initializeScene() : void
		{
			super.initializeScene();
			
			cameraController.distance = 250;
			cameraController.yaw = 1.;
			cameraController.distanceStep = 0.02;
			cameraController.lookAt.set(0, 75, 0);
			
			var options : ParserOptions		= new ParserOptions();
			
			options.parser						= ColladaParser;
			options.mipmapTextures				= true;
			options.dependencyLoaderFunction	= loadDependency;
			options.vertexStreamUsage			= StreamUsage.DYNAMIC;
			options.skinningMethod				= SkinningMethod.HARDWARE_MATRIX;
			
			scene.loadClass(DAE, options);
		}
		
		protected function loadDependency(dependencyId 		: String,
										  dependencyPath	: String,
										  isTexture			: Boolean,
										  options			: ParserOptions) : ILoader
		{
			var loader : ILoader = new TextureLoader(options.mipmapTextures)
			
			loader.loadClass(TEXTURE);
			
			return loader;
		}
	}
}
