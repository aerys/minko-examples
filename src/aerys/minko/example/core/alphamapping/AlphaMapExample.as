package aerys.minko.example.core.alphamapping
{
	import aerys.minko.render.geometry.primitive.CubeGeometry;
	import aerys.minko.render.material.phong.PhongMaterial;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.scene.node.light.AmbientLight;
	import aerys.minko.type.enum.Blending;
	import aerys.minko.type.loader.TextureLoader;

	public class AlphaMapExample extends AbstractExampleApplication
	{
		[Embed("../assets/textures/box1.jpg")]
		private static const BOX1_TEXTURE	: Class;
		
		[Embed("../assets/alphamap/alphaMask.jpg")]
		private static const MASK	: Class;
		
		override protected function initializeScene():void
		{
			super.initializeScene();
			
			var material : PhongMaterial = new PhongMaterial();

			material.diffuseMap = TextureLoader.loadClass(BOX1_TEXTURE);
			material.alphaMap 	= TextureLoader.loadClass(MASK);
			material.blending 	= Blending.ALPHA;

			var cube : Mesh = new Mesh(CubeGeometry.cubeGeometry, material);

			scene.addChild(cube)
				 .addChild(new AmbientLight());
		}
	}
}