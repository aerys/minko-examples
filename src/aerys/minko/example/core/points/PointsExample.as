package aerys.minko.example.core.points
{
	public class PointsExample extends MinkoExampleApplication
	{
		override protected function initializeScene() : void
		{
			super.initializeScene();
			
			var points : PointsMesh = new PointsMesh(100, { diffuseColor: 0xffffffff });

			points.lock();
			for (var i : uint = 0; i < 100; ++i)
			{
				points.setPosition(
					i,
					(Math.random() - 0.5) * 10,
					(Math.random() - 0.5) * 10,
					(Math.random() - 0.5) * 10
				);
			}
			points.unlock();
			
			scene.addChild(points);
		}
	}
}