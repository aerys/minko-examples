package aerys.minko.example.core.cubes
{
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import aerys.minko.render.Effect;
	import aerys.minko.render.geometry.primitive.CubeGeometry;
	import aerys.minko.render.material.Material;
	import aerys.minko.scene.node.ISceneNode;
	import aerys.minko.scene.node.Mesh;
	

	public class CubesExample extends AbstractExampleApplication
	{
		private static const MATERIAL	: Material	= new Material(new Effect(new NormalsShader()));
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
					scene.addChild(createCube());
			
			_lastTime = time;
			
			super.enterFrameHandler(event);
		}
		
		protected function createCube() : ISceneNode
		{
			var cube : Mesh = new Mesh(CubeGeometry.cubeGeometry, MATERIAL);
			
			cube.transform
				.lock()
				.appendUniformScale(0.03)
				.appendTranslation(
					-1 + Math.random() * 2,
					-1 + Math.random() * 2,
					-1 + Math.random() * 2
				)
				.unlock();
			
			return cube;
		}
	}
}