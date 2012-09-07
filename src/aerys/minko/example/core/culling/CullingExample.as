package aerys.minko.example.core.culling
{
	import aerys.minko.render.geometry.primitive.CubeGeometry;
	import aerys.minko.render.material.Material;
	import aerys.minko.render.material.basic.BasicMaterial;
	import aerys.minko.scene.node.Mesh;

	public class CullingExample extends MinkoExampleApplication
	{
		override protected function initializeScene() : void
		{
			super.initializeScene();
			
			var materials : Vector.<Material> = new <Material>[
				new BasicMaterial({diffuseColor:0xff0000ff}),
				new BasicMaterial({diffuseColor:0x00ff00ff}),
				new BasicMaterial({diffuseColor:0x0000ffff}),
				new BasicMaterial({diffuseColor:0xffff00ff})
			];
			for (var i : uint = 0; i < 1000; ++i)
			{
				var cube : Mesh = new Mesh(
					CubeGeometry.cubeGeometry,
					materials[uint(materials.length * Math.random())]
				);
				
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