package aerys.minko.example.gradient3
{
	import aerys.minko.render.shader.ActionScriptShader;
	import aerys.minko.render.shader.SValue;
	import aerys.minko.type.stream.format.VertexComponent;
	
	public final class Gradient3Shader extends ActionScriptShader
	{
		private var _color : SValue = null;
		
		override protected function getOutputPosition() : SValue
		{
			var xy : SValue = float2(getVertexAttribute(VertexComponent.XY));
			
			_color = getVertexAttribute(VertexComponent.RGB);
			
			return float4(xy, 0., 1.);
		}
		
		override protected function getOutputColor() : SValue
		{
			return interpolate(_color);
		}
	}
}