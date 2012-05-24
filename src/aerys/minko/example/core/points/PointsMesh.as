package aerys.minko.example.core.points
{
	import aerys.minko.render.effect.Effect;
	import aerys.minko.scene.node.mesh.Mesh;
	import aerys.minko.scene.node.mesh.geometry.primitive.BillboardsGeometry;
	import aerys.minko.type.data.DataProvider;
	
	public class PointsMesh extends Mesh
	{
		public static const MAX_NUM_POINTS	: uint	= 100;
		
		private static const EFFECT	: Effect	= new Effect(new PointsShader());
		
		private var _pointsProperties	: DataProvider		= null;
		private var _positions			: Vector.<Number>	= null;
		private var _locked				: Boolean			= false;
		
		public function get locked() : Boolean
		{
			return _locked;
		}
		
		public function PointsMesh(numPoints	: uint,
								   properties 	: Object	= null,
								   effect		: Effect	= null)
		{
			super(
				new BillboardsGeometry(numPoints),
				properties,
				effect || EFFECT
			);
			
			_positions = new Vector.<Number>(numPoints * 4, true);
			_pointsProperties = new DataProvider({
				pointsCount		: numPoints,
				pointsPositions	: _positions
			});
			
			bindings.add(_pointsProperties);
		}
		
		public function lock() : void
		{
			_locked = true;
		}
		
		public function unlock() : void
		{
			_locked = false;
			_pointsProperties.pointsPositions = _positions;
		}
		
		public function setPosition(index	: uint,
									x		: Number,
									y		: Number,
									z		: Number) : PointsMesh
		{
			index *= 4;
			
			_positions[index] = x;
			_positions[uint(index + 1)] = y;
			_positions[uint(index + 2)] = z;
			
			if  (!_locked)
				_pointsProperties.pointsPositions = _pointsProperties;
			
			return this;
		}
	}
}