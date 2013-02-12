package aerys.minko.example.core.lines
{
	import aerys.minko.scene.node.Mesh;

	public class LinesExample extends AbstractExampleApplication
	{
		private var _line	: Mesh;
		
		override protected function initializeScene():void
		{
			super.initializeScene();
			
			var linesGeom : LinesGeometry = new LinesGeometry();
			
			linesGeom
				.lineTo(0, 1, 0)
				.lineTo(1, 1, 0)
				.moveTo(0, 1, 0)
				.lineTo(0, 1, 1);
			
			_line = new Mesh(
				linesGeom,
				new LinesMaterial({
					diffuseColor 	: 0x0000ffff,
					lineThickness	: 1.
				})
			);
			
			scene.addChild(_line);
		}
	}
}