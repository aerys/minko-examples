package aerys.minko.example.collada.astroboy
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

	public class AstroboyExample extends MinkoExampleApplication
	{
		[Embed(source="../assets/seymour/astroboy.dae", mimeType="application/octet-stream")]
		private static const DAE : Class;
		
		[Embed (source="../assets/seymour/boy_10.jpg")]
		private static const TEXTURE : Class;
		
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
			loader.loadClass(DAE);
		}
		
		private function dependencyLoaderClosure(dependencyPath	: String,
												 isTexture		: Boolean,
												 options		: ParserOptions) : ILoader
		{
			var loader : ILoader = new TextureLoader(options.mipmapTextures)
				
			loader.loadClass(TEXTURE);
			
			return loader;
		}
		
		private function onLoadComplete(loader : ILoader, result : ISceneNode) : void
		{
			scene.addChild(result);
		}
	}
}
