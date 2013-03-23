package aerys.minko.example.core.edgedetection.effects 
{
	import aerys.minko.example.core.edgedetection.shaders.post.EdgeDetectionShader;
	import aerys.minko.render.Effect;
	import aerys.minko.render.RenderTarget;
	
	public class OutlineEffect extends Effect
	{
		protected var _targetSize	: int;
		protected var _depthMap		: RenderTarget	= null;
		protected var _normalMap  	: RenderTarget  = null;
		
		public function OutlineEffect( 	depthMap			: RenderTarget,
										normalMap  			: RenderTarget,
										targetSize			: int 		= 2048) 
		{
			super();
			_targetSize = targetSize;
			_depthMap 	= depthMap;
			_normalMap 	= normalMap;
			addExtraPasses();
		}
		
		protected function addExtraPasses() : void 
		{
			addExtraPass(new EdgeDetectionShader(_depthMap.textureResource, _normalMap.textureResource));
		}
	}
}