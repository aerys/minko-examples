package aerys.minko.example.collada.seymourplane
{
	import aerys.minko.scene.node.IScene;
	import aerys.minko.scene.node.group.LoaderGroup;
	import aerys.minko.scene.node.group.TransformGroup;
	import aerys.minko.type.parser.ParserOptions;
	import aerys.minko.type.parser.collada.ColladaParser;
	
	import flash.net.URLRequest;

	public class SeymourPlaneExample extends MinkoExampleApplication
	{
		override protected function initializeScene():void
		{
			LoaderGroup.registerParser("dae", ColladaParser);
			
			var plane 	: LoaderGroup 	= new LoaderGroup();
			var options : ParserOptions = new ParserOptions();
			
			options.loadTextures = true;
			options.loadFunction = function(request : URLRequest, options : ParserOptions) : IScene
			{
				request.url = "../assets/seymour_plane/" + request.url.match(/^.*\/([^\/]+)\..*$/)[1]
							  + ".jpg";
				
				return LoaderGroup.load(request, options);
			};
			
			plane.load(new URLRequest("../assets/seymour_plane/seymourplane.dae"), options);
			
			// tune 3D transform
			var tg : TransformGroup = new TransformGroup(plane);
			
			tg.transform.appendScale(.3, .3, -.3)
			
			scene.addChild(tg);
		}
	}
}