package aerys.minko.example.core.edgedetection.shaders {
	
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.resource.texture.ITextureResource;
	import aerys.minko.render.shader.SFloat;
	import aerys.minko.render.shader.Shader;
	import aerys.minko.render.shader.part.PostProcessingShaderPart;
	
	public class EdgeDectectionShader extends Shader{
		
		private var _postProcessing	: PostProcessingShaderPart		= null;
		private var _part			: EdgeDectectionShaderPart	 	= null;
		
		public function EdgeDectectionShader(	depthMap		: ITextureResource,
									  			normalMap		: ITextureResource,
												renderTarget	: RenderTarget		= null,
												priority		: Number			= 0.0){
			super(renderTarget, priority);
			_postProcessing = new PostProcessingShaderPart(this);
			_part 			= new EdgeDectectionShaderPart(	this, depthMap, normalMap, float2(depthMap.width, depthMap.height));
		}	
		
		override protected function getVertexPosition():SFloat{
			return _postProcessing.vertexPosition;
		}
		
		override protected function getPixelColor() : SFloat {
			return _part.getOutline( interpolate(vertexUV.xy) );
		}
	}
}