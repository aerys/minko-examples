package aerys.minko.example.core.raycasting
{
	import aerys.minko.scene.node.mesh.Mesh;
	import aerys.minko.scene.node.mesh.geometry.primitive.CubeGeometry;
	import aerys.minko.type.math.Vector4;
	import aerys.monitor.Monitor;
	
	import flash.events.MouseEvent;
	import flash.utils.getTimer;

	public class RaycastingExample extends MinkoExampleApplication
	{
		private var _selected	: Mesh	= null;
		
		override protected function initializeScene() : void
		{
			super.initializeScene();

			cameraController.distance = 20;
			cameraController.phi = 0.8;
			cameraController.theta = Math.PI / 4;
			
			scene.properties.setProperties({
				lightEnabled		: true,
				lightDiffuseColor	: 0xffffff,
				lightDiffuse		: 0.8,
				lightAmbientColor	: 0xffffff,
				lightAmbient		: 0.2,
				lightDirection		: new Vector4(0, -1, -.5)
			});
			
			for (var x : uint = 0; x < 10; ++x)
			{
				for (var y : uint = 0; y < 10; ++y)
				{
					for (var z : uint = 0; z < 10; ++z)
					{
						var cube : Mesh = new Mesh(
							CubeGeometry.cubeGeometry,
							{
								diffuseColor 	: 0xffffffff,
								lightEnabled	: true
							}
						);
						
						cube.transform.appendTranslation(x - 4.5, y - 4.5, z - 4.5)
							.prependUniformScale(.5);
						
						scene.addChild(cube);
					}
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