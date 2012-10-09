package aerys.minko.example.collada.seymourplane
{
	import aerys.minko.type.loader.ILoader;
	import aerys.minko.type.loader.SceneLoader;
	import aerys.minko.type.loader.TextureLoader;
	import aerys.minko.type.loader.parser.ParserOptions;
	import aerys.minko.type.parser.collada.ColladaParser;
	
	import flash.net.URLRequest;

	public class SeymourPlaneExample extends MinkoExampleApplication
	{
		override protected function initializeScene() : void
		{
			super.initializeScene();
			
			cameraController.distance = 30;
			cameraController.distanceStep = 1;
			
			var options : ParserOptions		= new ParserOptions();
			
			options.parser						= ColladaParser;
			options.mipmapTextures				= true;
			options.dependencyLoaderFunction	= dependencyLoader;
			
			scene.load(new URLRequest("../assets/seymour_plane/seymourplane.DAE"), options);
		}
		
		private function dependencyLoader(dependencyPath	: String,
										  isTexture			: Boolean,
										  options			: ParserOptions) : ILoader
		{
			var loader : ILoader;
			
			if (isTexture)
			{
				var correctedURL : String = "../assets/seymour_plane/" 
					+ dependencyPath.match(/^.*\/([^\/]+)\..*$/)[1]
					+ ".jpg";
				
				loader = new TextureLoader(true);
				loader.load(new URLRequest(correctedURL));
			}
			else
			{
				loader = new SceneLoader(options);
				loader.load(new URLRequest(dependencyPath));
			}
			
			return loader;
		}
	}
}

