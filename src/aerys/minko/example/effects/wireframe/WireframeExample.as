package aerys.minko.example.effects.wireframe
{
	import aerys.minko.Minko;
	import aerys.minko.render.effect.wireframe.WireframeMaterial;
	import aerys.minko.render.geometry.primitive.TeapotGeometry;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.scene.node.mesh.geometry.WireframeGeometry;
	import aerys.minko.type.log.DebugLevel;

	public class WireframeExample extends MinkoExampleApplication
	{
		override protected function initializeScene() : void
		{
			super.initializeScene();
			
			cameraController.lookAt.set(0, 1.5, 0);
			cameraController.distance = 10;
			
			var material : WireframeMaterial = new WireframeMaterial();
			
			material.diffuseColor = 0;
			material.wireframeColor = 0xffffff77;
			material.wireframeThickness = 10.;
			
			scene.addChild(new Mesh(
				new WireframeGeometry(new TeapotGeometry(10)),
				material
			));
		}
	}
}