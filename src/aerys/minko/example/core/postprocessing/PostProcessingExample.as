package aerys.minko.example.core.postprocessing
{
	import aerys.minko.render.effect.Effect;
	import aerys.minko.scene.node.mesh.Mesh;
	import aerys.minko.scene.node.mesh.geometry.primitive.CubeGeometry;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public class PostProcessingExample extends MinkoExampleApplication
	{
		override protected function initializeScene() : void
		{
			super.initializeScene();
			
			scene.addChild(new Mesh(
				CubeGeometry.cubeGeometry,
				{
					diffuseColor	: 0xff00ffff
				}
			));
			
			scene.postProcessingEffect = new Effect(new NoisePostProcessingShader());
		}
	}
}