package aerys.minko.example.core.skybox
{
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.geometry.stream.format.VertexComponent;
	import aerys.minko.render.shader.SFloat;
	import aerys.minko.render.shader.Shader;
	import aerys.minko.render.shader.ShaderSettings;
	import aerys.minko.type.enum.SamplerDimension;
	import aerys.minko.type.enum.SamplerFiltering;
	import aerys.minko.type.enum.SamplerMipMapping;
	import aerys.minko.type.enum.SamplerWrapping;
	import aerys.minko.type.enum.TriangleCulling;
	import aerys.minko.type.math.Vector4;
	
	public class SkyboxShader extends Shader
	{
		private var _priority		: Number;
		private var _renderTarget	: RenderTarget;
		
		public function SkyboxShader(renderTarget	: RenderTarget	= null,
									 priority		: Number		= 0)
		{
			_priority		= priority;
			_renderTarget	= renderTarget;
		}
		
		override protected function initializeSettings(settings : ShaderSettings) : void
		{
			settings.renderTarget		= _renderTarget;
			settings.priority			= _priority;
			settings.triangleCulling	= TriangleCulling.FRONT;
		}
		
		override protected function getVertexPosition() : SFloat
		{
			var position 	: SFloat 	= localToWorld(vertexXYZ);

			// center the geometry on the camera
			position.incrementBy(float4(cameraPosition, 0));
			position = worldToView(position);
			
			return viewToScreen(position);
		}
		
		override protected function getPixelColor() : SFloat
		{
			var cubicTexture : SFloat = meshBindings.getTextureParameter(
				'diffuseCubeMap', 
				SamplerFiltering.LINEAR, 
				SamplerMipMapping.LINEAR, 
				SamplerWrapping.CLAMP, 
				SamplerDimension.CUBE
			);
			
			var uvw : SFloat = normalize(interpolate(vertexXYZ));
			
			return sampleTexture(cubicTexture, uvw);
		}
	}
}