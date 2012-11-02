package aerys.minko.example.effects.wireframe
{
	import aerys.minko.render.effect.wireframe.WireframeMaterial;
	import aerys.minko.render.geometry.primitive.TeapotGeometry;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.scene.node.mesh.geometry.WireframeGeometry;
	import aerys.minko.type.enum.Blending;
	import aerys.minko.type.enum.TriangleCulling;

	public class WireframeExample extends AbstractExampleApplication
	{
		override protected function initializeScene() : void
		{
			super.initializeScene();
			
			cameraController.lookAt.set(0, 1.5, 0);
			cameraController.distance = 10;
			
			var material : WireframeMaterial = new WireframeMaterial();
			
			material.diffuseColor = 0;
			material.blending = Blending.ADDITIVE;
			material.triangleCulling = TriangleCulling.NONE;
			material.wireframeColor = 0xffffff77;
			material.wireframeThickness = 20.;
			
			scene.addChild(new Mesh(
				new WireframeGeometry(new TeapotGeometry(10)),
				material
			));
		}
	}
}