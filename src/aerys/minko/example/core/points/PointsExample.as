package aerys.minko.example.core.points
{
	import aerys.minko.render.Effect;
	import aerys.minko.render.material.Material;
	import aerys.minko.scene.node.Mesh;

	public class PointsExample extends MinkoExampleApplication
	{
		private static const NUM_POINTS	: uint	= 16000;
		
		override protected function initializeScene() : void
		{
			super.initializeScene();
			
			viewport.backgroundColor = 0;
			
			scene.addChild(new Mesh(
				new PointsGeometry(),
				new Material(
					new Effect(new PointsShader()),
					{ pointSize : 0.1 }
				)
			));
		}
	}
}