package
{
	import aerys.minko.render.geometry.Geometry;
	import aerys.minko.render.geometry.stream.IndexStream;
	import aerys.minko.render.geometry.stream.IVertexStream;
	import aerys.minko.render.geometry.stream.StreamUsage;
	import aerys.minko.render.geometry.stream.VertexStream;
		
	public class RainGeometry extends Geometry
	{
		public var size:Number;
		
		public function RainGeometry(size:Number=10,numPoints:uint = 16383)
		{
			this.size = size;
			var vertices:Vector.<Number> = new <Number>[];
			var indices:Vector.<uint> = new <uint>[];
			
			var posX:Number, posY:Number, posZ:Number,o:uint;
			
			for (var x:uint = 0; x < numPoints; ++x)
			{
				posX = Math.random() * size;
				posY = Math.random() * size;
				posZ = Math.random() * size;
				o = x << 2;
				
				vertices.push(-1, 1, posX, posY, posZ, -1, -1, posX, posY, posZ, 1, -1, posX, posY, posZ, 1, 1, posX, posY, posZ);
				
				indices.push(o , o + 1, o + 2, o , o + 2, o + 3);
			}
			
			super(new <IVertexStream>[VertexStream.fromVector(StreamUsage.STATIC, RainShader.VERTEX_FORMAT, vertices)], IndexStream.fromVector(StreamUsage.STATIC, indices));
		}
	}
}