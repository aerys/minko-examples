package aerys.minko.example.core.edgedetection {
	
	import aerys.minko.example.core.edgedetection.shaders.EdgeDectectionShader;
	import aerys.minko.example.core.edgedetection.shaders.FastBlurShader;
	import aerys.minko.example.core.edgedetection.shaders.SubstractingShader;
	import aerys.minko.render.Effect;
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.resource.texture.TextureResource;
	
	public class OutlineEffect extends Effect {
		
		private var _targetSize			: int;
		
		private var _depthMap			: RenderTarget	= null;
		private var _normalMap  		: RenderTarget  = null;
		
		public function OutlineEffect( 	depthMap			: RenderTarget,
										normalMap  			: RenderTarget,
										useAsAntialiasing 	: Boolean 	= false, 
										targetSize			: int 		= 2048 ) {
			super();
			_targetSize 		= targetSize;
			_depthMap 			= depthMap;
			_normalMap 			= normalMap;
			initialize();
		}
		
		private function initialize() : void {
			var _outlineMap : RenderTarget = new RenderTarget(
				_targetSize,
				_targetSize,
				new TextureResource(_targetSize, _targetSize),
				0,
				0xffffffff
			); 
			
			var blured : RenderTarget = new RenderTarget(
				_targetSize,
				_targetSize,
				new TextureResource(_targetSize, _targetSize),
				0,
				0xffffffff
			); 
			
			addExtraPass(new EdgeDectectionShader(_depthMap.textureResource, _normalMap.textureResource, _outlineMap, 3));
			addExtraPass(new FastBlurShader(_outlineMap.textureResource, 2, blured, 2));
			addExtraPass(new SubstractingShader(blured.textureResource, null, 1));
		}
		
		
	}
}