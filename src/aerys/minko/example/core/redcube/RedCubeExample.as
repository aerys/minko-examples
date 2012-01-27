package aerys.minko.example.core.redcube
{
	import aerys.minko.scene.node.group.Group;
	import aerys.minko.scene.node.mesh.primitive.CubeMesh;
	import aerys.minko.scene.node.texture.ColorTexture;
	import aerys.minko.type.math.Matrix4x4;
	
	import flash.events.Event;

	public class RedCubeExample extends MinkoExampleApplication
	{
		override protected function initializeScene():void
		{
			/*scene.addChild(new ColorTexture(0xff0000))
				 .addChild(CubeMesh.cubeMesh);*/
		}
		
		override protected function enterFrameHandler(event:Event):void
		{
			var m : Matrix4x4 = new Matrix4x4();
			var m2 : Matrix4x4 = new Matrix4x4();
			
			for (var i : int = 0; i < 1000000; ++i)
				m.append(m2);
		}
	}
}