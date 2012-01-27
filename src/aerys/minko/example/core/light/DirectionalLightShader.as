package aerys.minko.example.core.light
{
	import aerys.minko.render.shader.ActionScriptShader;
	import aerys.minko.render.shader.SValue;
	import aerys.minko.type.math.ConstVector4;
	
	public class DirectionalLightShader extends ActionScriptShader
	{
		override protected function getOutputPosition():SValue
		{
			return vertexClipspacePosition;
		}
		
		override protected function getOutputColor():SValue
		{
			var normal : SValue = interpolate(vertexNormal);
			var ambient : SValue = getNamedParameter("ambient", .1);
			var color : SValue = getNamedParameter("light color", ConstVector4.ONE);
			var direction : SValue = getNamedParameter("light direction", ConstVector4.ONE);
			
			direction.normalize();
			
			var lambert : SValue = saturate(negate(dotProduct3(normal, direction)));
			
			return float4(
				multiply(add(lambert,ambient), color.rgb),
				1
			);
		}
	}
}