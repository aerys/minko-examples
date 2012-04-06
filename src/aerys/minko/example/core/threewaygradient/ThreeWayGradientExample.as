package aerys.minko.example.core.threewaygradient
{
	import aerys.minko.render.effect.Effect;
	import aerys.minko.scene.node.mesh.Mesh;
	import aerys.minko.scene.node.mesh.geometry.Geometry;
	import aerys.minko.type.stream.IVertexStream;
	import aerys.minko.type.stream.StreamUsage;
	import aerys.minko.type.stream.VertexStream;
	import aerys.minko.type.stream.format.VertexComponent;
	import aerys.minko.type.stream.format.VertexFormat;
	import aerys.minko.type.stream.iterator.VertexIterator;

	public class ThreeWayGradientExample extends MinkoExampleApplication
	{
		override protected function initializeScene() : void
		{
			var format : VertexFormat = new VertexFormat(VertexComponent.XY, VertexComponent.RGB);
			var vertices : VertexIterator = new VertexIterator(new VertexStream(StreamUsage.WRITE, format));
			
			vertices[0] = {x: 0.,  y: .5,  r: 1., g: 0., b: 0.};
			vertices[1] = {x: -.5, y: -.5, r: 0., g: 1., b: 0.};
			vertices[2] = {x: .5,  y: -.5, r: 0., g: 0., b: 1.};
			
			scene.addChild(
				new Mesh(
					new Geometry(new <IVertexStream>[vertices.vertexStream]),
					null,
					new Effect(new ThreeWayGradientShader())
				)
			);
		}
	}
}