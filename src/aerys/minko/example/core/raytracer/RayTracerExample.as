package aerys.minko.example.core.raytracer
{
	import aerys.minko.Minko;
	import aerys.minko.render.effect.SinglePassRenderingEffect;
	import aerys.minko.scene.node.group.EffectGroup;
	import aerys.minko.scene.node.mesh.primitive.QuadMesh;
	import aerys.minko.type.log.DebugLevel;

	public class RayTracerExample extends MinkoExampleApplication
	{
		override protected function initializeScene():void
		{
			super.initializeScene();
			
			Minko.debugLevel = DebugLevel.SHADER_AGAL;
			
			scene.addChild(new EffectGroup(
				new SinglePassRenderingEffect(new RayTracerShader()),
				new QuadMesh()
			));
		}
	}
}