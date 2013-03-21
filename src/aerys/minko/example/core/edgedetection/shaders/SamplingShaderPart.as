package aerys.minko.example.core.edgedetection.shaders {
	
	import aerys.minko.render.resource.texture.ITextureResource;
	import aerys.minko.render.shader.SFloat;
	import aerys.minko.render.shader.Shader;
	import aerys.minko.render.shader.part.ShaderPart;
	
	public class SamplingShaderPart extends ShaderPart{
		
		/* 
		Neighbor offset table  
		1 2 3
		8 0 4
		7 6 5
		*/  
		public var offsets : Array;
		
		public function SamplingShaderPart(	main 		: Shader, 
											resolution	: SFloat = null){
			super(main);
			initOffsets(resolution);
		} 
		
		public function getPixel( input : ITextureResource , uv : SFloat, offset : int = 0) : SFloat {
			return sampleTexture(getTexture(input), add(uv, offsets[offset]));
		}
		
		public function initOffsets( resolution : SFloat ):void{
			offsets = [
				divide(float2( 0,  0)	, resolution), 	//Center       0  
				divide(float2(-1, -1)	, resolution), 	//Top Left     1  
				divide(float2( 0, -1)	, resolution),	//Top          2  
				divide(float2( 1, -1)	, resolution), 	//Top Right    3  
				divide(float2( 1,  0)	, resolution), 	//Right        4  
				divide(float2( 1,  1)	, resolution), 	//Bottom Right 5  
				divide(float2( 0,  1)	, resolution), 	//Bottom       6  
				divide(float2(-1,  1)	, resolution), 	//Bottom Left  7  
				divide(float2(-1,  0)	, resolution)  	//Left         8  
			];  
		}
		
	}
}