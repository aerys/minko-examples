package aerys.minko.example.core.raycast
{
	import aerys.minko.scene.node.mesh.Mesh;
	import aerys.minko.scene.node.mesh.geometry.primitive.CubeGeometry;
	import aerys.minko.type.math.Vector4;
	
	import flash.events.MouseEvent;

	public class RaycastExample extends MinkoExampleApplication
	{
		private var _selected	: Mesh	= null;
		
		override protected function initializeScene() : void
		{
			super.initializeScene();
			
			cameraController.rotateX(.4);
			
			scene.properties.setProperties({
				lightEnabled		: true,
				lightDiffuseColor	: 0xffffff,
				lightDiffuse		: 0.8,
				lightAmbientColor	: 0xffffff,
				lightAmbient		: 0.2,
				lightDirection		: new Vector4(0, -1, 0.5)
			});
			
			for (var x : uint = 0; x < 4; ++x)
			{
				for (var y : uint = 0; y < 4; ++y)
				{
					var cube : Mesh = new Mesh(
						CubeGeometry.cubeGeometry,
						{
							diffuseColor 	: 0xffffffff,
							lightEnabled	: true
						}
					);
					
					cube.transform.appendTranslation(x - 1.5, 0, y - 1.5)
						.prependUniformScale(.5);
					
					scene.addChild(cube);
				}
			}
			
			stage.addEventListener(MouseEvent.CLICK, mouseClickHandler);
		}
		
		private function mouseClickHandler(event : MouseEvent) : void
		{
			if (_selected)
				_selected.properties.setProperty('diffuseColor', 0xffffffff);
			
			_selected = scene.cast(camera.unproject(event.stageX, event.stageY))[0];
			
			if (_selected)
				_selected.properties.setProperty('diffuseColor', 0xff0000ff);
		}
	}
}