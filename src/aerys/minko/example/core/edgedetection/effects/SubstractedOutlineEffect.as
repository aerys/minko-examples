package aerys.minko.example.core.edgedetection.effects	 
{
	import aerys.minko.example.core.edgedetection.shaders.post.EdgeDetectionShader;
	import aerys.minko.example.core.edgedetection.shaders.post.FastBlurShader;
	import aerys.minko.example.core.edgedetection.shaders.post.SubstractingShader;
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.resource.texture.TextureResource;
	
	public class SubstractedOutlineEffect extends OutlineEffect 
	{
		public function SubstractedOutlineEffect( 	depthMap	: RenderTarget,
													normalMap  	: RenderTarget,
													targetSize	: int = 2048) 
		{
			super(depthMap, normalMap, targetSize);
		}
		
		protected override function addExtraPasses() : void 
		{
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
			
			addExtraPass(new EdgeDetectionShader(_depthMap.textureResource, _normalMap.textureResource, _outlineMap, 3));
			addExtraPass(new FastBlurShader(_outlineMap.textureResource, 2, blured, 2));
			addExtraPass(new SubstractingShader(blured.textureResource, null, 1));
		}
	}
}