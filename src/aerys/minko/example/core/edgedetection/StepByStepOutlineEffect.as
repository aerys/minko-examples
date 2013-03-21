package aerys.minko.example.core.edgedetection {
	
	import aerys.minko.example.core.edgedetection.shaders.AntiAliasingShader;
	import aerys.minko.example.core.edgedetection.shaders.FastBlurShader;
	import aerys.minko.example.core.edgedetection.shaders.EdgeDectectionShader;
	import aerys.minko.example.core.edgedetection.shaders.SubstractingShader;
	import aerys.minko.render.Effect;
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.resource.texture.TextureResource;
	
	public class StepByStepOutlineEffect extends Effect {
		
		private var _targetSize			: int;
		private var _useAsAntialiasing 	: Boolean;
		private var _stopAfterStep 		: int;
		
		private var _depthMap			: RenderTarget	= null;
		private var _normalMap  		: RenderTarget  = null;
		
		public function StepByStepOutlineEffect( 	depthMap			: RenderTarget,
										normalMap  			: RenderTarget,
										stopAfterStep		: int 		= -1,
										useAsAntialiasing 	: Boolean 	= false, 
										targetSize			: int 		= 2048 ) {
			super();
			_targetSize 		= targetSize;
			_useAsAntialiasing 	= useAsAntialiasing;
			_stopAfterStep 		= stopAfterStep;
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
			
			switch (_stopAfterStep) {
				case 1:
					addExtraPass(new EdgeDectectionShader(_depthMap.textureResource, _normalMap.textureResource, null, 3));
					break;
				case 2:
					addExtraPass(new EdgeDectectionShader(_depthMap.textureResource, _normalMap.textureResource, _outlineMap, 3));
					addExtraPass(new FastBlurShader(_outlineMap.textureResource, 2, null, 2));
					break;
				default:
					addExtraPass(new EdgeDectectionShader(_depthMap.textureResource, _normalMap.textureResource, _outlineMap, 3));
					addExtraPass(new FastBlurShader(_outlineMap.textureResource, 2, blured, 2));
					if(_useAsAntialiasing){
						addExtraPass(new AntiAliasingShader(blured.textureResource, null, 1));
					}else{
						addExtraPass(new SubstractingShader(blured.textureResource, null, 1));
					}
					break;
			}
		}
		
		
	}
}