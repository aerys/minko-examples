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
			super.initializeScene();
			
			cameraController.yaw = Math.PI * -.5;
			
			// setup lighting
			scene.properties.setProperties({
				lightDirection		: new Vector4(.1, .1, 1.),
				lightDiffuseColor	: 0xffffff,
				lightDiffuse		: 1.,
				lightEnabled		: true
			});

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
				{
					diffuseColor	: 0xffffff00,
					lightEnabled	: true
				},
				new Effect(
					// RTT passes
					new VertexNormalShader(normalsTarget, 1),
					new VertexPositionShader(positionsTarget, 1),
					// rendering pass
					basicShader
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