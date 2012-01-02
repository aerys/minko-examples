package aerys.minko.example.core.timegradient
{
	import aerys.minko.render.effect.Style;
	import aerys.minko.render.shader.ActionScriptShader;
	import aerys.minko.render.shader.SValue;
	
	public class TimeGradientShader extends ActionScriptShader
	{
		public static const TIME_STYLE_ID	: int	= Style.getStyleId("time");
		
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
		
		override protected function getOutputPosition() : SValue
		{
			return vertexClipspacePosition;
		}
		
		override protected function getOutputColor():SValue
		{
			var pos : SValue = interpolate(vertexPosition);
			var time : SValue = fractional(divide(frameId, 30.));
			var c : SValue = divide(
				subtract(pos.y, _minY),
				(_maxY - _minY)
			);
			
			c.decrementBy(time);
			
			c = cos(multiply(c, Math.PI * 2));
			
			return mix(rgba(_color1), rgba(_color2), c);
		}
	}
}