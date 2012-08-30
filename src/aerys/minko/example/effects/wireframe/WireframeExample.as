package aerys.minko.example.effects.wireframe
{
	import aerys.minko.render.Effect;
	import aerys.minko.render.effect.wireframe.WireframeShader;
	import aerys.minko.render.geometry.primitive.TeapotGeometry;
	import aerys.minko.render.material.Material;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.scene.node.mesh.geometry.WireframeGeometry;

	public class WireframeExample extends MinkoExampleApplication
	{
		override protected function initializeScene() : void
		{
			super.initializeScene();
		
			cameraController.lookAt.set(0, 1.5, 0);
			cameraController.distance = 10;
			
			scene.addChild(new Mesh(
				new WireframeGeometry(new TeapotGeometry(10)),
				new Material(
					new Effect(new WireframeShader()),
					{
						wireframeWireColor		: 0xffffff77,
						wireframeWireThickness	: 10
					}
				)
			));
		}
	}
}