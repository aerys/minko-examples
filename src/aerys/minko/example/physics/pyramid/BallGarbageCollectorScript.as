package aerys.minko.example.physics.pyramid
{
    import aerys.minko.render.material.Material;
    import aerys.minko.scene.controller.AbstractController;
    import aerys.minko.scene.controller.AbstractScriptController;
    import aerys.minko.scene.controller.animation.AnimationController;
    import aerys.minko.scene.node.ISceneNode;
    import aerys.minko.scene.node.Mesh;
    import aerys.minko.type.animation.timeline.ITimeline;
    import aerys.minko.type.animation.timeline.MatrixTimeline;
    import aerys.minko.type.enum.Blending;
    import aerys.minko.type.math.HSLAMatrix4x4;
    import aerys.minko.type.math.Matrix4x4;
    
    public class BallGarbageCollectorScript extends AbstractScriptController
    {
        private var _minY       : Number;
        private var _fadeOut    : Boolean;
        
        public function BallGarbageCollectorScript(minY : Number, fadeOut : Boolean = false)
        {
            super();
			
			updateRate = 1;
            
            _minY = minY;
            _fadeOut = fadeOut;
        }
        
        override protected function update(target : ISceneNode) : void
        {
            if (target.transform.translationY < _minY)
            {
                var mesh : Mesh = target as Mesh;
                
                target.removeController(this);
                
                if (mesh && _fadeOut)
                {
                    var fadeOut : AnimationController = new AnimationController(
                        new <ITimeline>[new MatrixTimeline(
                                'material.diffuseTransform',
                                new <uint>[0, 1000],
                                new <Matrix4x4>[new HSLAMatrix4x4(), new HSLAMatrix4x4(0, 1, 1, 0)],
                                true,
                                true,
                                true
                        )],
                        false
                    );
                
                    mesh.material = mesh.material.clone() as Material;
                    mesh.material.blending = Blending.ALPHA;
                    mesh.material.diffuseTransform = new Matrix4x4();
                    
                    fadeOut.stopped.add(function(ctrl : AnimationController) : void
                    {
                        mesh.parent = null;
                    });
                
                    mesh.addController(fadeOut);
                }
                else
                    target.parent = null;
            }
        }
        
        override public function clone() : AbstractController
        {
            return new BallGarbageCollectorScript(_minY);
        }
    }
}