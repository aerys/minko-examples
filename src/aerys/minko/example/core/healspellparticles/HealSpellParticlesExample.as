package aerys.minko.example.core.healspellparticles
{
	import aerys.minko.render.geometry.primitive.CubeGeometry;
	import aerys.minko.render.material.basic.BasicMaterial;
	import aerys.minko.scene.node.Mesh;

	public class HealSpellParticlesExample extends AbstractExampleApplication
	{
		
		public function HealSpellParticlesExample()
		{
			super();
		}
		
		override protected function initializeScene() : void
		{
			super.initializeScene();
			
			cameraController.distance = 150;
			cameraController.lookAt.set(0, 0, 0);
			
			var mesh : Mesh = new Mesh(CubeGeometry.cubeGeometry, new BasicMaterial());
			
			mesh.addController(new HealSpellParticleController());
			
			scene.addChild(mesh);
		}
	}
}