package aerys.minko.example.core.raytracer
{
	import aerys.minko.render.Effect;
	
	[SWF(width="600",height="600")]
	public class RayTracerExample extends MinkoExampleApplication
	{
		override protected function initializeScene():void
		{
			super.initializeScene();
			
			scene.postProcessingEffect = new Effect(new RayTracerShader());
		}
	}
}