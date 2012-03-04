package aerys.minko.example.core.gradient
{
	import aerys.minko.render.effect.Effect;
	import aerys.minko.scene.node.mesh.Mesh;
	import aerys.minko.scene.node.mesh.geometry.primitive.CubeGeometry;

	public class GradientExample extends MinkoExampleApplication
	{
		override protected function initializeScene():void
		{
			scene.addChild(
				new Mesh(
					CubeGeometry.cubeGeometry,
					null,
					new Effect(new GradientShader(0xff0000ff, 0x0000ffff))
				)
			);
		}
	}
}