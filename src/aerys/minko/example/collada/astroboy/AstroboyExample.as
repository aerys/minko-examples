package aerys.minko.example.collada.astroboy
{
	import aerys.minko.render.effect.Effect;
	import aerys.minko.render.effect.basic.ColorShader;
	import aerys.minko.scene.node.ISceneNode;
	import aerys.minko.type.loader.ILoader;
	import aerys.minko.type.loader.SceneLoader;
	import aerys.minko.type.loader.parser.ParserOptions;
	import aerys.minko.type.parser.collada.ColladaParser;
	
	import flash.net.URLRequest;

	public class AstroboyExample extends MinkoExampleApplication
	{
		override protected function initializeScene():void
		{
			var options : ParserOptions		= new ParserOptions();
			
			options.parser					= ColladaParser;
			options.loadDependencies		= true;
			options.mipmapTextures			= true;
			options.effect					= new Effect(new TextureShader());
			options.dependencyURLRewriter	= function(s : String) : String
			{
				return "../assets/seymour/boy_10.jpg";
			};
			
			var loader : SceneLoader = new SceneLoader(options);
			loader.complete.add(onLoadComplete);
			loader.load(new URLRequest("../assets/seymour/astroboy.dae"));
		}
		
		private function onLoadComplete(loader : ILoader, result : ISceneNode) : void
		{
			scene.addChild(result);
		}
		
	}
}


import aerys.minko.render.shader.SFloat;
import aerys.minko.render.shader.ShaderTemplate;

class TextureShader extends ShaderTemplate
{
	override protected function getClipspacePosition():SFloat
	{
		return localToScreen(vertexXYZ);
	}
	
	override protected function getPixelColor():SFloat
	{
		return sampleTexture(getTextureParameter('diffuse'), interpolate(vertexUV));
	}
}