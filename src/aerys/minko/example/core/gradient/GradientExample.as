package aerys.minko.example.core.gradient
{
	import aerys.minko.render.effect.SinglePassRenderingEffect;
	import aerys.minko.scene.node.group.EffectGroup;
	import aerys.minko.scene.node.mesh.primitive.CubeMesh;

	public class GradientExample extends MinkoExampleApplication
	{
		override protected function initializeScene():void
		{
			scene.addChild(
				new EffectGroup(
					new SinglePassRenderingEffect(new GradientShader(0xff0000, 0x0000ff)),
					CubeMesh.cubeMesh
				)
			);
		}
	}
}