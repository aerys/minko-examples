package aerys.minko.example.core.gradient
{
	import aerys.minko.render.effect.Effect;
	import aerys.minko.scene.node.mesh.primitive.CubeMesh;

	public class GradientExample extends MinkoExampleApplication
	{
		override protected function initializeScene():void
		{
			scene.addChild(
				new CubeMesh(
					new Effect(new GradientShader(0xff0000ff, 0x0000ffff))
				)
			);
		}
	}
}