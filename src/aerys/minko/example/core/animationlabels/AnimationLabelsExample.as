package aerys.minko.example.core.animationlabels
{
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	
	import aerys.minko.render.geometry.stream.StreamUsage;
	import aerys.minko.scene.controller.animation.MasterAnimationController;
	import aerys.minko.scene.node.Group;
	import aerys.minko.scene.node.ISceneNode;
	import aerys.minko.type.animation.SkinningMethod;
	import aerys.minko.type.loader.ILoader;
	import aerys.minko.type.loader.SceneLoader;
	import aerys.minko.type.loader.TextureLoader;
	import aerys.minko.type.loader.parser.ParserOptions;
	import aerys.minko.type.parser.collada.ColladaParser;
	
	public class AnimationLabelsExample extends AbstractExampleApplication
	{
		[Embed(source="../assets/pirate/pirate.dae", mimeType="application/octet-stream")]
		private static const DAE : Class;
		
		[Embed(source="../assets/pirate/pirate_diffuse.jpg")]
		private static const TEXTURE : Class;
		
		private var _animations	: MasterAnimationController;
		private var _state		: String;
		private var _log		: TextField;
		
		override protected function initializeUI() : void
		{
			super.initializeUI();
			_log = new TextField();
			_log.mouseEnabled = false;
			_log.textColor = 0xffffffff;
			_log.y = 150;
			_log.height = 600;
			_log.width = 200;
			_log.selectable = false;
			stage.addChild(_log);
		}
		
		override protected function initializeScene() : void
		{
			super.initializeScene();
			
			cameraController.distance = 250;
			cameraController.yaw = 1.;
			cameraController.distanceStep = 0.02;
			cameraController.lookAt.set(0, 75, 0);
			
			var options : ParserOptions		= new ParserOptions();
			
			options.parser						= ColladaParser;
			options.mipmapTextures				= true;
			options.dependencyLoaderFunction	= loadDependency;
			options.vertexStreamUsage			= StreamUsage.DYNAMIC;
			options.skinningMethod				= SkinningMethod.HARDWARE_MATRIX;
			
			scene.loadClass(DAE, options).complete.add(modelLoadedHandler);
		}
		
		private function modelLoadedHandler(loader : SceneLoader, group : Group) : void
		{				
			var nodes		: Vector.<ISceneNode> = group.get('//*[hasController(MasterAnimationController)]');
			
			_animations = nodes[0].getControllersByType(MasterAnimationController)[0] as MasterAnimationController;
			
			initAnimations();				
		}
		
		private function initAnimations() : void
		{
			_animations.addLabel('run_start', 0).addLabel('run_stop', 800);
			_animations.addLabel('idle', 900);
			_animations.addLabel('walk_start', 1400).addLabel('walk_stop', 2300);
			_animations.addLabel('punch_start', 2333).addLabel('punch_hit', 2600).addLabel('punch_stop', 3000);
			_animations.addLabel('kick_start', 3033).addLabel('kick_hit', 3316).addLabel('kick_stop', 3600);
			_animations.addLabel('stun_start', 3633).addLabel('stun_stop', 5033);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			
			_animations.labelHit.add(labelHitHandler);
						
			idle();
		}
		
		public function keyDownHandler(event : KeyboardEvent) : void
		{
			if (event.keyCode == Keyboard.UP)
				run();
			else if (event.keyCode == Keyboard.DOWN)
				walk();
			else if(event.keyCode == Keyboard.SPACE)
				kick();
			else if(event.keyCode == Keyboard.SHIFT)
				punch();
		}
		
		public function keyUpHandler(event : KeyboardEvent) : void
		{
			if (event.keyCode == Keyboard.UP)
				idle();
			else if (event.keyCode == Keyboard.DOWN)
				idle();
		}
		
		private function labelHitHandler(animationController	: MasterAnimationController, 
										 labelName				: String, 
										 labelTime				: int) : void
		{
			trace(labelName);
			if (labelName == 'punch_hit')
				_log.text = "PUNCH\n" + _log.text;
			else if (labelName == 'kick_hit')
				_log.text = "KICK\n" + _log.text;
			else if (labelName == 'kick_stop' || labelName == 'punch_stop')
				idle();
		}
		
		private function run() : void
		{
			if (_state == "run")
				return;
			_state = "run";
			
			_animations.looping = true;
			_animations.setPlaybackWindow("run_start", "run_stop").play();
		}
		
		private function walk() : void
		{
			if (_state == "walk")
				return;
			_state = "walk";
			
			_animations.looping = true;
			_animations.setPlaybackWindow("walk_start", "walk_stop").play();
		}
		
		private function kick() : void
		{
			if (_state == "kick")
				return;
			_state = "kick";
			
			_animations.looping = false;
			_animations.setPlaybackWindow("kick_start", "kick_stop").play();
		}
		
		private function punch() : void
		{
			if (_state == "punch")
				return;
			_state = "punch";
			
			_animations.looping = false;
			_animations.setPlaybackWindow("punch_start", "punch_stop").play();
		}
		
		private function idle() : void
		{
			if (_state == "idle")
				return;
			_state = "idle";
			
			_animations.looping = false;
			_animations.resetPlaybackWindow().seek("idle").stop();
		}
		
		private function loadDependency(dependencyId 	: String,
										dependencyPath	: String,
										isTexture		: Boolean,
										options			: ParserOptions) : ILoader
		{
			var loader : ILoader = new TextureLoader(options.mipmapTextures)
			
			loader.loadClass(TEXTURE);
			
			return loader;
		}
	}
}
