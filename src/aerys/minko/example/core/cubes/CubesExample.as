package aerys.minko.example.core.cubes
{
	import aerys.minko.render.effect.SinglePassRenderingEffect;
	import aerys.minko.scene.node.mesh.IMesh;
	import aerys.minko.scene.node.mesh.Mesh;
	import aerys.minko.scene.node.mesh.modifier.NormalMeshModifier;
	import aerys.minko.type.math.Matrix4x4;
	import aerys.minko.type.stream.IndexStream;
	import aerys.minko.type.stream.StreamUsage;
	import aerys.minko.type.stream.VertexStream;
	import aerys.minko.type.stream.VertexStreamList;
	import aerys.minko.type.stream.format.VertexComponent;
	import aerys.minko.type.stream.format.VertexFormat;

	public class CubesExample extends MinkoExampleApplication
	{
		private static const CUBE_VERTICES 	: Vector.<Number> 	= new <Number>[
			0.5,	0.5,	0.5,
			-0.5,	0.5,	0.5,
			-0.5,	0.5,	-0.5,
			0.5,	0.5,	-0.5,
			0.5,	-0.5,	0.5,
			-0.5,	-0.5,	0.5,
			-0.5,	-0.5,	-0.5,
			0.5,	-0.5,	-0.5,
		];
		
		private static const CUBE_INDICES 	: Vector.<uint> 	= new <uint>[
			0, 1, 2, 0, 2, 3,
			4, 6, 5, 4, 7, 6,
			3, 2, 6, 3, 6, 7,
			0, 3, 7, 0, 7, 4,
			1, 0, 4, 1, 4, 5,
			2, 1, 5, 2, 5, 6
		];
		
		private static const CUBE_COLOR		: Vector.<Number>	= new Vector.<Number>(24);
		
		override protected function initializeScene() : void
		{
			// create the streams
			var indexStream	: IndexStream = new IndexStream(StreamUsage.WRITE);
			
			var xyzStream : VertexStream = new VertexStream(
				StreamUsage.WRITE,
				VertexFormat.XYZ
			);
			
			var rgbStream : VertexStream = new VertexStream(
				StreamUsage.WRITE,
				new VertexFormat(VertexComponent.RGB)
			);

			// fill the streams with 5000 colored cubes
			var m : Matrix4x4 = new Matrix4x4();
			
			m.appendUniformScale(0.05)
			 .push();
			
			for (var i : int = 0; i < 5000; ++i)
			{
				m.pop()
				 .push()
			     .appendTranslation(
					 (Math.random() - 0.5) * 4,
					 (Math.random() - 0.5) * 4,
					 (Math.random() - 0.5) * 4
				 );
				
				addCube(xyzStream, rgbStream, indexStream, Math.random() * 0xffffff, m);
			}
			
			// setup the scene
			viewport.defaultEffect = new SinglePassRenderingEffect(new RGBDirectionalLightShader());
			
			scene.addChild(
				new NormalMeshModifier(
					new Mesh(new VertexStreamList(xyzStream, rgbStream), indexStream)
				)
			);
		}
		
		private function addCube(xyzStream 		: VertexStream,
								 rgbStream 		: VertexStream,
								 indexStream	: IndexStream,
								 color			: uint,
								 transform 		: Matrix4x4) : void
		{
			var colorMatrix : Matrix4x4 = new Matrix4x4();
			
			colorMatrix.appendTranslation(
				((color >> 16) & 0xff) / 255.,
				((color >> 8) & 0xff) / 255.,
				(color & 0xff) / 255.
			);
			
			rgbStream.push(colorMatrix.transformRawVectors(CUBE_COLOR));
			
			xyzStream.push(transform.transformRawVectors(CUBE_VERTICES));
			
			indexStream.push(CUBE_INDICES, 0, 0, (indexStream.length / 36) * 8);
		}
	}
}