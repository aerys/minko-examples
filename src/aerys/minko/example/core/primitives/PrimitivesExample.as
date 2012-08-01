package aerys.minko.example.core.primitives
{
	import aerys.minko.render.geometry.primitive.CubeGeometry;
	import aerys.minko.render.geometry.primitive.QuadGeometry;
	import aerys.minko.render.geometry.primitive.SphereGeometry;
	import aerys.minko.render.geometry.primitive.TorusGeometry;
	import aerys.minko.render.material.basic.BasicMaterial;
	import aerys.minko.scene.node.Mesh;

	public class PrimitivesExample extends MinkoExampleApplication
	{
		override protected function initializeScene() : void
		{
			super.initializeScene();
			
			var torus : Mesh = new Mesh(
				new TorusGeometry(),
				new BasicMaterial({diffuseColor : 0xff0000ff})
			);
			torus.transform.appendTranslation(-2.25);
			scene.addChild(torus);
			
			var cube : Mesh = new Mesh(
				CubeGeometry.cubeGeometry,
				new BasicMaterial({diffuseColor : 0x00ff00ff})
			)
			cube.transform.appendTranslation(-0.75);
			scene.addChild(cube);
			
			var sphere : Mesh = new Mesh(
				SphereGeometry.sphereGeometry,
				new BasicMaterial({diffuseColor : 0x0000ffff})
			);
			sphere.transform.appendTranslation(0.75);
			scene.addChild(sphere);
			
			var quad : Mesh = new Mesh(
				QuadGeometry.doubleSidedQuadGeometry,
				new BasicMaterial({diffuseColor : 0xffff00ff})
			);
			quad.transform.appendTranslation(2.25);
			scene.addChild(quad);
		}
	}
}
