package aerys.minko.example.core.rtt
{
	import aerys.minko.Minko;
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.effect.Effect;
	import aerys.minko.render.effect.basic.BasicShader;
	import aerys.minko.render.effect.vertex.VertexNormalShader;
	import aerys.minko.render.effect.vertex.VertexPositionShader;
	import aerys.minko.render.resource.texture.TextureResource;
	import aerys.minko.scene.node.Sprite;
	import aerys.minko.scene.node.mesh.Mesh;
	import aerys.minko.scene.node.mesh.geometry.primitive.TeapotGeometry;
	import aerys.minko.type.log.DebugLevel;
	import aerys.minko.type.math.Vector4;

	public class RenderToTextureExample extends MinkoExampleApplication
	{
		override protected function initializeScene() : void
		{
			Minko.debugLevel = DebugLevel.CONTEXT;
			
			// setup lighting
			scene.bindings.setProperties({
				lightDirection		: new Vector4(.1, .1, 1.),
				lightDiffuseColor	: 0xffffff,
				lightDiffuse		: 1.,
				lightEnabled		: true
			});

			// create render targets
			var normalsTexture : RenderTarget = new RenderTarget(
				512, 512,
				new TextureResource(512, 512),
				0,
				0x000000ff
			);
			var positionsTexture : RenderTarget = new RenderTarget(
				512, 512,
				new TextureResource(512, 512),
				0,
				0x000000ff
			);
			
			var basicShader : BasicShader = new BasicShader();
			
			// create the teapot
			var teapot : Mesh = new Mesh(
				new TeapotGeometry(),
				{
					diffuseColor	: 0xffffff00,
					lightEnabled	: true
				},
				new Effect(
					// RTT passes
					new VertexNormalShader(normalsTexture, 1),
					new VertexPositionShader(positionsTexture, 1),
					// rendering pass
					basicShader
				)
			);
			
			teapot.transform
				.appendUniformScale(.5)
				.appendTranslation(0, -0.6);
			
			scene.addChild(teapot);
			
			// create the sprites to see the result of the RTT
			scene.addChild(new Sprite(
				10, 10,
				128, 128,
				{ diffuseMap : normalsTexture.resource }
			));
			
			scene.addChild(new Sprite(
				10, 148,
				128, 128,
				{ diffuseMap : positionsTexture.resource }
			));
		}
	}
}