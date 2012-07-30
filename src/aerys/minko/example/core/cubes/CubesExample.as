package aerys.minko.example.core.cubes
{
	import aerys.minko.render.effect.Effect;
	import aerys.minko.scene.node.mesh.Mesh;
	import aerys.minko.scene.node.mesh.geometry.primitive.CubeGeometry;
	
	import flash.events.Event;
	import flash.utils.getTimer;
	

	public class CubesExample extends MinkoExampleApplication
	{
		private static const EFFECT		: Effect	= new Effect(new NormalsShader());
		private static const TARGET_FPS	: Number	= 30;
		
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
			
			if (1000. / (time - _lastTime) > TARGET_FPS)
				for (var i : uint = 0; i < 10; ++i)
					addCube();
			
			_lastTime = time;
			
			super.enterFrameHandler(event);
		}
		
		private function addCube() : void
		{
			var cube : Mesh = new Mesh(
				CubeGeometry.cubeGeometry,
				null,
				EFFECT
			);
			
			cube.transform
				.lock()
				.appendUniformScale(0.03)
				.appendTranslation(
					-1 + Math.random() * 2,
					-1 + Math.random() * 2,
					-1 + Math.random() * 2
				)
				.unlock();
			
			scene.addChild(cube);
		}
	}
}