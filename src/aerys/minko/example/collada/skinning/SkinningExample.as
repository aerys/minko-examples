package aerys.minko.example.collada.skinning
{
	import aerys.minko.render.geometry.stream.StreamUsage;
	import aerys.minko.scene.node.Group;
	import aerys.minko.type.animation.SkinningMethod;
	import aerys.minko.type.loader.ILoader;
	import aerys.minko.type.loader.TextureLoader;
	import aerys.minko.type.loader.parser.ParserOptions;
	import aerys.minko.type.parser.collada.ColladaParser;

	public final class SkinningExample extends AbstractExampleApplication
	{
		[Embed(source="../assets/pirate/pirate.dae", mimeType="application/octet-stream")]
		private static const DAE		: Class;
		
		[Embed(source="../assets/pirate/pirate_diffuse.jpg")]
		private static const TEXTURE	: Class;
		
		private var _onlineSkinnedGroup	: Group	= null;
		private var _staticSkinnedGroup	: Group	= null;
		
		override protected function initializeScene() : void
		{
			super.initializeScene();

			stage.frameRate = 60;

			cameraController.distance = 250;
			cameraController.yaw = 1.;
			cameraController.distanceStep = 0.02;
			cameraController.lookAt.set(0, 75, 0);
			
			var options : ParserOptions = new ParserOptions();
			options.parser						= ColladaParser;
			options.mipmapTextures				= true;
			options.assets						= scene.assets;
			options.dependencyLoaderFunction	= loadDependency;
			options.vertexStreamUsage			= StreamUsage.DYNAMIC;
			options.skinningMethod				= SkinningMethod.HARDWARE_MATRIX;
			options.flattenSkinning				= false;
			
			_onlineSkinnedGroup	= new Group();
			_onlineSkinnedGroup.loadClass(DAE, options);
			_onlineSkinnedGroup.transform.setTranslation(50.0, 0.0, 0.0);
			
			scene.addChild(_onlineSkinnedGroup);
			
			options.flattenSkinning		= true;
			options.skinningNumFps		= 120;
			
			_staticSkinnedGroup	= new Group();
			_staticSkinnedGroup.loadClass(DAE, options);
			_staticSkinnedGroup.transform.setTranslation(-50.0, 0.0, 0.0);
			
			scene.addChild(_staticSkinnedGroup);
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