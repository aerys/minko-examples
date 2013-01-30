package aerys.minko.example.core.raycasting
{
	import aerys.minko.render.geometry.primitive.CubeGeometry;
	import aerys.minko.render.material.Material;
	import aerys.minko.render.material.basic.BasicMaterial;
	import aerys.minko.render.material.phong.PhongMaterial;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.scene.node.light.AmbientLight;
	import aerys.minko.scene.node.light.DirectionalLight;
	import aerys.minko.type.enum.Blending;
	import aerys.minko.type.math.Vector4;
	
	import flash.events.MouseEvent;

	public class RaycastingExample extends AbstractExampleApplication
	{
		private var _selected			: Mesh;
		private var _selectedMaterial	: Material;
		private var _material			: Material;
		
		override protected function initializeScene() : void
		{
			super.initializeScene();
            
            _material = new PhongMaterial({ diffuseColor : 0xffffffff });
            _selectedMaterial = new PhongMaterial({ diffuseColor : 0xff0000ff });
            
            var light : DirectionalLight = new DirectionalLight();
            
            light.transform.lookAt(Vector4.ZERO, new Vector4(.8, 1, .5));
            
            scene.addChild(light).addChild(new AmbientLight(0xffffffff, .5));
            
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