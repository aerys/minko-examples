package aerys.minko.example.ai.fsm
{
	import aerys.minko.ai.fsm.AbstractState;
	import aerys.minko.ai.msa.environment.Environment;
	import aerys.minko.render.Viewport;
	import aerys.minko.scene.node.ISceneNode;
	import aerys.minko.scene.node.Scene;
	import aerys.minko.type.math.Matrix4x4;
	import aerys.minko.type.math.Vector4;
	
	import flash.display.BitmapData;
	
	public class SearchKeyPoint extends AbstractState
	{
		private var _keyPoint : Vector4 = null;
		
		public function SearchKeyPoint(environment : Environment, keyPoint : Vector4)
		{
			super(environment);
			
			_keyPoint = keyPoint;
		}
		
		override protected function sceneEnterFrameHandler(scene		: Scene, 
														   viewport		: Viewport, 
														   destination	: BitmapData, 
														   time			: Number):void
		{
			var numTargets : uint = numTargets;
			
			for (var i : uint = 0; i < numTargets; ++i)
			{
				var target 	: ISceneNode 	= getTarget(i);
				var position 	: Vector4 		= target.transform.getTranslation();
				
				if (Vector4.distance(position, _keyPoint) < 1)
					target.transform.setTranslation(_keyPoint.x, 0, _keyPoint.z);
				else
				{
					var direction : Vector4 = new Vector4(_keyPoint.x - position.x, 0, _keyPoint.z - position.z);
				
					direction.normalize();
				
					target.transform.appendTranslation(direction.x, 0, direction.z);
				}
			}
		}
	}
}