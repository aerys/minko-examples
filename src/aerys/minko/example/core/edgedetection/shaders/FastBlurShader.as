package aerys.minko.example.core.edgedetection.shaders {
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.resource.texture.ITextureResource;
	import aerys.minko.render.shader.SFloat;
	import aerys.minko.render.shader.Shader;
	import aerys.minko.render.shader.part.PostProcessingShaderPart;
	
	public class FastBlurShader extends Shader{
		
		private var _input			: ITextureResource			= null;
		private var _postProcessing	: PostProcessingShaderPart	= null;
		private var _sampler		: SamplingShaderPart		= null;
		private var _coef			: Number;
		
		public function FastBlurShader(	input			: ITextureResource,
									    boost			: Number			= 1.,
										renderTarget	: RenderTarget		= null,
										priority		: Number			= 0.0) {
			
			super(renderTarget, priority);
			_input 			= 	input;
			_coef			= 	5. / boost;
			_postProcessing = 	new PostProcessingShaderPart(this);
			_sampler 		= 	new SamplingShaderPart(this, float2(input.width, input.height));
		}	
		
		override protected function getVertexPosition():SFloat{
			return _postProcessing.vertexPosition;
		}
		
		override protected function getPixelColor() : SFloat {
			return getAveragedColor(interpolate(vertexUV.xy));
		}
		
		public function getAveragedColor(uv : SFloat) : SFloat {
			var average : SFloat =
						divide( 
								add(	
									_sampler.getPixel(_input,uv),
									_sampler.getPixel(_input,uv, 1),
									_sampler.getPixel(_input,uv, 3),
									_sampler.getPixel(_input,uv, 5),
									_sampler.getPixel(_input,uv, 7)
								),
								_coef
						);
			return average;
		}
		
	}
}