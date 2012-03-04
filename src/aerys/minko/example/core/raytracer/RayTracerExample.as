package aerys.minko.example.core.raytracer
{
	import aerys.minko.render.effect.Effect;
	import aerys.minko.scene.node.mesh.Mesh;
	import aerys.minko.scene.node.mesh.geometry.primitive.QuadGeometry;

	[SWF(width="600",height="600")]
	public class RayTracerExample extends MinkoExampleApplication
	{
		override protected function initializeScene():void
		{
			super.initializeScene();
			
			scene.addChild(
				new Mesh(
					QuadGeometry.quadGeometry,
					null,
					new Effect(new RayTracerShader())
				)
			);
		}
	}
}