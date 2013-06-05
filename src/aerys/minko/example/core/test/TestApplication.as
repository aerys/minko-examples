package aerys.minko.example.core.test
{
	import aerys.minko.render.geometry.Geometry;
	import aerys.minko.render.geometry.primitive.CubeGeometry;
	import aerys.minko.render.material.basic.BasicMaterial;
	import aerys.minko.scene.node.ISceneNode;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.type.math.Matrix4x4;
	import aerys.minko.type.math.Vector4;
	
	import flash.events.Event;

	public class TestApplication extends AbstractExampleApplication
	{
			private var objects			: Array;
			private var commonGeometry 	: Geometry 		= null;
			private var m				: BasicMaterial = new BasicMaterial( { diffuseColor : 0x00ff00ff } );
			
			override protected function initializeScene() : void 
			{
				super.initializeScene();
				
				objects = new Array();
				for (var i:int = 0; i < 1000; i++) 
				{
					var g:ISceneNode = createObject();
					
					g.transform.appendTranslation(((i % 10) - 5) * 10, 0, int(i / 10) * 10);
					scene.addChild(g);
					objects.push(g);
				}
			}
			
			override protected function enterFrameHandler(event : Event) : void {
				for each (var g:ISceneNode in objects)
				{
					g.transform.prependRotation(0.1, Vector4.Y_AXIS);
				}
				
				super.enterFrameHandler(event);
			}
			
			
			private function createObject():ISceneNode {
				
				if (!commonGeometry)
				{
					commonGeometry = new Geometry();
					
					for (var i:int = 0; i < 10; i++) 
					{
						var addedGeometry : CubeGeometry = new CubeGeometry();
						
						addedGeometry.applyTransform(new Matrix4x4().appendTranslation(i - 5, i / 2));		
						commonGeometry.merge(addedGeometry);
					}
				}
				
				return new Mesh(commonGeometry, m);
			}
			
		}

}