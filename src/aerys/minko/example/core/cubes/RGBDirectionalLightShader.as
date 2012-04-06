package aerys.minko.example.core.cubes
{
	import aerys.minko.render.shader.Shader;
	import aerys.minko.render.shader.SValue;
	import aerys.minko.type.math.ConstVector4;
	
	public class RGBDirectionalLightShader extends Shader
	{
		private var _vertexColor	: SValue	= null;
		
		override protected function getOutputPosition():SValue
		{
			var lightDirection : SValue	= getNamedParameter("light direction", ConstVector4.ONE);
			var normal : SValue = normalize(vertexNormal);
			var i : SValue = saturate(negate(dotProduct3(lightDirection, normal)));
			
			i.incrementBy(getNamedParameter("ambient", .5));
			
			_vertexColor = multiply(vertexRGBColor, i);
			
			return vertexClipspacePosition;
		}
		
		override protected function getOutputColor():SValue
		{
			return interpolate(_vertexColor);
		}
	}
}