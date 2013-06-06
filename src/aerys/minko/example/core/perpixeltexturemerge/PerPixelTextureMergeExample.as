package aerys.minko.example.core.perpixeltexturemerge
{
	import aerys.minko.render.Effect;
	import aerys.minko.render.geometry.primitive.QuadGeometry;
	import aerys.minko.render.geometry.stream.StreamUsage;
	import aerys.minko.render.geometry.stream.VertexStream;
	import aerys.minko.render.geometry.stream.VertexStreamList;
	import aerys.minko.render.geometry.stream.format.VertexComponent;
	import aerys.minko.render.geometry.stream.format.VertexComponentType;
	import aerys.minko.render.geometry.stream.format.VertexFormat;
	import aerys.minko.render.material.Material;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.type.loader.TextureLoader;
	import aerys.minko.type.math.Vector4;

	public class PerPixelTextureMergeExample extends AbstractExampleApplication
	{
		[Embed("../assets/checker.jpg")]
		private static const CHECKER	: Class;
		
		[Embed("../assets/seymour_plane/planeDiffuse.jpg")]
		private static const WALL 		: Class;
		
		public static const COLOR_COEF	: VertexComponent = VertexComponent.create(['colorCoef'], VertexComponentType.FLOAT_1);
		public static const TEX_1_COEF 	: VertexComponent = VertexComponent.create(['tex1coef'], VertexComponentType.FLOAT_1);
		public static const TEX_2_COEF	: VertexComponent = VertexComponent.create(['tex2coef'], VertexComponentType.FLOAT_1);

		private var material : Material = new Material(
			new Effect(new PerPixelTextureMergeShader()),
			{
				diffuseColor 	: 0x0f0f0f0f,
				diffuseMap1 	: TextureLoader.loadClass(CHECKER),
				diffuseMap2 	: TextureLoader.loadClass(WALL)
			});
		

		override protected function initializeScene():void
		{
			super.initializeScene();
			
			var geometry : QuadGeometry = new QuadGeometry(true, 100, 100, 3, 3, 5, 5);
			
			var vertexStream		: VertexStream 		= geometry.getVertexStream(0) as VertexStream;
			var numVertices 		: uint 				= vertexStream.numVertices;
			var coefsStreamData 	: Vector.<Number> 	= new Vector.<Number>();
			
			for (var i : uint = 0; i < numVertices; ++i)
			{
				var coeficient : Vector4 = new Vector4(Math.random(), Math.random(), Math.random(), 0).normalize();
				coefsStreamData.push(coeficient.x, coeficient.y, coeficient.z);
			}
			
			var coefStream : VertexStream = VertexStream.fromVector(
				StreamUsage.DYNAMIC, 
				new VertexFormat(COLOR_COEF, TEX_1_COEF, TEX_2_COEF), 
				coefsStreamData);
			
			geometry.setVertexStream(new VertexStreamList(vertexStream, coefStream)); 
			
			var quad : Mesh = new Mesh(geometry, material);
			
			scene.addChild(quad);
		}
		
	}
}