package aerys.minko.example.physics.pyramid
{
    import aerys.minko.physics.api.ColliderController;
    import aerys.minko.physics.collider.Collider;
    import aerys.minko.scene.controller.AbstractScriptController;
    import aerys.minko.scene.node.ISceneNode;
    import aerys.minko.scene.node.Scene;
    import aerys.minko.type.math.Ray;
    
    public class ThrowScript extends AbstractScriptController
    {
        private var _item   : ISceneNode;
        private var _key    : uint;
        
        public function ThrowScript(item : ISceneNode, key : uint = 32)
        {
            super(Scene);
			
			updateRate = 10;
            
            _item = item;
            _key = key;
        }
        
		override protected function beforeUpdate():void
		{
			if (keyboard.keyIsDown(_key))
			{
				var ray         : Ray           = scene.activeCamera.unproject(mouse.x, mouse.y);
				var item        : ISceneNode    = _item.clone();
				var collider    : Collider      = ColliderController.extractColliderFromNode(item);
				
				scene.activeCamera.getLocalToWorldTransform(false, item.transform);
				ray.direction.scaleBy(100).toVector3D(collider.dynamics.velocity);
				
				scene.addChild(item);
			}
		}
    }
}
