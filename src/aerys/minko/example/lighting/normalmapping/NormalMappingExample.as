package aerys.minko.example.lighting.normalmapping
{
	import aerys.minko.render.geometry.Geometry;
	import aerys.minko.render.geometry.primitive.SphereGeometry;
	import aerys.minko.render.material.phong.PhongMaterial;
	import aerys.minko.scene.controller.camera.ArcBallController;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.scene.node.light.AbstractLight;
	import aerys.minko.scene.node.light.DirectionalLight;
	import aerys.minko.type.enum.NormalMappingType;
	import aerys.minko.type.loader.TextureLoader;
	
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
		
		private var _light : AbstractLight;
		
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
			
			_light = new DirectionalLight(0xffffffff, 1, 1.0, 128);
			scene.addChild(_light);
			
			var sphere		: Mesh				= null;
			var geometry	: Geometry			= new SphereGeometry(30);
			var phong		: PhongMaterial		= new PhongMaterial(scene);
			
			geometry.computeTangentSpace(false);
			
			phong.diffuseMap = TextureLoader.loadClass(DIFFUSE_MAP);
			sphere = new Mesh(geometry, phong);
			sphere.transform.setTranslation(-1.1, 0, 0);
			scene.addChild(sphere);
			
			var normalMapping	: PhongMaterial	= phong.clone() as PhongMaterial;
			
			normalMapping.normalMappingType = NormalMappingType.NORMAL;
			normalMapping.normalMap = TextureLoader.loadClass(NORMAL_MAP);
			sphere = new Mesh(geometry, normalMapping);
			scene.addChild(sphere);
			
			var parallaxMapping : PhongMaterial	= normalMapping.clone() as PhongMaterial;
			
			parallaxMapping.normalMappingType = NormalMappingType.PARALLAX;
			parallaxMapping.heightMap = TextureLoader.loadClass(HEIGHT_MAP);
			parallaxMapping.numParallaxMappingSteps = 30;
			parallaxMapping.parallaxMappingBumpScale = 0.03;
			sphere = new Mesh(geometry, parallaxMapping);
			sphere.transform.setTranslation(1.1, 0, 0);
			scene.addChild(sphere);
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
			_light.transform.copyFrom(camera.transform);
			
			super.enterFrameHandler(e);
		}
	}
}