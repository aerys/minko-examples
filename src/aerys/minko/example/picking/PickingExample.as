package aerys.minko.example.picking
{
	import aerys.minko.render.effect.Effect;
	import aerys.minko.render.effect.basic.BasicShader;
	import aerys.minko.scene.controller.PickingController;
	import aerys.minko.scene.node.Group;
	import aerys.minko.scene.node.mesh.Mesh;
	import aerys.minko.scene.node.mesh.primitive.SphereMesh;
	import aerys.minko.type.math.Matrix4x4;

	public class PickingExample extends MinkoExampleApplication
	{
		private var _pickingBox	: PickingBox	= null;
		private var _selected	: Group			= null;
		
		override protected function initializeScene() : void
		{
			var sphere : Group = new Group(
				new SphereMesh(
					new Effect(new BasicShader()),
					{ diffuseColor: 0xffffffff },
					20
				)
			);
			
			var picking : PickingController = new PickingController(30);
			
			picking.bindDefaultInputs(stage);
			picking.mouseDown.add(mouseDownHandler);
//			picking.mouseClick.add(mouseClickHandler);
			
			sphere.addController(picking);
			scene.addChild(sphere);

			_pickingBox = new PickingBox(viewport, camera, stage);
//			scene.addChild(_pickingBox);
		}
		
		private function mouseDownHandler(ctrl	: PickingController,
										  target	: Mesh,
										  mouseX	: Number,
										  mouseY	: Number) : void
		{
			var pickingBoxController : PickingBoxController = _pickingBox.getController(0)
				as PickingBoxController;
			
			if (target)
			{
				pickingBoxController.moved.add(pickingBoxMovedHandler);
				scene.addChild(_pickingBox);
				
				_selected = target.parent;
			}
		}
		
		private function mouseClickHandler(ctrl		: PickingController,
										   target	: Mesh,
										   mouseX	: Number,
										   mouseY	: Number) : void
		{
			if (!target && _selected)
			{
				var pickingBoxController : PickingBoxController = _pickingBox.getController(0)
					as PickingBoxController;
				
				pickingBoxController.moved.remove(pickingBoxMovedHandler);
				_pickingBox.parent = null;
				
				_selected = null;
			}
		}
		
		private function pickingBoxMovedHandler(picking		: PickingBoxController,
												matrix		: Matrix4x4) : void
		{
			_selected.transform.copyFrom(matrix);
		}
	}
}