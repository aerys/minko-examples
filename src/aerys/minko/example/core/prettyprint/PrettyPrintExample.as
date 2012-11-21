package aerys.minko.example.core.prettyprint
{
    import aerys.minko.render.geometry.primitive.CubeGeometry;
    import aerys.minko.render.material.basic.BasicMaterial;
    import aerys.minko.scene.node.Group;
    import aerys.minko.scene.node.ISceneNode;
    import aerys.minko.scene.node.Mesh;

    public class PrettyPrintExample extends AbstractExampleApplication
    {
        override protected function initializeScene() : void
        {
            super.initializeScene();
            
            var root : Group = scene;
            
            // initialize some random scene...
            for (var groupId : uint = 0; groupId < 20; ++groupId)
            {
                var rand : Number = Math.random();
                
                if (rand < 1 / 3)
                {
                    if (root.parent)
                        root = root.parent;
                    
                }
                else if (rand < 2 / 3)
                {
                    var newGroup : Group = new Group();
                    
                    root.addChild(newGroup);
                    root = newGroup;
                }
                else
                {
                    var numMeshes : uint = 20 * Math.random();
                    
                    for (var meshId : uint = 0; meshId < 20; ++meshId)
                    {
                        var mesh : Mesh = new Mesh(
                            CubeGeometry.cubeGeometry,
                            new BasicMaterial({
                                diffuseColor : ((Math.random() * 0xffffff) << 8) | 0xff
                            })
                        );
                        
                        mesh.transform.appendTranslation(
                            -20 + Math.random() * 40,
                            -20 + Math.random() * 40,
                            -20 + Math.random() * 40
                        );
                        
                        root.addChild(mesh);
                    }
                }
            }
            
            prettyPrint(scene);
        }
        
        private function prettyPrint(root : Group, depth : uint = 0) : void
        {
            var numChildren : uint = root.numChildren;
            var str : String = '';
            
            for (var i : uint = 0; i < depth; ++i)
                str += '  ';
            
            for (var j : uint = 0; j < numChildren; ++j)
            {
                var child : ISceneNode = root.getChildAt(j);
                
                if (child is Group)
                {
                    trace(str + '+ ' + child.name);
                    prettyPrint(child as Group, depth + 1);
                }
                else
                    trace(str + '|- ' + child.name);
            }
        }
    }
}