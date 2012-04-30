package aerys.minko.example.core.spritesheet
{
	import aerys.minko.render.shader.SFloat;
	import aerys.minko.render.shader.Shader;
	import aerys.minko.type.enum.SamplerFiltering;
	import aerys.minko.type.enum.SamplerMipMapping;
	import aerys.minko.type.enum.SamplerWrapping;
	
	public final class SpritesheetShader extends Shader
	{
		override protected function getVertexPosition():SFloat
		{
			var id			: SFloat	= vertexId.x;
			var corner		: SFloat	= vertexXY.xy;
			var position	: SFloat	= float4(0, 0, 0, 1);
			
			position = localToView(position);
			position = add(position, float4(corner, 0, 0));
			
			return multiply4x4(position, projectionMatrix);
		}
		
		override protected function getPixelColor():SFloat
		{
			var frame		: SFloat = floor(meshBindings.getParameter(
				"spritesheetFrameId",
				1)
			);
			var uv			: SFloat = add(0.5, interpolate(vertexXY));
			var diffuseMap	: SFloat = meshBindings.getTextureParameter(
				"diffuseMap",
				meshBindings.getConstant("diffuseFiltering", SamplerFiltering.LINEAR),
				meshBindings.getConstant("diffuseMipMapping", SamplerMipMapping.LINEAR),
				meshBindings.getConstant("diffuseWrapping", SamplerWrapping.CLAMP)
			);
			
			var spriteSheetOffset	: SFloat = float2(
				modulo(frame, 5),
				floor(divide(frame, 5))
			);
			
			var spriteSheetUv	: SFloat = divide(add(spriteSheetOffset, uv), 5);
			
			return sampleTexture(diffuseMap, spriteSheetUv);
		}
	}
}