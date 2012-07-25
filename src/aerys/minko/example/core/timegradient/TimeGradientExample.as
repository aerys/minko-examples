package aerys.minko.example.core.timegradient
{
	import aerys.minko.render.effect.Effect;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.render.geometry.primitive.CubeGeometry;
	import aerys.minko.render.geometry.primitive.TeapotGeometry;

	public class TimeGradientExample extends MinkoExampleApplication
	{
		override protected function initializeScene():void
		{
			super.initializeScene();
			
			scene.addChild(
				new Mesh(
					CubeGeometry.cubeGeometry,
					null,
					new Effect(new TimeGradientShader(0xff0000ff, 0x0000ffff, 0, 3))
				)
			);
		}
	}
}