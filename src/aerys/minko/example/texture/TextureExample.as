package aerys.minko.example.texture
{
	import aerys.minko.scene.node.group.LoaderGroup;
	import aerys.minko.scene.node.mesh.primitive.CubeMesh;
	
	import flash.net.URLRequest;

	public class TextureExample extends MinkoExampleApplication
	{
		override protected function initializeScene():void
		{
			scene.addChild(
				LoaderGroup.load(new URLRequest("../assets/wall_small.png"))
						   .addChild(CubeMesh.cubeMesh)
			);
		}
	}
}