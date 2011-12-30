package aerys.minko.example.rtt
{
	import aerys.minko.render.effect.IEffect;
	import aerys.minko.render.effect.IEffectPass;
	import aerys.minko.render.effect.IRenderingEffect;
	import aerys.minko.render.effect.basic.BasicEffect;
	import aerys.minko.render.target.AbstractRenderTarget;
	import aerys.minko.scene.data.StyleData;
	import aerys.minko.scene.data.TransformData;
	import aerys.minko.scene.node.texture.RenderTargetTexture;
	
	import flash.utils.Dictionary;
	
	public class SimpleRTTEffect implements IRenderingEffect
	{
		private var _passes	: Vector.<IEffectPass>	= null;
		
		public function SimpleRTTEffect(target : AbstractRenderTarget)
		{
			_passes = new <IEffectPass>[
				new BasicEffect(1, target),
				new BasicEffect()
			];
		}
		
		public function getPasses(styleData		: StyleData,
								  transformData	: TransformData,
								  worldData		: Dictionary) : Vector.<IEffectPass>
		{
			return _passes;
		}
	}
}