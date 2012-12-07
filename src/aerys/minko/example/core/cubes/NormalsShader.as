package aerys.minko.example.core.cubes
{
	import aerys.minko.render.shader.SFloat;
	import aerys.minko.render.shader.Shader;
	import aerys.minko.render.shader.ShaderSettings;
	import aerys.minko.type.enum.Blending;
	
	public final class NormalsShader extends Shader
	{
		override protected function initializeSettings(settings : ShaderSettings) : void
		{
			settings.blending = Blending.ADDITIVE;
			settings.depthWriteEnabled = false;
		}
		
		override protected function getVertexPosition():SFloat
		{
			return localToScreen(vertexXYZ);
		}
		
		override protected function getPixelColor():SFloat
		{
			var normal : SFloat	= interpolate(vertexNormal);
			
			normal = localToWorld(normal);
			
			return float4(
				divide(add(normal.xyz, 1), 2),
				0.3
			);
		}
	}
}