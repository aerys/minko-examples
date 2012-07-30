package aerys.minko.example.core.redcube
{
	import aerys.minko.render.effect.Effect;
	import aerys.minko.render.effect.basic.BasicShader;
	import aerys.minko.scene.node.mesh.Mesh;
	import aerys.minko.scene.node.mesh.geometry.primitive.CubeGeometry;

	public class RedCubeExample extends MinkoExampleApplication
	{
		override protected function initializeScene() : void
		{
			super.initializeScene();
			
			scene.addChild(new Mesh(
				CubeGeometry.cubeGeometry,
				{ diffuseColor : 0xff0000ff }
			));
		}
		
	}
}