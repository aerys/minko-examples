package aerys.minko.example.core.masteranimationcontroller
{
	import com.bit101.utils.MinimalConfigurator;
	
	import flash.events.MouseEvent;
	
	import aerys.minko.example.collada.pirate.PirateExample;
	import aerys.minko.scene.controller.animation.MasterAnimationController;
	import aerys.minko.scene.node.ISceneNode;
	
	public class MasterAnimationControllerExample extends PirateExample
	{
		
		override protected function initializeUI() : void
		{
			var cfg : MinimalConfigurator = new MinimalConfigurator(this);
			
			cfg.parseXML(
				<comps>
					<PushButton label="Play" x="10" y="10"
								event="click:playButtonClickHandler"/>
					<PushButton label="Stop" x="10" y="30"
								event="click:stopButtonClickHandler"/>
				</comps>
			);
		}
		
		public function playButtonClickHandler(event : MouseEvent) : void
		{
			var animatedNodes : Vector.<ISceneNode> = scene.get("//*[hasController(MasterAnimationController)]");
			
			for each (var animatedNode : ISceneNode in animatedNodes)
			{
				var masterAnimationController : MasterAnimationController = animatedNode.getControllersByType(MasterAnimationController)[0] as MasterAnimationController;
				
				masterAnimationController.play();
			}
		}
		
		public function stopButtonClickHandler(event : MouseEvent) : void
		{
			var animatedNodes : Vector.<ISceneNode> = scene.get("//*[hasController(MasterAnimationController)]");
			
			for each (var animatedNode : ISceneNode in animatedNodes)
			{
				var masterAnimationController : MasterAnimationController = animatedNode.getControllersByType(MasterAnimationController)[0] as MasterAnimationController;
				
				masterAnimationController.stop();
			}
		}
	}
}