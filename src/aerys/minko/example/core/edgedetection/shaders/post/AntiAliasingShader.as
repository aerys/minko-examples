package aerys.minko.example.core.edgedetection.shaders.post 
{
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.resource.texture.ITextureResource;
	import aerys.minko.render.shader.SFloat;
	import aerys.minko.render.shader.Shader;
	import aerys.minko.render.shader.part.PostProcessingShaderPart;
	
	public class AntiAliasingShader extends Shader
	{
		private var _edge			: ITextureResource			= null;
		private var _postProcessing	: PostProcessingShaderPart	= null;
		private var _sampler		: SamplingShaderPart		= null;
		
		public function AntiAliasingShader(	edge			: ITextureResource,
										   	renderTarget	: RenderTarget		= null,
										   	priority		: Number			= 0.0)
		{
			super(renderTarget, priority);
			_edge = edge;
			_postProcessing = 	new PostProcessingShaderPart(this);
			_sampler 		= 	new SamplingShaderPart(this, float2(edge.width, edge.height));
		}	
		
		override protected function getVertexPosition() : SFloat
		{
			return _postProcessing.vertexPosition;
		}
		
		override protected function getPixelColor() : SFloat 
		{
			var uv : SFloat 	= interpolate(vertexUV.xy);
			var isEdge : SFloat = greaterThan(sampleTexture(getTexture(_edge), uv).x, 0.1);
			var color : SFloat =
				divide( 
					add(
						_postProcessing.sampleBackBuffer(add(uv, multiply(_sampler.offsets[1], isEdge))),
						_postProcessing.sampleBackBuffer(add(uv, multiply(_sampler.offsets[3], isEdge))),
						_postProcessing.sampleBackBuffer(add(uv, multiply(_sampler.offsets[5], isEdge))),
						_postProcessing.sampleBackBuffer(add(uv, multiply(_sampler.offsets[7], isEdge)))
					),
					4
				);
			return color;
		}
	}
}