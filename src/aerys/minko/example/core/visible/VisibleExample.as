package aerys.minko.example.core.visible
{
    import aerys.minko.example.core.primitives.PrimitivesExample;
    import aerys.minko.scene.SceneIterator;
    import aerys.minko.scene.node.AbstractVisibleSceneNode;
    import aerys.minko.scene.node.Group;
    import aerys.minko.scene.node.Mesh;
    
    import flash.utils.setInterval;

    public class VisibleExample extends PrimitivesExample
    {
        override protected function initializeScene():void
        {
            super.initializeScene();
            
            for each (var m : Mesh in scene.get('//mesh'))
                scene.addChild(new Group(m));
            
            setInterval(function() : void
            {
                var nodes   : SceneIterator             = scene.get('/group');
                var node    : AbstractVisibleSceneNode  = nodes[uint(Math.random() * nodes.length)];
                
                node.visible = !node.visible;
            }, 2000);
        }
    }
}