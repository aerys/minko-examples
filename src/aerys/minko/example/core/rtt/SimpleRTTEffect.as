package aerys.minko.example.core.rtt
{
	import aerys.minko.render.effect.IEffectPass;
	import aerys.minko.render.effect.IRenderingEffect;
	import aerys.minko.render.effect.AbstractSinglePassEffect;
	import aerys.minko.render.effect.basic.BasicShader;
	import aerys.minko.render.target.AbstractRenderTarget;
	import aerys.minko.scene.data.StyleData;
	import aerys.minko.scene.data.TransformData;
	
	import flash.utils.Dictionary;
	
	public class SimpleRTTEffect implements IRenderingEffect
	{
		private var _passes	: Vector.<IEffectPass>	= null;
		
		public function SimpleRTTEffect(target : AbstractRenderTarget)
		{
			_passes = new <IEffectPass>[
				new AbstractSinglePassEffect(new BasicShader(), 1, target),
				new AbstractSinglePassEffect(new BasicShader()),
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