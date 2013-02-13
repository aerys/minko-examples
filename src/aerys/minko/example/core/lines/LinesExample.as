package aerys.minko.example.core.lines
{
	import aerys.minko.render.geometry.primitive.TeapotGeometry;
	import aerys.minko.render.geometry.stream.iterator.TriangleIterator;
	import aerys.minko.render.geometry.stream.iterator.TriangleReference;
	import aerys.minko.render.geometry.stream.iterator.VertexIterator;
	import aerys.minko.render.geometry.stream.iterator.VertexReference;
	import aerys.minko.scene.controller.camera.ArcBallController;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.scene.node.camera.OrthographicCamera;
	import aerys.minko.render.geometry.primitive.LineGeometry;
	import aerys.minko.render.material.line.LineMaterial;

	public class LinesExample extends AbstractExampleApplication
	{
		private var _lines	: Mesh;
		
		override protected function initializeScene():void
		{
			super.initializeScene();
			
//			viewport.antiAliasing = 4;
			
//			var linesGeom : LinesGeometry = new LinesGeometry();
//			var teapot	: TeapotGeometry = new TeapotGeometry(6);
//			var triangles : TriangleIterator = new TriangleIterator(teapot.getVertexStream(), teapot.indexStream);
//		
//			for each (var triangle : TriangleReference in triangles)
//			{
//				linesGeom.moveTo(triangle.v0.x, triangle.v0.y, triangle.v0.z)
//					.lineTo(triangle.v1.x, triangle.v1.y, triangle.v1.z)
//					.lineTo(triangle.v2.x, triangle.v2.y, triangle.v2.z)
//					.lineTo(triangle.v0.x, triangle.v0.y, triangle.v0.z);
//			}
//            
//			_lines = new Mesh(
//				linesGeom,
//				new LinesMaterial({
//					diffuseColor 	: 0xffffffff,
//					lineThickness	: 1.
//				})
//			);
//			
//			_lines.y = -1.45;
			
//			scene.addChild(_lines);
            
            initLines();
		}
        
        private function initLines() : void
        {
            const NUM_LINES : uint = 400;
            var linesGeometry	: LineGeometry	= new LineGeometry();
            var axisGeometry	: LineGeometry	= new LineGeometry();
            
            axisGeometry.moveTo(-NUM_LINES / 2 + 1, 0, 0)
                .lineTo(NUM_LINES / 2, 0, 0)//, 10)
                .moveTo(0, 0, -NUM_LINES / 2 + 1)
                .lineTo(0, 0, NUM_LINES / 2)//, 10);
            
            for (var i : int = -NUM_LINES / 2 + 1; i <= NUM_LINES / 2; ++i)
            {
                if (i == 0)
                    continue;
                linesGeometry.moveTo(i, 0, -NUM_LINES / 2 + 1)
                    .lineTo(i, 0, NUM_LINES / 2, 10)
                    .moveTo(-NUM_LINES / 2 + 1, 0, i)
                    .lineTo(NUM_LINES / 2, 0, i, 10);
            }
            
            var lines : Mesh = new Mesh(
                linesGeometry,
                new LineMaterial({
                    diffuseColor 	: 0xffffffff,
                    lineThickness	: 1
                })
            );
            
            var axis : Mesh = new Mesh(
                axisGeometry,
                new LineMaterial({
                    diffuseColor 	: 0x222222FF,
                    lineThickness	: 1
                })
            );
            
            scene.addChild(lines);
            scene.addChild(axis);
        }
	}
}