package aerys.minko.example.core.edgedetection.effects	 
{
	import aerys.minko.example.core.edgedetection.shaders.post.EdgeDetectionShader;
	import aerys.minko.example.core.edgedetection.shaders.post.FastBlurShader;
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.resource.texture.TextureResource;
	
	public class SmoothOutlineEffect extends OutlineEffect 
	{
		public function SmoothOutlineEffect( 	depthMap	: RenderTarget,
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
			
			addExtraPass(new EdgeDetectionShader(_depthMap.textureResource, _normalMap.textureResource, _outlineMap, 2));
			addExtraPass(new FastBlurShader(_outlineMap.textureResource, 2, null, 1));
		}
	}
}