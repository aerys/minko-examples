package aerys.minko.example.effects.glow
{
	import aerys.minko.render.effect.glow.GlowEffect;
	import aerys.minko.render.geometry.primitive.TeapotGeometry;
	import aerys.minko.render.material.Material;
	import aerys.minko.scene.node.Mesh;
	
	public class GlowExample extends AbstractExampleApplication
	{
		override protected function initializeScene() : void
		{
			super.initializeScene();
			
			cameraController.distance = 100;
			cameraController.distanceStep = .0;
			cameraController.pitch -= .2;
			
			var color		: uint			= ((Math.random() * 0xffffff) << 8) | 0xff;
			var material	: Material		= new Material(
				new GlowEffect(),
				{ diffuseColor : color }
			);
			
			var teapot		: Mesh			= new Mesh(new TeapotGeometry(), material);
			teapot.transform.appendUniformScale(5).appendTranslation(0, -5, 0);
			scene.addChild(teapot);
		}
	}
}