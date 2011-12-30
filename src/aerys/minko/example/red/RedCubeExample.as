package aerys.minko.example.red
{
	import aerys.minko.Minko;
	import aerys.minko.scene.node.mesh.primitive.CubeMesh;
	import aerys.minko.scene.node.texture.ColorTexture;
	import aerys.minko.type.log.DebugLevel;

	public class RedCubeExample extends MinkoExampleApplication
	{
		override protected function initializeScene():void
		{
			scene.addChild(new ColorTexture(0xff0000))
				 .addChild(CubeMesh.cubeMesh);
		}
	}
}