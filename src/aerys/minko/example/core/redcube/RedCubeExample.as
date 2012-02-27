package aerys.minko.example.core.redcube
{
	import aerys.minko.render.effect.Effect;
	import aerys.minko.render.effect.basic.BasicShader;
	import aerys.minko.scene.node.mesh.primitive.CubeMesh;

	public class RedCubeExample extends MinkoExampleApplication
	{
		override protected function initializeScene() : void
		{
			super.initializeScene();
			
			scene.addChild(
				new CubeMesh(
					new Effect(new BasicShader()),
					{ "diffuse color" :	0xff0000ff }
				)
			);
		}
	}
}