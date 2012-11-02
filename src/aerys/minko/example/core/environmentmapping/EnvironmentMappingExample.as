package aerys.minko.example.core.environmentmapping
{
	import aerys.minko.render.geometry.Geometry;
	import aerys.minko.render.geometry.primitive.TeapotGeometry;
	import aerys.minko.render.material.environment.EnvironmentMappingMaterial;
	import aerys.minko.render.resource.texture.CubeTextureResource;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.type.enum.EnvironmentMappingType;
	import aerys.minko.type.loader.TextureLoader;

	public class EnvironmentMappingExample extends AbstractExampleApplication
	{
		[Embed(source="../assets/reflections/blinn-newell.jpg")]
		private static const BLINN_NEWELL_MAP	: Class;
		
		[Embed(source="../assets/reflections/probe.jpg")]
		private static const PROBE_MAP			: Class;
		
		[Embed(source="../assets/skybox/posz.jpg")]
		private static const CUBE_MAP_FRONT		: Class;
		
		[Embed(source="../assets/skybox/negz.jpg")]
		private static const CUBE_MAP_BACK		: Class;
		
		[Embed(source="../assets/skybox/negx.jpg")]
		private static const CUBE_MAP_LEFT		: Class;
		
		[Embed(source="../assets/skybox/posx.jpg")]
		private static const CUBE_MAP_RIGHT		: Class;
		
		[Embed(source="../assets/skybox/posy.jpg")]
		private static const CUBE_MAP_TOP		: Class;
		
		[Embed(source="../assets/skybox/negy.jpg")]
		private static const CUBE_MAP_BOTTOM	: Class;
		
		[Embed(source="../assets/reflections/escher.env.jpg")]
		private static const CUBE_MAP_FULL		: Class;
		
		override protected function initializeScene() : void
		{
			super.initializeScene();
			
			cameraController.pitch = 1.2;
			cameraController.distance = 20;
			
			// create materials
			var blinnNewellMaterial : EnvironmentMappingMaterial = new EnvironmentMappingMaterial();
			blinnNewellMaterial.reflectivity = 1.0;
			blinnNewellMaterial.environmentMap = TextureLoader.loadClass(BLINN_NEWELL_MAP);
			blinnNewellMaterial.environmentMappingType = EnvironmentMappingType.BLINN_NEWELL;

			var probeMaterial : EnvironmentMappingMaterial = new EnvironmentMappingMaterial();
			probeMaterial.reflectivity = 1.0;
			probeMaterial.environmentMap = TextureLoader.loadClass(PROBE_MAP);
			probeMaterial.environmentMappingType = EnvironmentMappingType.PROBE;
			
			var cubeMaterial 	: EnvironmentMappingMaterial 	= new EnvironmentMappingMaterial();
			var cubeMapFull		: CubeTextureResource 			= new CubeTextureResource(1024);
			cubeMapFull.setContentFromBitmapData(new CUBE_MAP_FULL().bitmapData, true);
			cubeMaterial.reflectivity = 1.0;
			cubeMaterial.environmentMap = cubeMapFull;
			cubeMaterial.environmentMappingType = EnvironmentMappingType.CUBE;

			var cubePartsMaterial	: EnvironmentMappingMaterial	= new EnvironmentMappingMaterial();
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
			cubePartsMaterial.reflectivity = 1.0;
			cubePartsMaterial.environmentMap = cubeMapParts;
			cubePartsMaterial.environmentMappingType = EnvironmentMappingType.CUBE;
			
			// create meshes
			var teapotGeometry	: Geometry	= new TeapotGeometry(20);
			var blinnNewell 	: Mesh		= new Mesh(teapotGeometry, blinnNewellMaterial);
			var probe			: Mesh		= new Mesh(teapotGeometry, probeMaterial);
			var cubeParts		: Mesh		= new Mesh(teapotGeometry, cubePartsMaterial);
			var cubeFull		: Mesh		= new Mesh(teapotGeometry, cubeMaterial);
			
			// move them around
			blinnNewell.transform.setTranslation(4, 0, 4);
			probe.transform.setTranslation(4, 0, -4);
			cubeParts.transform.setTranslation(-4, 0, 4);
			cubeFull.transform.setTranslation(-4, 0, -4);
			
			scene.addChild(blinnNewell)
				 .addChild(probe)
				 .addChild(cubeParts)
				 .addChild(cubeFull);
		}
	}
}
