package aerys.minko.example.effects.hdr
{
	import aerys.minko.example.core.terrain.TerrainExample;
	import aerys.minko.render.effect.hdr.HDREffect;
	import aerys.minko.render.effect.hdr.HDRQuality;
	
	public class HDRExample extends TerrainExample
	{
		override protected function initializeScene():void
		{
			super.initializeScene();
			
			scene.postProcessingEffect = new HDREffect(HDRQuality.NORMAL, 4);
			scene.postProcessingProperties.setProperties({
				hdrIntensity : .3
			});
		}
	}
}