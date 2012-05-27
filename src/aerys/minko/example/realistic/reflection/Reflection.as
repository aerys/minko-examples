package aerys.minko.example.realistic.reflection
{
	import aerys.minko.Minko;
	import aerys.minko.render.effect.Effect;
	import aerys.minko.render.effect.basic.BasicProperties;
	import aerys.minko.render.effect.realistic.RealisticEffect;
	import aerys.minko.render.effect.reflection.ReflectionProperties;
	import aerys.minko.render.resource.texture.CubeTextureResource;
	import aerys.minko.render.resource.texture.TextureResource;
	import aerys.minko.scene.node.light.AmbientLight;
	import aerys.minko.scene.node.mesh.Mesh;
	import aerys.minko.scene.node.mesh.geometry.Geometry;
	import aerys.minko.scene.node.mesh.geometry.primitive.TeapotGeometry;
	import aerys.minko.type.enum.ReflectionType;
	import aerys.minko.type.loader.TextureLoader;
	import aerys.minko.type.log.DebugLevel;

	public class Reflection extends MinkoExampleApplication
	{
		[Embed(source="../assets/reflections/blinn-newell.jpg")]
		private static const BLINN_NEWELL_MAP	: Class;
		
		[Embed(source="../assets/reflections/probe.jpg")]
		private static const PROBE_MAP			: Class;
		
		[Embed(source="../assets/skybox/ImageCubeFromBookmark.jpg")]
		private static const CUBE_MAP_FRONT		: Class;
		
		[Embed(source="../assets/skybox/ImageCubeFromBookmark2.jpg")]
		private static const CUBE_MAP_BACK		: Class;
		
		[Embed(source="../assets/skybox/ImageCubeFromBookmark3.jpg")]
		private static const CUBE_MAP_LEFT		: Class;
		
		[Embed(source="../assets/skybox/ImageCubeFromBookmark4.jpg")]
		private static const CUBE_MAP_RIGHT		: Class;
		
		[Embed(source="../assets/skybox/ImageCubeFromBookmark1.jpg")]
		private static const CUBE_MAP_TOP		: Class;
		
		[Embed(source="../assets/skybox/ImageCubeFromBookmark5.jpg")]
		private static const CUBE_MAP_BOTTOM	: Class;
		
		[Embed(source="../assets/reflections/escher.env.jpg")]
		private static const CUBE_MAP_FULL		: Class;
		
		override protected function initializeScene() : void
		{
			Minko.debugLevel = DebugLevel.CONTEXT;
			
			// create realistic effect
			var effect : Effect = new RealisticEffect(scene);
			
			// create one teapot for each reflection map type
			var teapotGeometry	: Geometry	= new TeapotGeometry(20);
			
			var blinnNewell 	: Mesh		= new Mesh(teapotGeometry, null, effect);
			var probe			: Mesh		= new Mesh(teapotGeometry, null, effect);
			var cubeParts		: Mesh		= new Mesh(teapotGeometry, null, effect);
			var cubeFull		: Mesh		= new Mesh(teapotGeometry, null, effect);
			
			// load maps
			var blinnNewellMap	: TextureResource = TextureLoader.loadClass(BLINN_NEWELL_MAP);
			var probeMap		: TextureResource = TextureLoader.loadClass(PROBE_MAP);
			
			var cubeMapFull		: CubeTextureResource = new CubeTextureResource(1024);
			cubeMapFull.setContentFromBitmapData(new CUBE_MAP_FULL().bitmapData, true);
			
			var cubeMapParts	: CubeTextureResource = new CubeTextureResource(1024);
			cubeMapParts.setContentFromBitmapDatas(
				new CUBE_MAP_RIGHT().bitmapData, 
				new CUBE_MAP_LEFT().bitmapData, 
				new CUBE_MAP_TOP().bitmapData, 
				new CUBE_MAP_BOTTOM().bitmapData, 
				new CUBE_MAP_FRONT().bitmapData, 
				new CUBE_MAP_BACK().bitmapData,
				true
			);
			
			// configure cube so that they use the reflection maps.
			blinnNewell.properties.setProperty(BasicProperties.DIFFUSE_COLOR, 0);
			blinnNewell.properties.setProperty(ReflectionProperties.MAP, blinnNewellMap);
			blinnNewell.properties.setProperty(ReflectionProperties.TYPE, ReflectionType.BLINN_NEWELL);
			
			probe.properties.setProperty(BasicProperties.DIFFUSE_COLOR, 0xff0000ff);
			probe.properties.setProperty(ReflectionProperties.MAP, probeMap);
			probe.properties.setProperty(ReflectionProperties.TYPE, ReflectionType.PROBE);
			
			cubeParts.properties.setProperty(BasicProperties.DIFFUSE_COLOR, 0);
			cubeParts.properties.setProperty(ReflectionProperties.MAP, cubeMapParts);
			cubeParts.properties.setProperty(ReflectionProperties.TYPE, ReflectionType.CUBE);
			
			cubeFull.properties.setProperty(BasicProperties.DIFFUSE_COLOR, 0);
			cubeFull.properties.setProperty(ReflectionProperties.MAP, cubeMapFull);
			cubeFull.properties.setProperty(ReflectionProperties.TYPE, ReflectionType.CUBE);
			
			// move them around
			blinnNewell.transform.setTranslation(4, 0, 4);
			probe.transform.setTranslation(4, 0, -4);
			cubeParts.transform.setTranslation(-4, 0, 4);
			cubeFull.transform.setTranslation(-4, 0, -4);
			
			scene.addChild(new AmbientLight(0xffffff, 1));
			scene.addChild(blinnNewell)
				 .addChild(probe)
				 .addChild(cubeParts)
				 .addChild(cubeFull);
		}
	}
}