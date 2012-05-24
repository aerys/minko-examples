package aerys.minko.example.core.points
{
	public class PointsExample extends MinkoExampleApplication
	{
		private static const NUM_POINTS	: uint	= 100000;
		
		override protected function initializeScene() : void
		{
			super.initializeScene();
			
			for (var numPoints : uint = 0;
				numPoints < NUM_POINTS;
				numPoints += PointsMesh.MAX_NUM_POINTS)
			{
				var points : PointsMesh = new PointsMesh(
					PointsMesh.MAX_NUM_POINTS,
					{ diffuseColor: 0xffffffff }
				);
	
				points.lock();
				for (var i : uint = 0; i < PointsMesh.MAX_NUM_POINTS; ++i)
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
}