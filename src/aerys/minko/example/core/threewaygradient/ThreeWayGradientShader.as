package aerys.minko.example.core.threewaygradient
{
	import aerys.minko.render.effect.basic.BasicShader;
	import aerys.minko.render.shader.SFloat;
	import aerys.minko.render.shader.Shader;
	import aerys.minko.render.geometry.stream.format.VertexComponent;
	
	public final class ThreeWayGradientShader extends BasicShader
	{
		private var _color : SFloat = null;
		
		override protected function getVertexPosition() : SFloat
		{
			var xy : SFloat = getVertexAttribute(VertexComponent.XY).xy;
			
			_color = getVertexAttribute(VertexComponent.RGB);
			
			return float4(xy, 0., 1.);
		}
		
		override protected function getPixelColor() : SFloat
		{
			return interpolate(_color);
		}
	}
}