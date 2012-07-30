package aerys.minko.example.core.timegradient
{
	import aerys.minko.render.material.basic.BasicShader;
	import aerys.minko.render.shader.SFloat;
	
	public class TimeGradientShader extends BasicShader
	{
		private var _minY	: uint	= 0.;
		private var _maxY	: uint	= 0.;
		private var _color1	: uint	= 0;
		private var _color2	: uint	= 0;
		
		public function TimeGradientShader(color1 	: uint,
										   color2 	: uint,
										   minY 	: Number = 0,
										   maxY 	: Number = 1)
		{
			super();
			
			_minY = minY;
			_maxY = maxY;
			_color1 = color1;
			_color2 = color2;
		}
		
		override protected function getVertexPosition() : SFloat
		{
			return localToScreen(vertexXYZ);
		}
		
		override protected function getPixelColor() : SFloat
		{
			var pos : SFloat = interpolate(vertexXYZ);
			var time : SFloat = fractional(divide(time, 1000));
			var c : SFloat = divide(subtract(pos.y, _minY),	(_maxY - _minY));
			
			c.decrementBy(time);
			
			c = cos(multiply(c, Math.PI * 2));
			
			return mix(rgba(_color1), rgba(_color2), c);
		}
	}
}