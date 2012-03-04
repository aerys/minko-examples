package aerys.minko.example.picking
{
	import aerys.minko.scene.controller.PickingController;
	import aerys.minko.scene.node.Group;
	import aerys.minko.scene.node.mesh.Mesh;
	import aerys.minko.scene.node.mesh.geometry.primitive.SphereGeometry;
	import aerys.minko.type.math.Matrix4x4;
	import aerys.minko.type.math.Vector4;
	
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	public class PickingExample extends MinkoExampleApplication
	{
		private var _picking	: PickingController	= new PickingController(30);
		
		private var _pickingBox	: PickingBox		= null;
		private var _selected	: Group				= null;
		
		override protected function initializeScene() : void
		{
			scene.bindings.setProperties({
				lightEnabled		: true,
				lightDiffuseColor	: 0xffffff,
				lightDiffuse		: 0.8,
				lightAmbientColor	: 0xffffff,
				lightAmbient		: 0.2,
				lightDirection		: new Vector4(0.25, -0.5, 1)
			});
			
			var sphere : Group = new Group(
				new Mesh(
					SphereGeometry.sphereGeometry,
					{
						diffuseColor	: 0xffffffff,
						lightEnabled	: true
					}
				)
			);
			
			var sphere2 : Group = new Group(
				new Mesh(
					SphereGeometry.sphereGeometry,
					{
						diffuseColor	: 0xffffffff,
						lightEnabled	: true
					}
				)
			);
			
			sphere2.transform.appendTranslation(1, 0, 0);
			
			_pickingBox = new PickingBox(viewport, camera, stage);
//			scene.addChild(_pickingBox);
			
			_picking.bindDefaultInputs(stage);
			_picking.mouseClick.add(mouseClickHandler);

			sphere.addController(_picking);
			scene.addChild(sphere);
			
			sphere2.addController(_picking);
			scene.addChild(sphere2);
			
			scene.bindings.setProperties({
				lightEnabled	: true,
				lightColor 		: 0xffffffff,
				lightDirection	: new Vector4(-1, -1, 1),
				ambient			: .2
			});
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		}
		
		private function mouseClickHandler(ctrl		: PickingController,
									 	   target	: Mesh,
										   mouseX	: Number,
										   mouseY	: Number) : void
		{
			var pickingBoxController : PickingBoxController = _pickingBox.getController(0)
				as PickingBoxController;
			
			if (target)
			{
				_selected = target.parent;
				
				Matrix4x4.copy(_selected.transform, _pickingBox.transform);
				pickingBoxController.moved.add(pickingBoxMovedHandler);
				scene.addChild(_pickingBox);
			}
//			else if (_selected && !_pickingBox.active)
//			{
//				_selected = null;
//				
//				pickingBoxController.moved.add(pickingBoxMovedHandler);
//				_pickingBox.parent = null;
//			}
		}
		
		private function keyDownHandler(event : KeyboardEvent) : void
		{
			if (event.keyCode == Keyboard.ESCAPE)
			{
				var pickingBoxController : PickingBoxController = _pickingBox.getController(0)
					as PickingBoxController;
				
				_selected = null;
				pickingBoxController.moved.add(pickingBoxMovedHandler);
				_pickingBox.parent = null;
			}
		}
	
		/*override protected function enterFrameHandler(event:Event):void
		{
			super.enterFrameHandler(event);
//			trace(scene.renderingList.numDrawCalls);
//			trace("==");
		}*/
		
		private function pickingBoxMovedHandler(picking		: PickingBoxController,
												matrix		: Matrix4x4) : void
		{
			_selected.transform.copyFrom(matrix);
		}
	}
}