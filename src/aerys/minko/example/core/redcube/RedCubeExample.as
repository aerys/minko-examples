package aerys.minko.example.core.redcube
{
	import aerys.minko.render.geometry.primitive.CubeGeometry;
	import aerys.minko.render.material.basic.BasicMaterial;
	import aerys.minko.scene.node.Mesh;

	public class RedCubeExample extends MinkoExampleApplication
	{
		override protected function initializeScene() : void
		{
			super.initializeScene();
			
			scene.addChild(new Mesh(
				CubeGeometry.cubeGeometry,
				new BasicMaterial({ diffuseColor : 0xff0000ff })
			));
		}
	}
}
