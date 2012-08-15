package aerys.minko.example.core.timegradient
{
	import aerys.minko.render.Effect;
	import aerys.minko.render.geometry.primitive.CubeGeometry;
	import aerys.minko.render.material.Material;
	import aerys.minko.scene.node.Mesh;

	public class TimeGradientExample extends MinkoExampleApplication
	{
		override protected function initializeScene():void
		{
			super.initializeScene();
			
			scene.addChild(
				new Mesh(
					CubeGeometry.cubeGeometry,
					new Material(new Effect(new TimeGradientShader(0xff0000ff, 0x0000ffff, 0, 3)))
				)
			);
		}
	}
}