package aerys.minko.example.core.databindings
{
	import flash.display.BitmapData;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import aerys.minko.render.geometry.primitive.CubeGeometry;
	import aerys.minko.render.material.environment.EnvironmentMappingProperties;
	import aerys.minko.render.material.realistic.RealisticMaterial;
	import aerys.minko.render.resource.texture.TextureResource;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.scene.node.light.AmbientLight;
	import aerys.minko.scene.node.light.DirectionalLight;
	import aerys.minko.type.binding.DataProvider;

	public class DataBindingsExample extends AbstractExampleApplication
	{
		
		private var materials : Array = [
			new RealisticMaterial({diffuseColor : 0xFF0000FF}),
			new RealisticMaterial({diffuseColor : 0x00FF00FF}),
			new RealisticMaterial({diffuseColor : 0x0000FFFF}),
			new RealisticMaterial({diffuseColor : 0x000000FF}),
			new RealisticMaterial({diffuseColor : 0xFFFFFFFF})];
		
		override protected function initializeScene():void
		{
			super.initializeScene();
			
			scene.addController(new MeshAddedController());
			
			for (var i : uint = 0; i < 100; i++)
			{
				var mesh : Mesh = new Mesh(CubeGeometry.cubeGeometry, materials[uint(Math.random() * 5)]);
				
				mesh.transform.appendTranslation((Math.random() * 20) - 10, (Math.random() * 20) - 10, (Math.random() * 20) - 10);
				
				scene.addChild(mesh);
			}
			
			scene.addChild(new AmbientLight());
			scene.addChild(new DirectionalLight());
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyboardHandler);
		}
		
		private function keyboardHandler(event : KeyboardEvent) : void
		{
			if (event.keyCode != Keyboard.SPACE)
				return;
			
			var bitmapData 	: BitmapData 		= new BitmapData(256, 256, true, 0xFFFFFFFF);
			bitmapData.perlinNoise(Math.random() * 4, Math.random() * 4, Math.random() * 8, Math.random() * 5, true, true);
			
			var dataProvider : DataProvider = Mesh(scene.get("//Mesh")[0]).bindings.getProviderByBindingName(EnvironmentMappingProperties.ENVIRONMENT_MAP) as DataProvider;
			
			TextureResource(dataProvider.getProperty(EnvironmentMappingProperties.ENVIRONMENT_MAP)).setContentFromBitmapData(bitmapData, true);
		}
	}
}