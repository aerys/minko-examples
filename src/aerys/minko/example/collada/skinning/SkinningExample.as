package aerys.minko.example.collada.skinning
{
	import aerys.minko.render.geometry.stream.StreamUsage;
	import aerys.minko.render.material.basic.BasicProperties;
	import aerys.minko.scene.controller.animation.MasterAnimationController;
	import aerys.minko.scene.node.Group;
	import aerys.minko.scene.node.ISceneNode;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.type.animation.SkinningMethod;
	import aerys.minko.type.enum.TriangleCulling;
	import aerys.minko.type.loader.ILoader;
	import aerys.minko.type.loader.SceneLoader;
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

			cameraController.distance = 4;
			cameraController.yaw = -Math.PI/2;
			cameraController.distanceStep = 0.02;
			cameraController.lookAt.set(0, 0.75, 0);
			
			var options : ParserOptions = new ParserOptions();
			options.parser						= ColladaParser;
			options.mipmapTextures				= true;
			options.assets						= scene.assets;
			options.dependencyLoaderFunction	= loadDependency;
			options.vertexStreamUsage			= StreamUsage.DYNAMIC;
			options.skinningMethod				= SkinningMethod.HARDWARE_DUAL_QUATERNION;
			options.flattenSkinning				= false;
			options.flattenSkinning				= true;
			options.skinningNumFps				= 60;
			
			/*
			_onlineSkinnedGroup	= new Group();
			_onlineSkinnedGroup.loadClass(DAE, options);
			_onlineSkinnedGroup.transform.setTranslation(50.0, 0.0, 0.0);
			
			scene.addChild(_onlineSkinnedGroup);
			*/
			
			//options.flattenSkinning		= true;
			//options.skinningNumFps		= 120;
			
//			_staticSkinnedGroup	= new Group();
			//_staticSkinnedGroup.loadClass(DAE, options);
			//_staticSkinnedGroup.transform.setTranslation(-50.0, 0.0, 0.0);
			
			var loader : SceneLoader = new SceneLoader(options);
			loader.complete.add(loaderCompleteHandler);
			loader.loadClass(DAE);
			
		}
		
		private function loaderCompleteHandler(loadetimelineIdr : SceneLoader, group : Group) : void
		{
			trace("# loaded animation ctrls = " + group.get("//*[hasController(AnimationController)]").length);

			scene.addChild(group);
			
			for each (var mesh:Mesh in group.get("//mesh"))
			{
				mesh.material.setProperty(BasicProperties.TRIANGLE_CULLING, TriangleCulling.NONE);
			}
			//scene.addChild(group.get("//mesh")[1].clone() as Mesh);
			
			trace("# loaded animation ctrls in scene = " + scene.get("//*[hasController(AnimationController)]").length);
			trace("# loaded master animation ctrls in scene = " + scene.get("//*[hasController(MasterAnimationController)]").length);
		}
		
		private function loadDependency(dependencyId 	: String,
										dependencyPath	: String,
										isTexture		: Boolean,
										options			: ParserOptions) : ILoader
		{
			var loader : ILoader = new TextureLoader(options.mipmapTextures)
			
			loader.loadClass(TEXTURE);
			
			return loader;
		}
	}
}