package aerys.minko.example.core.redcube
{
	import aerys.minko.Minko;
	import aerys.minko.scene.node.mesh.Mesh;
	import aerys.minko.scene.node.mesh.geometry.primitive.CubeGeometry;
	import aerys.minko.type.log.DebugLevel;

	public class RedCubeExample extends MinkoExampleApplication
	{
		override protected function initializeScene() : void
		{
			super.initializeScene();
			
			Minko.debugLevel = DebugLevel.SHADER_AGAL;
			
			scene.addChild(
				new Mesh(
					CubeGeometry.cubeGeometry,
					{ diffuseColor :	0xff0000ff }
				)
			);
		}
	}
}