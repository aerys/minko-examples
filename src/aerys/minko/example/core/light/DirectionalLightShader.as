package aerys.minko.example.core.light
{
	import aerys.minko.render.shader.SFloat;
	import aerys.minko.render.shader.ActionScriptShader;
	
	public class DirectionalLightShader extends ActionScriptShader
	{
		override protected function getVertexPosition() : SFloat
		{
			return localToScreen(vertexXYZ);
		}
		
		override protected function getPixelColor() : SFloat
		{
			var normal 		: SFloat = interpolate(vertexNormal);
			var ambient 	: SFloat = sceneBindings.getParameter("ambient", 1);
			var color 		: SFloat = sceneBindings.getParameter("light color", 4);
			var direction 	: SFloat = sceneBindings.getParameter("light direction", 3);
			
			direction.normalize();
			
			var lambert : SFloat = saturate(negate(dotProduct3(normal, direction)));
			
			return float4(
				multiply(add(lambert,ambient), color.rgb),
				1
			);
		}
	}
}