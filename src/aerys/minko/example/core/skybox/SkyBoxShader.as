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
	
	public class SkyBoxShader extends Shader
	{
		private var _priority		: Number;
		private var _renderTarget	: RenderTarget;
		
		public function SkyBoxShader(priority		: Number		= 0,
									 renderTarget	: RenderTarget	= null)
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
			return localToScreen(getVertexAttribute(VertexComponent.XYZ));
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
			
			var skyboxPixelPosition	: SFloat = interpolate(localToWorld(getVertexAttribute(VertexComponent.XYZ)));
			var uvw					: SFloat = normalize(subtract(skyboxPixelPosition, cameraPosition));
			
			return sampleTexture(cubicTexture, uvw);
		}
	}
}