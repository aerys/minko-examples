package aerys.minko.example.core.teapots
{
	import aerys.minko.example.core.cubes.NormalsShader;
	import aerys.minko.render.Effect;
	import aerys.minko.render.geometry.Geometry;
	import aerys.minko.render.geometry.primitive.TeapotGeometry;
	import aerys.minko.render.material.Material;
	import aerys.minko.scene.node.Mesh;
	import aerys.monitor.Monitor;
	
	import flash.events.Event;
	import flash.utils.getTimer;
	
	
	public class TeapotsExample extends AbstractExampleApplication
	{
		private static const MATERIAL	: Material	= new Material(new Effect(new NormalsShader()));
		private static const TARGET_FPS	: Number	= 30;
		private static const GEOMETRY	: Geometry	= new TeapotGeometry(17);
		
		private var _lastTime	: int	= 0;
		
		override protected function initializeScene() : void
		{
			super.initializeScene();
			
			viewport.backgroundColor = 0;
			
			_lastTime = getTimer();
		}
		
		override protected function enterFrameHandler(event : Event) : void
		{
			var time : int = getTimer();
			
			if (Monitor.monitor.framerate > TARGET_FPS)
				addTeapot();
			
			_lastTime = time;
			
			super.enterFrameHandler(event);
		}
		
		private function addTeapot() : void
		{
			var teapot : Mesh = new Mesh(GEOMETRY, MATERIAL);
			
			teapot.transform
				.appendUniformScale(0.03)
				.appendTranslation(
					-1 + Math.random() * 2,
					-1 + Math.random() * 2,
					-1 + Math.random() * 2
				);
			
			scene.addChild(teapot);
		}
	}
}