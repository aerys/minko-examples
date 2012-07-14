package aerys.minko.example.effects.hdr
{
	import aerys.minko.example.core.terrain.TerrainExample;
	import aerys.minko.render.effect.hdr.HDREffect;
	
	public class HDRExample extends TerrainExample
	{
		override protected function initializeScene():void
		{
			super.initializeScene();
			
			scene.postProcessingEffect = new HDREffect();
		}
	}
}