package aerys.minko.example.core.culling
{
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.render.geometry.primitive.CubeGeometry;
	import aerys.minko.type.bounding.FrustumCulling;

	public class CullingExample extends MinkoExampleApplication
	{
		override protected function initializeScene() : void
		{
			super.initializeScene();
			
			for (var i : uint = 0; i < 1000; ++i)
			{
				var cube : Mesh = new Mesh(CubeGeometry.cubeGeometry, {diffuseColor:0x0000ffff});
				
				cube.transform.appendTranslation(
					(Math.random() - 0.5) * 500,
					(Math.random() - 0.5) * 500,
					(Math.random() - 0.5) * 500
				);
				
				scene.addChild(cube);
			}
		}
	}
}