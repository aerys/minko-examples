package aerys.minko.example.core.picking
{
	import aerys.minko.Minko;
	import aerys.minko.example.core.primitives.PrimitivesExample;
	import aerys.minko.render.geometry.primitive.CubeGeometry;
	import aerys.minko.render.material.basic.BasicMaterial;
	import aerys.minko.scene.controller.PickingController;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.type.enum.PickingTechnique;
	
	import flash.text.TextField;

	public class PickingExample extends PrimitivesExample
	{
		private var _log	: TextField;
		
		override protected function initializeUI() : void
		{
			_log = new TextField();
			_log.mouseEnabled = false;
			_log.textColor = 0xffffffff;
			_log.height = 600;
			_log.width = 200;
			_log.selectable = false;
			stage.addChild(_log);
		}
		
		override protected function initializeScene() : void
		{
			super.initializeScene();
			
			var picking : PickingController = new PickingController(
                PickingTechnique.RAYCASTING_BOX | PickingTechnique.PIXEL_PICKING
            );
			
			viewport.doubleClickEnabled = true;
			picking.bindDefaultInputs(viewport);
			picking.useHandCursor = true;
			picking.mouseClick.add(
				function(ctrl : PickingController, mesh : Mesh, mouseX : Number, mouseY : Number) : void
				{
					_log.text = 'click: ' + (mesh ? mesh.name : null) + '\n' + _log.text;
				}
			);
			picking.mouseRightClick.add(
				function(ctrl : PickingController, mesh : Mesh, mouseX : Number, mouseY : Number) : void
				{
					_log.text = 'right click: ' + (mesh ? mesh.name : null) + '\n' + _log.text;
				}
			);
			picking.mouseDoubleClick.add(
				function(ctrl : PickingController, mesh : Mesh, mouseX : Number, mouseY : Number) : void
				{
					_log.text = 'double click: ' + (mesh ? mesh.name : null) + '\n' + _log.text;
				}
			);
			picking.mouseRollOut.add(
				function(ctrl : PickingController, mesh : Mesh, mouseX : Number, mouseY : Number) : void
				{
					_log.text = 'roll out: ' + (mesh ? mesh.name : null) + '\n' + _log.text;
				}
			);
			picking.mouseRollOver.add(
				function(ctrl : PickingController, mesh : Mesh, mouseX : Number, mouseY : Number) : void
				{
					_log.text = 'roll over: ' + (mesh ? mesh.name : null) + '\n' + _log.text;
				}
			);
			picking.mouseMove.add(
				function(ctrl : PickingController, mesh : Mesh, mouseX : Number, mouseY : Number) : void
				{
					_log.text = 'move: ' + (mesh ? mesh.name : null) + '\n' + _log.text;
				}
			);
			
			scene.addController(picking);
		}
	}
}