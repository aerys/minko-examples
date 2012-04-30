package aerys.minko.example.core.postprocessing
{
	import aerys.minko.render.resource.texture.TextureResource;
	import aerys.minko.render.shader.SFloat;
	import aerys.minko.render.shader.Shader;
	import aerys.minko.render.shader.ShaderSettings;
	import aerys.minko.render.shader.part.PostProcessingShaderPart;
	import aerys.minko.type.enum.SamplerFiltering;
	import aerys.minko.type.enum.SamplerMipMapping;
	import aerys.minko.type.enum.SamplerWrapping;
	
	import flash.display.BitmapData;
	
	public final class NoisePostProcessingShader extends Shader
	{
		private var _postProcessing	: PostProcessingShaderPart	= null;
		
		private var _noiseTexture	: TextureResource			= null;

		public function NoisePostProcessingShader()
		{
			super();
			
			_postProcessing = new PostProcessingShaderPart(this);
			
			initializeNoiseTexture();
		}
		
		private function initializeNoiseTexture() : void
		{
			_noiseTexture = new TextureResource();
			
			var bmp : BitmapData	= new BitmapData(512, 512);
			
			bmp.noise(Math.random() * 100, 180, 255, 7, true);
			_noiseTexture.setContentFromBitmapData(bmp, false);
		}
		
		override protected function initializeSettings(settings : ShaderSettings) : void
		{
			_postProcessing.initializeSettings(settings);
		}
		
		override protected function getVertexPosition() : SFloat
		{
			return _postProcessing.vertexPosition;
		}
		
		override protected function getPixelColor() : SFloat
		{
			var pixel		: SFloat	= _postProcessing.backBufferPixel;
			var pos 		: SFloat	= interpolate(vertexXYZ);
			var l 			: SFloat	= subtract(1, length(pos.xyz));
			
			var noiseMap	: SFloat	= getTexture(
				_noiseTexture,
				SamplerFiltering.NEAREST,
				SamplerMipMapping.DISABLE,
				SamplerWrapping.REPEAT
			);
			var noiseUV		: SFloat	= interpolate(vertexUV);
			var scale		: SFloat	= float2(
				divide(viewportWidth, 1024),
				divide(viewportHeight, 1024)
			);
			
			noiseUV.incrementBy(fractional(divide(time, 1000000)));
			noiseUV.scaleBy(multiply(50, scale));
			
			var noise		: SFloat	= sampleTexture(noiseMap, noiseUV);
			
			return float4(
				multiply(pixel.rgb, l, noise.r),
				pixel.a
			);
		}
	}
}