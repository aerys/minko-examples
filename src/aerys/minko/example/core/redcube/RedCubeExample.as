package aerys.minko.example.core.redcube
{
	import aerys.minko.scene.node.mesh.primitive.CubeMesh;
	import aerys.minko.scene.node.texture.ColorTexture;

	public class RedCubeExample extends MinkoExampleApplication
	{
		override protected function initializeScene():void
		{
			scene.addChild(new ColorTexture(0xff0000))
				 .addChild(CubeMesh.cubeMesh);
		}
	}
}