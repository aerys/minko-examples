package aerys.minko.example.core.keyboardscript
{
	import aerys.minko.scene.controller.ScriptController;
	import aerys.minko.scene.node.ISceneNode;
	
	import flash.ui.Keyboard;
	
	/**
	 * This script makes it possible to use the keyboard arrows to move objects.
	 * 
	 * <ul>
	 * <li>right/left: move on the X axis</li>
	 * <li>up/down: move on the Y axis</li>
	 * <li>pzge up/page down: move on the Z axis</li>
	 * </ul>
	 * 
	 * @author Jean-Marc Le Roux
	 * 
	 */
	public class KeyboardMoveScript extends ScriptController
	{
		override protected function update(target : ISceneNode) : void
		{
			if (keyboard.keyIsDown(Keyboard.RIGHT))
				target.transform.appendTranslation(0.1);
			if (keyboard.keyIsDown(Keyboard.LEFT))
				target.transform.appendTranslation(-0.1);
			if (keyboard.keyIsDown(Keyboard.UP))
				target.transform.appendTranslation(0, 0.1);
			if (keyboard.keyIsDown(Keyboard.DOWN))
				target.transform.appendTranslation(0, -0.1);
			if (keyboard.keyIsDown(Keyboard.PAGE_UP))
				target.transform.appendTranslation(0, 0, 0.1);
			if (keyboard.keyIsDown(Keyboard.PAGE_DOWN))
				target.transform.appendTranslation(0, 0, -0.1);
		}
	}
}