package aerys.minko.example.core.keyboardscript
{
	import aerys.minko.example.core.primitives.PrimitivesExample;
	
	public class KeyboardScriptExample extends PrimitivesExample
	{
		override protected function initializeScene() : void
		{
			super.initializeScene();
	
			scene.addController(new FocusScript(new KeyboardMoveScript()));
		}
	}
}