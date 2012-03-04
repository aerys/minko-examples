package aerys.minko.example.core.timegradient
{
	import aerys.minko.render.effect.Effect;
	import aerys.minko.scene.node.mesh.Mesh;
	import aerys.minko.scene.node.mesh.geometry.primitive.CubeGeometry;
	import aerys.minko.scene.node.mesh.geometry.primitive.TeapotGeometry;

	public class TimeGradientExample extends MinkoExampleApplication
	{
		override protected function initializeScene():void
		{
			cameraController.setPivot(0, 1.3, 0);
			
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