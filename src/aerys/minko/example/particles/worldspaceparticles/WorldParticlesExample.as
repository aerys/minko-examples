package aerys.minko.example.particles.worldspaceparticles
{
	import flash.events.Event;
	
	import aerys.minko.render.geometry.primitive.CubeGeometry;
	import aerys.minko.render.material.basic.BasicMaterial;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.type.math.Ray;
	import aerys.minko.type.math.Vector4;

	public class WorldParticlesExample extends AbstractExampleApplication
	{
		private var _mesh : Mesh = null;
		
		public function WorldParticlesExample()
		{
			super();
		}
		
		override protected function initializeScene() : void
		{
			super.initializeScene();
			
			stage.addEventListener(Event.ENTER_FRAME, update);
			
			cameraController.distance = 150;
			cameraController.lookAt.set(0, 0, 0);
			
			var mesh : Mesh = new Mesh(CubeGeometry.cubeGeometry, new BasicMaterial());
									
			mesh.addController(new WorldParticleController());
			
			scene.addChild(mesh);
			
			_mesh = mesh;
		}
		
		
		private function update(event : Event) : void
		{
			var ray : Ray = camera.unproject(viewport.mouseX, viewport.mouseY);
			
			var newMeshPosition : Vector4 = ray.origin.clone();
			
			for(var i : int = 0; i < 50; ++i)
				newMeshPosition = Vector4.add(newMeshPosition, ray.direction);
			
			_mesh.transform.setTranslation(
				newMeshPosition.x,
				newMeshPosition.y,
				newMeshPosition.z
			);
		}
	}
}