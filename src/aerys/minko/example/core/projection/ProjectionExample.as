package aerys.minko.example.core.projection
{
	import aerys.minko.render.Effect;
	import aerys.minko.render.geometry.Geometry;
	import aerys.minko.render.geometry.primitive.CubeGeometry;
	import aerys.minko.render.geometry.primitive.TeapotGeometry;
	import aerys.minko.render.geometry.stream.iterator.VertexIterator;
	import aerys.minko.render.geometry.stream.iterator.VertexReference;
	import aerys.minko.render.material.Material;
	import aerys.minko.render.shader.vertex.VertexNormalShader;
	import aerys.minko.scene.node.Group;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.type.math.Vector4;
	
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public class ProjectionExample extends AbstractExampleApplication
	{
		private static const NUM_POINTS	: uint	= 10;
		
		override protected function initializeScene() : void
		{
			super.initializeScene();
			
			cameraController.distance = 10.;
			cameraController.lookAt.y = 1.5;
			
			var geom : Geometry = new TeapotGeometry();
			
			scene.addChild(new Mesh(
				geom,
				new Material(new Effect(new VertexNormalShader()))
			));

			var vertices : VertexIterator = new VertexIterator(geom.getVertexStream());
			
			for (var i : uint = 0; i < NUM_POINTS; ++i)
			{
				var vertex : VertexReference = vertices[uint(vertices.length * Math.random())];
				var text : TextField = new TextField();
				var group : Group = new Group();
				
				text.text = '(' + vertex.x.toPrecision(2) + ', ' + vertex.y.toPrecision(2) + ')';
				text.autoSize = TextFieldAutoSize.LEFT;
				text.selectable = false;
				addChild(text);
				
				group.transform.appendTranslation(vertex.x, vertex.y, vertex.z);
				group.addController(new ProjectionScript(text));
				scene.addChild(group);
			}
		}
	}
}