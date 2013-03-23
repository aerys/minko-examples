package aerys.minko.example.core.edgedetection.shaders.post 
{
	
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.resource.texture.ITextureResource;
	import aerys.minko.render.shader.SFloat;
	import aerys.minko.render.shader.Shader;
	import aerys.minko.render.shader.part.PostProcessingShaderPart;
	
	public class EdgeDetectionShader extends Shader
	{
		private var _postProcessing	: PostProcessingShaderPart		= null;
		private var _part			: EdgeDetectionShaderPart	 	= null;
		
		public function EdgeDetectionShader(	depthMap		: ITextureResource,
									  			normalMap		: ITextureResource,
												renderTarget	: RenderTarget		= null,
												priority		: Number			= 0.0)
		{
			super(renderTarget, priority);
			var resolution : SFloat = float2(depthMap.width, depthMap.height);
			_postProcessing = new PostProcessingShaderPart(this);
			_part 			= new EdgeDetectionShaderPart(this, depthMap, normalMap, resolution);
		}	
		
		override protected function getVertexPosition() : SFloat
		{
			return _postProcessing.vertexPosition;
		}
		
		override protected function getPixelColor() : SFloat 
		{
			return _part.getOutline( interpolate(vertexUV.xy) );
		}
	}
}