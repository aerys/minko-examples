package aerys.minko.example.particles.snowparticles
{
	import aerys.minko.example.particles.snowparticles.SnowParticleController;
	import aerys.minko.render.geometry.primitive.CubeGeometry;
	import aerys.minko.render.material.basic.BasicMaterial;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.type.math.Vector4;

	public class SnowParticlesExample extends AbstractExampleApplication
	{
		private static const SNOW_DENSITY	: Number = 0.3;
		
		public function SnowParticlesExample()
		{
			super();
		}
		
		override protected function initializeScene() : void
		{
			super.initializeScene();
			
			cameraController.distance = 150;
			cameraController.lookAt.set(0, 0, 0);
			
			var mesh : Mesh = new Mesh(CubeGeometry.cubeGeometry, new BasicMaterial());
			
			mesh.transform
				.appendTranslation(50, -100, -50)
				.appendRotation( Math.PI / 2, Vector4.Y_AXIS)
				.appendRotation(-Math.PI / 2, Vector4.Z_AXIS);
						
			mesh.addController(new SnowParticleController(SNOW_DENSITY));
			
			scene.addChild(mesh);
		}
	}
}