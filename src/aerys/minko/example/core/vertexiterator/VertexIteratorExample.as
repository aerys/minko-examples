package aerys.minko.example.core.vertexiterator
{
	import aerys.minko.render.Effect;
	import aerys.minko.render.geometry.Geometry;
	import aerys.minko.render.geometry.primitive.CubeGeometry;
	import aerys.minko.render.geometry.primitive.TeapotGeometry;
	import aerys.minko.render.geometry.stream.iterator.VertexIterator;
	import aerys.minko.render.geometry.stream.iterator.VertexReference;
	import aerys.minko.render.material.Material;
	import aerys.minko.render.material.basic.BasicMaterial;
	import aerys.minko.render.material.vertex.VertexNormalShader;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.type.enum.Blending;
	import aerys.minko.type.enum.FrustumCulling;
	import aerys.minko.type.math.Vector4;

	public class VertexIteratorExample extends MinkoExampleApplication
	{
		override protected function initializeScene() : void
		{
			super.initializeScene();
			
			cameraController.distance = 10;
			cameraController.lookAt.set(0, 1.5, 0);
			
			var positionMaterial : Material = new BasicMaterial({
				diffuseColor 	: 0xff00007f,
				blending		: Blending.ALPHA
			});
			var normalMaterial : Material = new BasicMaterial({
				diffuseColor 	: 0xffff007f,
				blending		: Blending.ALPHA
			});
			
			var geometry : Geometry = new TeapotGeometry(5).computeNormals();
			var vertices : VertexIterator = new VertexIterator(geometry.getVertexStream(0));
			
			for each (var vertex : VertexReference in vertices)
			{
				var position : Mesh = new Mesh(CubeGeometry.cubeGeometry, positionMaterial);
				
				position.frustumCulling = FrustumCulling.DISABLED;
				position.transform
					.appendUniformScale(.025)
					.appendTranslation(vertex.x, vertex.y, vertex.z);
				
				scene.addChild(position);
				
				var normal : Mesh = new Mesh(CubeGeometry.cubeGeometry, normalMaterial);
				
				normal.transform
					.orientTo(
						new Vector4(vertex.nx, vertex.ny, vertex.nz),
						new Vector4(vertex.x, vertex.y, vertex.z)
					)
					.prependTranslation(0., 0., 0.05)
					.prependScale(0.01, 0.01, 0.1)
				
				scene.addChild(normal);
			}			
			
			scene.addChild(new Mesh(geometry, new Material(new Effect(new VertexNormalShader()))));
		}
	}
}