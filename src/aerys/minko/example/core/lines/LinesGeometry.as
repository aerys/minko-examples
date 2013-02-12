package aerys.minko.example.core.lines
{
	import aerys.minko.render.geometry.Geometry;
	import aerys.minko.render.geometry.stream.IVertexStream;
	import aerys.minko.render.geometry.stream.IndexStream;
	import aerys.minko.render.geometry.stream.StreamUsage;
	import aerys.minko.render.geometry.stream.VertexStream;
	import aerys.minko.render.geometry.stream.format.VertexComponent;
	import aerys.minko.render.geometry.stream.format.VertexComponentType;
	import aerys.minko.render.geometry.stream.format.VertexFormat;
	
	public class LinesGeometry extends Geometry
	{
		public static const VERTEX_LINE_START	: VertexComponent	= new VertexComponent(
			['lineStartX', 'lineStartY', 'lineStartZ', 'lineStartWeight'],
			VertexComponentType.FLOAT_4
		);
		public static const VERTEX_LINE_STOP	: VertexComponent	= new VertexComponent(
			['lineStopX', 'lineStopY', 'lineStopZ', 'lineStopWeight'],
			VertexComponentType.FLOAT_4
		);
		
		public static const VERTEX_LINE_SPREAD	: VertexComponent	= new VertexComponent(
			['lineSpread'],
			VertexComponentType.FLOAT_1
		);
		
		public static const VERTEX_LINE_FORMAT	: VertexFormat		= new VertexFormat(
			VERTEX_LINE_START,
			VERTEX_LINE_STOP,
			VERTEX_LINE_SPREAD
		);
		
		private var _currentX	: Number;
		private var _currentY	: Number;
		private var _currentZ	: Number;
		
		private var _numLines	: uint;
		
		private var _vstream	: VertexStream;
		private var _istream	: IndexStream;
		
		public function LinesGeometry()
		{
			_vstream = new VertexStream(StreamUsage.DYNAMIC, VERTEX_LINE_FORMAT);
			_istream = new IndexStream(StreamUsage.DYNAMIC);
			
			super(new <IVertexStream>[_vstream], _istream);
		}
		
		public function moveTo(x : Number, y : Number, z : Number) : LinesGeometry
		{
			_currentX = x;
			_currentY = y;
			_currentZ = z;
			
			return this;
		}
		
		public function lineTo(x : Number, y : Number, z : Number) : LinesGeometry
		{
			_vstream.pushFloats(new <Number>[
				_currentX, _currentY, _currentZ, 1, x, y, z, 0, -1,
				_currentX, _currentY, _currentZ, 1, x, y, z, 0, 1,
				_currentX, _currentY, _currentZ, 0, x, y, z, 1, 1,
				_currentX, _currentY, _currentZ, 0, x, y, z, 1, -1,
			]);
			
			var indexOffset : uint = _numLines * 4;
			
			_istream.pushVector(new <uint>[
				indexOffset, indexOffset + 1, indexOffset + 2,
				indexOffset, indexOffset + 2, indexOffset + 3,
			]);
			
			++_numLines;
			
			return moveTo(x, y, z);
		}
	}
}