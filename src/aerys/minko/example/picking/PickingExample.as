package aerys.minko.example.picking
{
	import aerys.minko.scene.controller.PickingController;
	import aerys.minko.scene.node.Group;
	import aerys.minko.scene.node.mesh.Mesh;
	import aerys.minko.scene.node.mesh.geometry.primitive.CubeGeometry;
	import aerys.minko.scene.node.mesh.geometry.primitive.SphereGeometry;
	import aerys.minko.type.loader.TextureLoader;
	import aerys.minko.type.math.Matrix4x4;
	import aerys.minko.type.math.Vector4;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;
	import flash.utils.setTimeout;

	public class PickingExample extends MinkoExampleApplication
	{
		private var _picking	: PickingController	= new PickingController(30);
		
		private var _pickingBox	: PickingBox		= null;
		private var _selected	: Mesh				= null;
		private var _selectable	: Group				= new Group();
		
		override protected function initializeScene() : void
		{
			scene.bindings.setProperties({
				lightEnabled		: true,
				lightDiffuseColor	: 0xffffff,
				lightDiffuse		: 0.8,
				lightAmbientColor	: 0xffffff,
				lightAmbient		: 0.2,
				lightDirection		: new Vector4(-1, -1, 1)
			});
			
			var sphere : Mesh = new Mesh(
				new SphereGeometry(20),
				{
					diffuseColor	: 0xffffffff,
					lightEnabled	: true
				}
			);
			
			var cube : Mesh = new Mesh(
				CubeGeometry.cubeGeometry,
				{
					diffuseColor	: 0xffffffff,
					lightEnabled	: true
				}
			);
			
			cube.transform.appendTranslation(1, 0, 0).appendUniformScale(2);
			
			_pickingBox = new PickingBox(viewport, camera, stage);
			
			_picking.bindDefaultInputs(stage);
			_picking.mouseDown.add(mouseDownHandler);

			_selectable.addController(_picking);
			_selectable.addChild(sphere);
			_selectable.addChild(cube);
			scene.addChild(_selectable);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		}
		
		private function mouseDownHandler(ctrl		: PickingController,
										  target	: Mesh,
										  mouseX	: Number,
										  mouseY	: Number) : void
		{
			if (target)
			{
				_pickingBox.selectedMesh = target;
				_pickingBox.parent = scene;
			}
		}
		
		private function keyDownHandler(event : KeyboardEvent) : void
		{
			if (event.keyCode == Keyboard.ESCAPE)
			{
				_pickingBox.selectedMesh = null;
				_pickingBox.parent = null;
			}
		}
	}
}