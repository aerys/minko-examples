package aerys.minko.example.core.gradient
{
	import aerys.minko.render.shader.SFloat;
	import aerys.minko.render.shader.ActionScriptShader;
	
	
	public class GradientShader extends ActionScriptShader
	{
		private var _color1	: uint	= 0;
		private var _color2	: uint	= 0;
		
		public function GradientShader(color1 : uint, color2 : uint)
		{
			super();
			
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
			var c : SFloat = absolute(pos.y).scaleBy(2.);
			
			return mix(rgba(_color1), rgba(_color2), c);
		}
	}
}