package aerys.minko.example.core.redcube
{
	import aerys.minko.Minko;
	import aerys.minko.scene.node.mesh.Mesh;
	import aerys.minko.scene.node.mesh.geometry.primitive.CubeGeometry;
	import aerys.minko.type.log.DebugLevel;
	import aerys.minko.type.math.Ray;
	import aerys.minko.type.math.Vector4;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;

	public class RedCubeExample extends MinkoExampleApplication
	{
		override protected function initializeScene() : void
		{
			super.initializeScene();
			
			scene.addChild(
				new Mesh(
					CubeGeometry.cubeGeometry,
					{ diffuseColor : 0xff0000ff }
				)
			);
			
			camera.transform.appendTranslation(0, 0, -5);
		}
		
	}
}