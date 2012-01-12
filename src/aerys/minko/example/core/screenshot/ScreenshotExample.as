package aerys.minko.example.core.screenshot
{
	import aerys.minko.example.core.light.DirectionalLightExample;
	
	import flash.display.BitmapData;
	import flash.events.KeyboardEvent;
	import flash.net.FileReference;
	import flash.ui.Keyboard;

	public class ScreenshotExample extends DirectionalLightExample
	{
		override protected function keyDownHandler(event : KeyboardEvent) : void
		{
			if (event.keyCode == Keyboard.SPACE)
			{
				var bitmapData : BitmapData = new BitmapData(viewport.width, viewport.height);
				var encoder : JPEGEncoder = new JPEGEncoder(80);
				
				viewport.render(scene, bitmapData);
				
				new FileReference().save(encoder.encode(bitmapData), "screenshot.jpg");
			}
		}
	}
}