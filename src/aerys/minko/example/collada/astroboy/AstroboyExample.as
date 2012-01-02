package aerys.minko.example.collada.astroboy
{
	import aerys.minko.render.effect.animation.AnimationStyle;
	import aerys.minko.scene.node.IScene;
	import aerys.minko.scene.node.group.LoaderGroup;
	import aerys.minko.scene.node.group.StyleGroup;
	import aerys.minko.scene.node.group.TransformGroup;
	import aerys.minko.type.animation.AnimationMethod;
	import aerys.minko.type.math.ConstVector4;
	import aerys.minko.type.parser.ParserOptions;
	import aerys.minko.type.parser.collada.ColladaParser;
	
	import flash.net.URLRequest;

	public class AstroboyExample extends MinkoExampleApplication
	{
		override protected function initializeScene():void
		{
			LoaderGroup.registerParser("dae", ColladaParser);
			
			var plane 	: LoaderGroup 	= new LoaderGroup();
			var options : ParserOptions = new ParserOptions();
			
			options.loadTextures = true;
			options.loadFunction = function(request : URLRequest, options : ParserOptions) : IScene
			{
				request.url = "../assets/seymour/" + request.url.match(/^.*\/([^\/]+)\..*$/)[1]
							  + ".jpg";
				
				return LoaderGroup.load(request, options);
			};
			
			plane.load(new URLRequest("../assets/seymour/astroboy.dae"), options);
			
			// tune 3D transform
			var tg : TransformGroup = new TransformGroup(plane);
			
			tg.transform
				.appendRotation(-Math.PI * 0.5, ConstVector4.X_AXIS)
				.appendScale(.5, .5, -.5)
				.appendTranslation(0.0, -1.5, 0.0);
			
			// enable animations
			var sg : StyleGroup = new StyleGroup(tg);
			
			sg.style.set(AnimationStyle.METHOD, AnimationMethod.DUAL_QUATERNION_SKINNING);
			
			scene.addChild(sg);
		}
	}
}