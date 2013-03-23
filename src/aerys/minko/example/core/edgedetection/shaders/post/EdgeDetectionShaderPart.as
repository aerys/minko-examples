package aerys.minko.example.core.edgedetection.shaders.post 
{
	import aerys.minko.render.resource.texture.ITextureResource;
	import aerys.minko.render.shader.SFloat;
	import aerys.minko.render.shader.Shader;
	
	/**
	 * 	Adapted from http://http.developer.nvidia.com/GPUGems2/gpugems2_chapter09.html
	 */

	public class EdgeDetectionShaderPart extends SamplingShaderPart 
	{
		private var _barrier 	: SFloat = float2	( .99 , .0001);
		private var _weights 	: SFloat = float2	( .4  , .5 );
		private var _kernel  	: SFloat = float2	( 1.5 , 3. );
		
		private var _depthMap	: ITextureResource	= null;
		private var _normalMap	: ITextureResource	= null;
		
		public function EdgeDetectionShaderPart(	main : Shader, 
													depthMap	: ITextureResource,
													normalMap	: ITextureResource,
													resolution : SFloat)
		{
			super(main, resolution);
			_depthMap 	= depthMap;
			_normalMap 	= normalMap; 
		} 
		
		public function getOutline(uv : SFloat) : SFloat 
		{
			var normalOutline	: SFloat = normalDiscontinuityFilter( uv );
			var depthOutline	: SFloat = depthFilter( uv );
			return combineOutlines( normalOutline, depthOutline );
		}
		
		public function combineOutlines(normalOutline	: SFloat, depthOutline	: SFloat) : SFloat
		{
			var weight : SFloat = multiply(subtract(1, float2(normalOutline, depthOutline)), _kernel);
			return add(weight.x, weight.y);
		}
		
		public function normalDiscontinuityFilter(uv : SFloat) : SFloat
		{
			var nd : SFloat = float4(0,0,0,0);
			var center : SFloat = getPixel(_normalMap, uv);
			nd.x = dotProduct3(center.rgb, getPixel(_normalMap, uv, 1).rgb);
			nd.y = dotProduct3(center.rgb, getPixel(_normalMap, uv, 5).rgb);
			nd.z = dotProduct3(center.rgb, getPixel(_normalMap, uv, 3).rgb);
			nd.w = dotProduct3(center.rgb, getPixel(_normalMap, uv, 7).rgb);
			nd = subtract(nd , _barrier.x);
			nd = greaterThan(nd, 0);
			return saturate(dotProduct4(nd, _weights.x));
		}
		
		public function depthFilter(uv : SFloat) : SFloat
		{
			var dd : SFloat = float4(0,0,0,0);
			dd.x = add(unpack(getPixel(_depthMap, uv, 1)).x, unpack(getPixel(_depthMap, uv, 5)).x);
			dd.y = add(unpack(getPixel(_depthMap, uv, 3)).x, unpack(getPixel(_depthMap, uv, 7)).x);
			dd.z = add(unpack(getPixel(_depthMap, uv, 8)).x, unpack(getPixel(_depthMap, uv, 4)).x);
			dd.w = add(unpack(getPixel(_depthMap, uv, 2)).x, unpack(getPixel(_depthMap, uv, 6)).x);
			dd = subtract(absolute(subtract(multiply(2, unpack(getPixel(_depthMap, uv, 0)).x), dd)), _barrier.y);
			dd = greaterThan(0, dd);
			return saturate(dotProduct4(dd, _weights.y));
		}
		
	}
}