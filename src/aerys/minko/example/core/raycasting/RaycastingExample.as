package aerys.minko.example.core.raycasting
{
	import aerys.minko.render.geometry.primitive.CubeGeometry;
	import aerys.minko.render.material.Material;
	import aerys.minko.render.material.basic.BasicMaterial;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.type.enum.Blending;
	
	import flash.events.MouseEvent;

	public class RaycastingExample extends MinkoExampleApplication
	{
		private var _selected			: Mesh		= null;
		
		private var _selectedMaterial	: Material	= new BasicMaterial({
			blending		: Blending.ALPHA,
			diffuseColor	: 0xff00007f
		});
		private var _material			: Material	= new BasicMaterial({
			blending		: Blending.ALPHA,
			diffuseColor	: 0xffffff1f
		});
		
		override protected function initializeScene() : void
		{
			super.initializeScene();

			cameraController.distance = 20;
			cameraController.pitch = 0.8;
			cameraController.yaw = Math.PI / 4;
			
			for (var x : uint = 0; x < 10; ++x)
			{
				for (var y : uint = 0; y < 10; ++y)
				{
					for (var z : uint = 0; z < 10; ++z)
					{
						var cube : Mesh = new Mesh(CubeGeometry.cubeGeometry, _material);
						
						cube.transform
							.appendTranslation(x - 4.5, y - 4.5, z - 4.5)
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
				_selected.material = _material;
			
			_selected = scene.cast(camera.unproject(event.stageX, event.stageY))[0];
			
			if (_selected)
				_selected.material = _selectedMaterial;
		}
	}
}