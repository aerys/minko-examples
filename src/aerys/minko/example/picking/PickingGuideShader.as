package aerys.minko.example.picking
{
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.effect.basic.BasicShader;
	import aerys.minko.render.shader.SFloat;
	import aerys.minko.render.shader.ShaderSettings;
	import aerys.minko.type.enum.DepthTest;
	
	import flash.display3D.Context3DCompareMode;
	
	public final class PickingGuideShader extends BasicShader
	{
		public function PickingGuideShader(target : RenderTarget = null)
		{
			super(target, 0);
		}
		
		override protected function initializeSettings(settings:ShaderSettings):void
		{
			super.initializeSettings(settings);
			
			settings.depthTest = DepthTest.LESS | DepthTest.EQUAL;
			settings.depthWriteEnabled = false;
		}
		
		override protected function getVertexPosition() : SFloat
		{
			return localToScreen(vertexXYZ);
		}
		
		override protected function getPixelColor() : SFloat
		{
			var diffuseColor 	: SFloat 	= meshBindings.getParameter("diffuseColor", 4);
			var thickness		: SFloat 	= meshBindings.getParameter("thickness", 1);
			var size			: SFloat	= meshBindings.getParameter("size", 1);
			var maxDistance		: SFloat	= meshBindings.getParameter("maxDistance", 1);
			var normal			: SFloat	= meshBindings.getParameter("normal", 3);
			var scale			: SFloat	= multiply3x3(float3(1, 1, 1), localToWorldMatrix);
			var center			: SFloat	= multiply4x4(
				float4(0, 0, 0, 1),
				localToWorldMatrix
			);
			var position		: SFloat	= multiply(
				scale,
				interpolate(vertexXYZ)
			);
			
			var alpha : SFloat = saturate(divide(length(position.xy), maxDistance));
			
			alpha = subtract(1, alpha);
			alpha = power(alpha, 3);
			
			center.incrementBy(float3(0, 0, .5));
			center.decrementBy(multiply(absolute(normal), center.z));
			position.incrementBy(center);
			
			position = modulo(position, size);
			var line : SFloat = add(
				lessThan(position.x, thickness),
				lessThan(position.y, thickness)
			);
			
			return float4(
				diffuseColor.rgb,
				multiply(add(.3, multiply(saturate(line), .2)), alpha)
			);
		}
	}
}