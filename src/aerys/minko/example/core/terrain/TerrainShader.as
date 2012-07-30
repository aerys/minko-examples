package aerys.minko.example.core.terrain
{
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.material.basic.BasicShader;
	import aerys.minko.render.shader.SFloat;
	
	public class TerrainShader extends BasicShader
	{
		public function TerrainShader(target:RenderTarget=null, priority:Number=0.0)
		{
			super(target, priority);
		}
		
		override protected function getPixelColor():SFloat
		{
			var diffuseMap	: SFloat	= meshBindings.getTextureParameter('diffuseMap');
			var uv			: SFloat	= interpolate(float2(0, vertexXYZ.z));
		
			var diffuse		: SFloat	= sampleTexture(diffuseMap, uv);
			
			if (sceneBindings.getConstant('lightEnabled', false)
				&& meshBindings.getConstant('lightEnabled', false))
			{
				var lightDirection	: SFloat = sceneBindings.getParameter("lightDirection", 3);
				var normal			: SFloat = normalize(
					interpolate(
						float4(multiply3x3(vertexNormal, localToWorldMatrix), 1)
					)
				);
				var lambert			: SFloat = saturate(negate(dotProduct3(
					normal,
					normalize(lightDirection)
				)));
				
				lambert.scaleBy(sceneBindings.getParameter("lightDiffuse", 1));
				
				var lightColor		: SFloat = add(
					// ambient
					multiply(
						sceneBindings.getParameter("lightAmbient", 1),
						sceneBindings.getParameter("lightAmbientColor", 3)
					),
					// diffuse
					multiply(
						lambert,
						sceneBindings.getParameter("lightDiffuseColor", 3)
					)
				);
				
				diffuse = float4(multiply(diffuse.rgb, lightColor), diffuse.a);
			}
			
			return diffuse;
		}
	}
}