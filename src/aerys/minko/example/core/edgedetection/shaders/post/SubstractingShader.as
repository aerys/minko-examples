package aerys.minko.example.core.edgedetection.shaders.post 
{
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.resource.texture.ITextureResource;
	import aerys.minko.render.shader.SFloat;
	import aerys.minko.render.shader.Shader;
	import aerys.minko.render.shader.part.PostProcessingShaderPart;
	
	public class SubstractingShader extends Shader
	{
		private var _mask			: ITextureResource			= null;
		private var _postProcessing	: PostProcessingShaderPart	= null;
		
		public function SubstractingShader( mask			: ITextureResource,
										   	renderTarget	: RenderTarget		= null,
										   	priority		: Number			= 0.0)
		{
			super(renderTarget, priority);
			_mask = mask;
			_postProcessing = new PostProcessingShaderPart(this);
		}	
		
		override protected function getVertexPosition() : SFloat
		{
			return _postProcessing.vertexPosition;
		}
		
		override protected function getPixelColor() : SFloat
		{
			var fragmentCoord 	: SFloat = interpolate(vertexUV.xy);
			var color			: SFloat = _postProcessing.sampleBackBuffer(fragmentCoord);
			var maskPixel 		: SFloat = sampleTexture(getTexture(_mask), fragmentCoord);
			return subtract(color, maskPixel);
		}
		
		
	}
}