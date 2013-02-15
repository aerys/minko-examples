package aerys.minko.example.core.rtt
{
	import aerys.minko.render.Effect;
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.geometry.primitive.TeapotGeometry;
	import aerys.minko.render.material.Material;
	import aerys.minko.render.material.basic.BasicShader;
	import aerys.minko.render.shader.vertex.VertexNormalShader;
	import aerys.minko.render.shader.vertex.VertexPositionShader;
	import aerys.minko.render.resource.texture.TextureResource;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.scene.node.Sprite;

	public class RenderToTextureExample extends AbstractExampleApplication
	{
		override protected function initializeScene() : void
		{
			super.initializeScene();
			
			cameraController.distance = 10;
			cameraController.yaw = Math.PI * -.5;
			
			// create render targets
			var normalsTarget : RenderTarget = new RenderTarget(
				512, 512,
				new TextureResource(512, 512),
				0,
				0x000000ff
			);
			var positionsTarget : RenderTarget = new RenderTarget(
				512, 512,
				new TextureResource(512, 512),
				0,
				0x000000ff
			);
			
			var basicShader : BasicShader = new BasicShader();
			
			// create the teapot
			var teapot : Mesh = new Mesh(
				new TeapotGeometry(),
				new Material(
					new Effect(
						// RTT passes
						new VertexNormalShader(normalsTarget, 1),
						new VertexPositionShader(positionsTarget, 1),
						// rendering pass
						new BasicShader()
					),
					{
						diffuseColor	: 0xffffff00,
						lightEnabled	: true
					}
				)
			);
			
			teapot.transform.appendTranslation(0, -1.5);
			
			scene.addChild(teapot);
			
			// create the sprites to see the result of the RTT
			scene.addChild(new Sprite(
				10, 10,
				128, 128,
				{ diffuseMap : normalsTarget.textureResource }
			));
			
			scene.addChild(new Sprite(
				10, 148,
				128, 128,
				{ diffuseMap : positionsTarget.textureResource }
			));
		}
	}
}