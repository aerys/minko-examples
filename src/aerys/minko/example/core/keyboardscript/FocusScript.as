package aerys.minko.example.core.keyboardscript
{
	import aerys.minko.scene.controller.AbstractController;
	import aerys.minko.scene.controller.AbstractScriptController;
	import aerys.minko.scene.node.ISceneNode;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.scene.node.Scene;
	import aerys.minko.type.Signal;
	import aerys.minko.type.math.Ray;
	
	/**
	 * This script will add a list of scripts to its targets Mesh descendants
	 * when they are clicked.
	 * 
	 * @author Jean-Marc Le Roux
	 * 
	 */
	public class FocusScript extends AbstractScriptController
	{
		private var _focused	: Mesh;
		private var _scripts	: Vector.<AbstractController>;
		
		private var _focusIn	: Signal;
		private var _focusOut	: Signal;
		
		public function get focused() : Mesh
		{
			return _focused;
		}
		
		public function get focusIn() : Signal
		{
			return _focusIn;
		}
		
		public function get focusOut() : Signal
		{
			return _focusOut;
		}
		
		public function FocusScript(...controllers)
		{
			super();
			
			_scripts = Vector.<AbstractController>(controllers);
			_focusIn = new Signal('FocusScript.focusIn');
			_focusOut = new Signal('FocusScript.focusOut');
		}
		
		override protected function update(target : ISceneNode) : void
		{
			if (mouse.leftButtonDown)
			{
				var scene 		: Scene 				= target.root as Scene;
				var ray 		: Ray 					= scene.activeCamera.unproject(mouse.x, mouse.y);
				var castedNodes	: Vector.<ISceneNode> 	= scene.cast(ray);
				var focused 	: Mesh 					= castedNodes.length > 0 ? castedNodes[0] as Mesh : null;
				var c 			: AbstractController	= null;
				
				if (_focused)
				{
					for each (c in _scripts)
						_focused.removeController(c);
					_focusOut.execute(this, _focused);
				}
				
				_focused = focused;
				
				if (_focused)
				{
					for each (c in _scripts)
						_focused.addController(c);
					_focusIn.execute(this, _focused);
				}
			}
		}
	}
}