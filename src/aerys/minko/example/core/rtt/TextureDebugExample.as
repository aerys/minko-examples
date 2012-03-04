package aerys.minko.example.core.rtt
{
	import aerys.minko.render.effect.basic.BasicStyle;
	import aerys.minko.render.target.TextureRenderTarget;
	import aerys.minko.scene.node.debug.TextureDebugDisplay;
	import aerys.minko.scene.node.group.EffectGroup;
	import aerys.minko.scene.node.group.Group;
	import aerys.minko.scene.node.mesh.geometry.primitive.CubeGeometry;
	import aerys.minko.scene.node.texture.ColorTexture;
	import aerys.minko.scene.node.texture.RenderTargetTexture;
	import aerys.minko.scene.node.texture.Texture;

	public class TextureDebugExample extends MinkoExampleApplication
	{
		override protected function initializeScene() : void
		{
			var rttTexture : RenderTargetTexture = new RenderTargetTexture(
				new TextureRenderTarget(512, 512, 0xff0000)
			);
		
			var cube : Group = new EffectGroup(
				new SimpleRTTEffect(rttTexture.renderTarget),
				new ColorTexture(0x0000ff),
				CubeGeometry.cubeMesh
			);
			
			scene.addChild(cube)
				 .addChild(new TextureDebugDisplay(rttTexture));
		}
	}
}