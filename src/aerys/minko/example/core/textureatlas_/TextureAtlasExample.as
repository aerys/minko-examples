package aerys.minko.example.core.textureatlas_
{
	import aerys.minko.render.geometry.primitive.CubeGeometry;
	import aerys.minko.render.geometry.stream.iterator.VertexIterator;
	import aerys.minko.render.geometry.stream.iterator.VertexReference;
	import aerys.minko.render.material.Material;
	import aerys.minko.render.material.basic.BasicMaterial;
	import aerys.minko.render.material.basic.BasicProperties;
	import aerys.minko.render.resource.texture.TextureAtlas;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.type.math.Vector4;
	
	import flash.geom.Rectangle;

	public class TextureAtlasExample extends AbstractExampleApplication
	{
		[Embed("../assets/textures/box1.jpg")]
		private static const BOX1_TEXTURE	: Class;
		
		[Embed("../assets/textures/box2.jpg")]
		private static const BOX2_TEXTURE	: Class;
		
		[Embed("../assets/textures/box3.jpg")]
		private static const BOX3_TEXTURE	: Class;
		
		[Embed("../assets/textures/box4.jpg")]
		private static const BOX4_TEXTURE	: Class;
		
		override protected function initializeScene():void
		{
			super.initializeScene();
			
			initSceneWithOneMaterial();
			//initSceneWithoutVertexStreamModification();
		}
		
		private function initSceneWithoutVertexStreamModification() : void
		{
			var textureAtlas 	: TextureAtlas 	= new TextureAtlas(2048, false, 0);
			var material 		: Material 		= new BasicMaterial({
				diffuseMap 		: textureAtlas
			});

			var cube1 : Mesh = new Mesh(new CubeGeometry(), material.clone() as Material);
			var cube2 : Mesh = new Mesh(new CubeGeometry(), material.clone() as Material);
			var cube3 : Mesh = new Mesh(new CubeGeometry(), material.clone() as Material);
			var cube4 : Mesh = new Mesh(new CubeGeometry(), material.clone() as Material);

			var rectangle1 : Rectangle = textureAtlas.addBitmapData((new BOX1_TEXTURE()).bitmapData);
			var rectangle2 : Rectangle = textureAtlas.addBitmapData((new BOX2_TEXTURE()).bitmapData);
			var rectangle3 : Rectangle = textureAtlas.addBitmapData((new BOX3_TEXTURE()).bitmapData);
			var rectangle4 : Rectangle = textureAtlas.addBitmapData((new BOX4_TEXTURE()).bitmapData);
					
			cube1.material.setProperty(BasicProperties.UV_OFFSET, new Vector4(rectangle1.left / 2048, rectangle1.top / 2048));
			cube1.material.setProperty(BasicProperties.UV_SCALE, new Vector4((rectangle1.right - rectangle1.left) / 2048, (rectangle1.bottom - rectangle1.top) / 2048));
			
			cube2.material.setProperty(BasicProperties.UV_OFFSET, new Vector4(rectangle2.left / 2048, rectangle2.top / 2048));
			cube2.material.setProperty(BasicProperties.UV_SCALE, new Vector4((rectangle2.right - rectangle2.left) / 2048, (rectangle2.bottom - rectangle2.top) / 2048));
			
			cube3.material.setProperty(BasicProperties.UV_OFFSET, new Vector4(rectangle3.left / 2048, rectangle3.top / 2048));
			cube3.material.setProperty(BasicProperties.UV_SCALE, new Vector4((rectangle3.right - rectangle3.left) / 2048, (rectangle3.bottom - rectangle3.top) / 2048));
			
			cube4.material.setProperty(BasicProperties.UV_OFFSET, new Vector4(rectangle4.left / 2048, rectangle4.top / 2048));
			cube4.material.setProperty(BasicProperties.UV_SCALE, new Vector4((rectangle4.right - rectangle4.left) / 2048, (rectangle4.bottom - rectangle4.top) / 2048));
			
			cube1.transform.appendTranslation(-3);
			cube2.transform.appendTranslation(-1);
			cube3.transform.appendTranslation(1);
			cube4.transform.appendTranslation(3);
			
			scene.addChild(cube1).addChild(cube2).addChild(cube3).addChild(cube4);
		}
		
		private function initSceneWithOneMaterial() : void
		{
			var textureAtlas 	: TextureAtlas 	= new TextureAtlas(2048, false, 0);
			var material 		: Material 		= new BasicMaterial({
					diffuseMap 		: textureAtlas
				});
			
			var cube1 : Mesh = new Mesh(new CubeGeometry(), material);
			var cube2 : Mesh = new Mesh(new CubeGeometry(), material);
			var cube3 : Mesh = new Mesh(new CubeGeometry(), material);
			var cube4 : Mesh = new Mesh(new CubeGeometry(), material);
			
			var rectangle1 : Rectangle = textureAtlas.addBitmapData((new BOX1_TEXTURE()).bitmapData);
			var rectangle2 : Rectangle = textureAtlas.addBitmapData((new BOX2_TEXTURE()).bitmapData);
			var rectangle3 : Rectangle = textureAtlas.addBitmapData((new BOX3_TEXTURE()).bitmapData);
			var rectangle4 : Rectangle = textureAtlas.addBitmapData((new BOX4_TEXTURE()).bitmapData);
			
			var vertexIterator1 : VertexIterator = new VertexIterator(cube1.geometry.getVertexStream(0));
			
			for each (var vertexReference1 : VertexReference in vertexIterator1)
			{
				vertexReference1.u = (rectangle1.right + (rectangle1.left - rectangle1.right) * vertexReference1.u) / 2048;
				vertexReference1.v = (rectangle1.bottom + (rectangle1.top - rectangle1.bottom) * vertexReference1.v) / 2048;
			}
			
			var vertexIterator2 : VertexIterator = new VertexIterator(cube2.geometry.getVertexStream(0));
			
			for each (var vertexReference2 : VertexReference in vertexIterator2)
			{
				vertexReference2.u = (rectangle2.right + (rectangle2.left - rectangle2.right) * vertexReference2.u) / 2048;
				vertexReference2.v = (rectangle2.bottom + (rectangle2.top - rectangle2.bottom) * vertexReference2.v) / 2048;
			}
			
			var vertexIterator3 : VertexIterator = new VertexIterator(cube3.geometry.getVertexStream(0));
			
			for each (var vertexReference3 : VertexReference in vertexIterator3)
			{
				vertexReference3.u = (rectangle3.right + (rectangle3.left - rectangle3.right) * vertexReference3.u) / 2048;
				vertexReference3.v = (rectangle3.bottom + (rectangle3.top - rectangle3.bottom) * vertexReference3.v) / 2048;
			}
			
			var vertexIterator4 : VertexIterator = new VertexIterator(cube4.geometry.getVertexStream(0));
			
			for each (var vertexReference4 : VertexReference in vertexIterator4)
			{
				vertexReference4.u = (rectangle4.right + (rectangle4.left - rectangle4.right) * vertexReference4.u) / 2048;
				vertexReference4.v = (rectangle4.bottom + (rectangle4.top - rectangle4.bottom) * vertexReference4.v) / 2048;
			}
			
			cube1.transform.appendTranslation(-3);
			cube2.transform.appendTranslation(-1);
			cube3.transform.appendTranslation(1);
			cube4.transform.appendTranslation(3);
			
			scene.addChild(cube1).addChild(cube2).addChild(cube3).addChild(cube4);
		}
	}
}