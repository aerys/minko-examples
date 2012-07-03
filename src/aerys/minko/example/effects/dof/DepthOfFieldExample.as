package aerys.minko.example.effects.dof
{
	import aerys.minko.example.core.terrain.TerrainExample;
	import aerys.minko.render.effect.dof.DepthOfFieldEffect;
	import aerys.minko.render.effect.dof.DepthOfFieldQuality;
	import aerys.minko.scene.node.mesh.Mesh;
	
	public class DepthOfFieldExample extends TerrainExample
	{
		override protected function initializeScene():void
		{
			super.initializeScene();
			
			var dof : DepthOfFieldEffect = new DepthOfFieldEffect(DepthOfFieldQuality.VERY_LOW, 4);

			camera.zFar = 200;
			cameraController.maxDistance = 200;
			
			scene.postProcessingEffect = dof;
			for each (var m : Mesh in scene.get('//mesh'))
				m.effect.addPass(dof.depthPass);
		}
	}
}