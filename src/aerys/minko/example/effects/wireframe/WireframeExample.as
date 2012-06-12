package aerys.minko.example.effects.wireframe
{
	import aerys.minko.render.effect.Effect;
	import aerys.minko.render.effect.wireframe.WireframeShader;
	import aerys.minko.scene.node.mesh.Mesh;
	import aerys.minko.scene.node.mesh.geometry.WireframeGeometry;
	import aerys.minko.scene.node.mesh.geometry.primitive.ConeGeometry;
	import aerys.minko.scene.node.mesh.geometry.primitive.TeapotGeometry;
	import aerys.minko.type.stream.StreamUsage;

	public class WireframeExample extends MinkoExampleApplication
	{
		override protected function initializeScene() : void
		{
			super.initializeScene();
		
			cameraController.lookAt.set(0, 1.5, 0);
			cameraController.distance = 10;
			
			scene.addChild(new Mesh(
				new WireframeGeometry(new TeapotGeometry(10, StreamUsage.READ)),
				{
					wireframeWireColor		: 0xffffff77,
					wireframeWireThickness	: 10
				},
				new Effect(new WireframeShader())
			));
		}
	}
}