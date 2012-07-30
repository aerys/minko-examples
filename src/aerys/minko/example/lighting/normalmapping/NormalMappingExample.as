package aerys.minko.example.lighting.normalmapping
{
	import aerys.minko.Minko;
	import aerys.minko.render.effect.basic.BasicProperties;
	import aerys.minko.render.effect.lighting.LightingEffect;
	import aerys.minko.render.effect.lighting.LightingProperties;
	import aerys.minko.scene.controller.camera.ArcBallController;
	import aerys.minko.scene.node.light.DirectionalLight;
	import aerys.minko.scene.node.mesh.Mesh;
	import aerys.minko.scene.node.mesh.geometry.Geometry;
	import aerys.minko.scene.node.mesh.geometry.primitive.CubeGeometry;
	import aerys.minko.scene.node.mesh.geometry.primitive.QuadGeometry;
	import aerys.minko.scene.node.mesh.geometry.primitive.SphereGeometry;
	import aerys.minko.type.data.DataProvider;
	import aerys.minko.type.enum.NormalMappingType;
	import aerys.minko.type.loader.TextureLoader;
	import aerys.minko.type.log.DebugLevel;
	import aerys.monitor.Monitor;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	
	/**
	 * Common, normal, and parallax mapping comparison
	 * 
	 * @author Romain Gilliotte
	 */	
	public class NormalMappingExample extends MinkoExampleApplication
	{
		[Embed(source="../assets/parallaxmapping/collage.jpg")]
		private static const DIFFUSE_MAP	: Class;
		
		[Embed(source="../assets/parallaxmapping/collage-normal.jpg")]
		private static const NORMAL_MAP		: Class;
		
		[Embed(source="../assets/parallaxmapping/collage-bump.jpg")]
		private static const HEIGHT_MAP		: Class;
		
		private var _light : DirectionalLight = new DirectionalLight(0xffffffff, 1, 1.0, 128);
		
		override protected function initializeUI() : void
		{
			super.initializeUI();
			
			var textField : TextField = new TextField();
			textField.textColor	= 0xffffff;
			textField.x			= 200;
			textField.width		= 500;
			textField.text		= "Camera Control:\n" +
				"- Press 1 to center on common rendering\n" +
				"- Press 2 to center on normal mapped rendering\n" +
				"- Press 3 to center on parallax mapped rendering";
			
			addChild(textField);
			
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
		}
		
		override protected function initializeScene() : void
		{
			super.initializeScene();
			
			ArcBallController(camera.getControllersByType(ArcBallController)[0]).distanceStep = 0.1;
			
			var lightingEffect	: LightingEffect	= new LightingEffect(scene);
			var geometry		: Geometry			= new SphereGeometry(30);
			
			for (var quadId : uint = 0; quadId < 3; ++quadId)
			{
				var quad			: Mesh					= new Mesh(geometry, null, lightingEffect);
				var quadProperties	: DataProvider			= quad.properties;
				
				quadProperties[BasicProperties.DIFFUSE_MAP]	= TextureLoader.loadClass(DIFFUSE_MAP);
				quad.transform.setTranslation(1.1 * quadId  - 1.1, 0, 0).setRotation(Math.PI, 0, 0);
				
				switch (quadId)
				{
					case 0:
						quadProperties[LightingProperties.NORMAL_MAPPING_TYPE]			= NormalMappingType.NONE;
						break;
					
					case 1:
						quadProperties[LightingProperties.NORMAL_MAPPING_TYPE]			= NormalMappingType.NORMAL;
						quadProperties[LightingProperties.NORMAL_MAP]					= TextureLoader.loadClass(NORMAL_MAP);
						break;
					
					case 2:
						quadProperties[LightingProperties.NORMAL_MAPPING_TYPE]			= NormalMappingType.PARALLAX;
						quadProperties[LightingProperties.NORMAL_MAP]					= TextureLoader.loadClass(NORMAL_MAP);
						quadProperties[LightingProperties.HEIGHT_MAP]					= TextureLoader.loadClass(HEIGHT_MAP);
						quadProperties[LightingProperties.PARALLAX_MAPPING_NBSTEPS]		= 30;		// optional, defaults to 20
						quadProperties[LightingProperties.PARALLAX_MAPPING_BUMP_SCALE]	= 0.03;		// optional, defaults to 0.03
						break;
				}
				
				scene.addChild(quad);
			}
			
			scene.addChild(_light)
		}
		
		private function keyUpHandler(e : KeyboardEvent) : void
		{
			var camController : ArcBallController = ArcBallController(camera.getControllersByType(ArcBallController)[0]);
			
			switch (e.keyCode)
			{
				case Keyboard.NUMBER_1:
					camController.lookAt.set(-1.1, 0, 0);
					break;
				
				case Keyboard.NUMBER_2:
					camController.lookAt.set(0, 0, 0);
					break;
				
				case Keyboard.NUMBER_3:
					camController.lookAt.set(1.1, 0, 0);
					break;
			}
		}
		
		override protected function enterFrameHandler(e : Event) : void
		{
			super.enterFrameHandler(e);
			
			_light.transform.copyFrom(camera.transform);
		}
	}
}