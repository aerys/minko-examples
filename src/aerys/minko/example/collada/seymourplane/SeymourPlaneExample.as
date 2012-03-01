package aerys.minko.example.collada.seymourplane
{
	import aerys.minko.render.effect.Effect;
	import aerys.minko.render.effect.basic.BasicShader;
	import aerys.minko.scene.node.ISceneNode;
	import aerys.minko.type.loader.ILoader;
	import aerys.minko.type.loader.SceneLoader;
	import aerys.minko.type.loader.TextureLoader;
	import aerys.minko.type.loader.parser.ParserOptions;
	import aerys.minko.type.parser.collada.ColladaParser;
	
	import flash.net.URLRequest;

	public class SeymourPlaneExample extends MinkoExampleApplication
	{
		override protected function initializeScene():void
		{
			var options : ParserOptions		= new ParserOptions();
			
			options.parser					= ColladaParser;
			options.loadDependencies		= true;
			options.mipmapTextures			= true;
			options.effect					= new Effect(new BasicShader());
			options.dependencyLoaderClosure	= dependencyLoaderClosure;
			
			var loader : SceneLoader = new SceneLoader(options);
			loader.complete.add(onLoadComplete);
			loader.load(new URLRequest("../assets/seymour_plane/seymourplane.DAE"));
		}
		
		private function dependencyLoaderClosure(dependencyPath	: String,
												 isTexture		: Boolean,
												 options		: ParserOptions) : ILoader
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
		
		private function onLoadComplete(loader : ILoader, result : ISceneNode) : void
		{
			scene.addChild(result);
		}
	}
}

