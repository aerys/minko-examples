package aerys.minko.example.core.perpixeltexturemerge
{
	import aerys.minko.render.material.basic.BasicShader;
	import aerys.minko.render.shader.SFloat;
	
	public class PerPixelTextureMergeShader extends BasicShader
	{
		override protected function getPixelColor():SFloat
		{
			var uv 				: SFloat = interpolate(vertexUV);
			var diffuseColor 	: SFloat = meshBindings.getParameter('diffuseColor', 4);
			var diffuseMap1		: SFloat = meshBindings.getTextureParameter('diffuseMap1');
			var diffuseMap2		: SFloat = meshBindings.getTextureParameter('diffuseMap2');
			
			var colorCoef 	: SFloat = interpolate(getVertexAttribute(PerPixelTextureMergeExample.COLOR_COEF));
			var map1Coef	: SFloat = interpolate(getVertexAttribute(PerPixelTextureMergeExample.TEX_1_COEF));
			var map2Coef 	: SFloat = interpolate(getVertexAttribute(PerPixelTextureMergeExample.TEX_2_COEF));
			
			var computeDiffuseColor 	: SFloat = diffuseColor.scaleBy(colorCoef.x);
			var computeDiffuseMap1Color	: SFloat = multiply(sampleTexture(diffuseMap1, uv).xyz, map1Coef.x);
			var computeDiffuseMap2Color	: SFloat = sampleTexture(diffuseMap2, uv).scaleBy(map2Coef.x);

			return float4(
				add(
					computeDiffuseColor,
					computeDiffuseMap1Color,
					computeDiffuseMap2Color).xyz, 
				1);
			
		}
	}
}