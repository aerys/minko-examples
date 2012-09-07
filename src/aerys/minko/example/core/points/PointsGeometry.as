package aerys.minko.example.core.points
{
	import aerys.minko.render.geometry.Geometry;
	import aerys.minko.render.geometry.stream.IVertexStream;
	import aerys.minko.render.geometry.stream.IndexStream;
	import aerys.minko.render.geometry.stream.StreamUsage;
	import aerys.minko.render.geometry.stream.VertexStream;
	
	import flash.display.BitmapData;
	
	public class PointsGeometry extends Geometry
	{
		public function PointsGeometry(numPoints : uint = 10000)
		{
			var vertices 		: Vector.<Number> 	= new <Number>[];
			var indices 		: Vector.<uint> 	= new <uint>[];
			var colors			: Vector.<uint>		= new <uint>[
				Math.random() * 0xffffff,
				Math.random() * 0xffffff,
				Math.random() * 0xffffff
			];
			
			for (var x : uint = 0; x < numPoints; ++x)
			{
				var posX 	: Number 	= (Math.random() - 0.5) * 10;
				var posY 	: Number 	= (Math.random() - 0.5) * 10;
				var posZ 	: Number 	= (Math.random() - 0.5) * 10;
				var rgb		: uint		= colors[uint(Math.random() * colors.length)];
				var r		: Number	= (rgb >>> 16) / 255.;
				var g		: Number	= ((rgb >> 8) & 0xff) / 255.;
				var b		: Number	= (rgb & 0xff) / 255.;
				var o		: uint		= x << 2;
				var phase	: Number	= Math.random() * 3.14;
				var speed	: Number	= 1 + Math.random() * 2.14;
				
				vertices.push(
					phase, speed, -.5, .5, posX, posY, posZ, r, g, b,
					phase, speed, -.5, -.5, posX, posY, posZ, r, g, b,
					phase, speed, .5, -.5, posX, posY, posZ, r, g, b,
					phase, speed, .5, .5, posX, posY, posZ, r, g, b
				);
				
				indices.push(o + 0, o + 1, o + 2, o + 0, o + 2, o + 3);
			}
			
			super(
				new <IVertexStream>[
					VertexStream.fromVector(StreamUsage.STATIC, PointsShader.VERTEX_FORMAT, vertices)
				],
				IndexStream.fromVector(StreamUsage.STATIC, indices)
			);
		}
	}
}