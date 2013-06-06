package aerys.minko.example.core.vertexattributes
{
	import aerys.minko.render.geometry.Geometry;
	import aerys.minko.render.geometry.primitive.TeapotGeometry;
	import aerys.minko.render.geometry.stream.IVertexStream;
	import aerys.minko.render.geometry.stream.IndexStream;
	import aerys.minko.render.geometry.stream.StreamUsage;
	import aerys.minko.render.geometry.stream.VertexStream;
	import aerys.minko.render.geometry.stream.VertexStreamList;
	import aerys.minko.render.geometry.stream.format.VertexComponent;
	import aerys.minko.render.geometry.stream.format.VertexFormat;
	import aerys.minko.render.geometry.stream.iterator.VertexIterator;
	import aerys.minko.render.geometry.stream.iterator.VertexReference;
	import aerys.minko.render.material.Material;
	import aerys.minko.render.material.basic.BasicProperties;
	import aerys.minko.render.material.phong.PhongEffect;
	import aerys.minko.render.material.phong.PhongMaterial;
	import aerys.minko.scene.node.Group;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.scene.node.light.AmbientLight;
	import aerys.minko.scene.node.light.PointLight;
	import aerys.minko.type.enum.ShadowMappingType;
	import aerys.minko.type.enum.TriangleCulling;
	import aerys.minko.type.math.Vector4;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public final class ShatterExample extends AbstractExampleApplication
	{
		private static const NUM_MESHES				: uint		= 75;
		private static const RANDOM_MAXIMUM			: Number	= 30;
		private static const RANDOM_MINIMUM			: Number	= 5;
		
		override protected function initializeScene():void
		{
			super.initializeScene();
			
			initLight();
			
			var shatterShader : ShatterShader = new ShatterShader();
			var material : PhongMaterial = new PhongMaterial({
				triangleCulling : TriangleCulling.NONE
				},
				new PhongEffect(null, shatterShader)
			);
			material.castShadows = true;
			material.receiveShadows = true;

			var geometries : Group = new Group();
			scene.addChild(geometries);
			
			var geometry : TeapotGeometry = new TeapotGeometry(4);
			geometry.computeNormals().disposeLocalData();
			
			createShatteringGeometries(geometries, geometry, material, NUM_MESHES);
		}
		
		private function createShatteringGeometries(parentNode : Group, geometry : Geometry, material : Material, numMeshes : uint) : void
		{
			var indexStream 	: IndexStream 				= geometry.indexStream;
			var vertexStreams 	: Vector.<IVertexStream> 	= new Vector.<IVertexStream>(geometry.numVertexStreams);
			var vertexStream 	: VertexStream 				= createFlatVertexStream(geometry);
			for (var m : uint = 0; m < numMeshes; ++m)
			{
				var vsOffset	: VertexStream 		= createShatterVertexStream(vertexStream.numVertices);
				var vsList		: VertexStreamList 	= new VertexStreamList(vertexStream, vsOffset);
				var mat			: Material 			= material.clone() as Material;
				
				// We just apply a random color
				mat.setProperty(BasicProperties.DIFFUSE_COLOR, ((Math.random() * 0xffffff) << 8) || 0xff);
				
				var newGeometry : Geometry 	= new Geometry(new <IVertexStream>[vsList]);
				var newMesh 	: Mesh 		= new Mesh(newGeometry, mat);
				randomizeTransform(newMesh);					
				parentNode.addChild(newMesh);
			}
		}
		
		private function randomizeTransform(mesh : Mesh) : void
		{
			mesh.transform.setTranslation(
				50 * (Math.random() - .5),
				50 * (Math.random() - .5),
				50 * (Math.random() - .5)
			);
			
			mesh.transform.setRotation(
				2 * Math.PI * Math.random(),
				2 * Math.PI * Math.random(),
				2 * Math.PI * Math.random()
			);
		}
		
		private function initLight() : void
		{
			var pointLight	: PointLight	= new PointLight();
			pointLight.shadowCastingType	= ShadowMappingType.NONE;
			pointLight.shadowZNear          = 0.1;
			pointLight.shadowZFar           = 100.;
			pointLight.shadowMapSize		= 1024;
			pointLight.attenuationDistance  = 80;
			
			scene
				.addChild(pointLight)
				.addChild(new AmbientLight());
		}
		
		private function createFlatVertexStream(geometry : Geometry) : VertexStream
		{
			var vs 			: IVertexStream 	= geometry.getVertexStream(0);
			// Adding an IndexStream to the VertexIterator constructor makes it iterate the vertices following the corresponding Index Buffer.
			var vertices 	: VertexIterator 	= new VertexIterator(vs, geometry.indexStream);
			var vertexData 	: ByteArray 		= new ByteArray();
			var format 		: VertexFormat 		= vs.format;
			
			vertexData.endian = Endian.LITTLE_ENDIAN;
			for each (var vertex : VertexReference in vertices)
			{
				for (var i : uint = 0; i < format.numComponents; ++i)
				{
					var component : VertexComponent = format.getComponent(i);
					for (var j : uint = 0; j < component.numProperties; ++j)
					{
						var property : String = component.getProperty(j);
						vertexData.writeFloat(vertex[property]);
					}
				}
			}
			vertexData.position = 0;
			
			return new VertexStream(StreamUsage.STATIC, format, vertexData);
		}
		
		private function createShatterVertexStream(numVertices : uint) : VertexStream
		{
			var format 		: VertexFormat 	= new VertexFormat(ShatterVertexComponent.SHATTER_VECTOR);
			var vertexData 	: ByteArray 	= new ByteArray();
			
			vertexData.endian = Endian.LITTLE_ENDIAN;
			
			var offsetT : Number	= (Math.random() - 0.5) * (RANDOM_MAXIMUM - RANDOM_MINIMUM + 1) + RANDOM_MINIMUM;
			var offset	: Vector4	= Vector4.ZERO;
			
			for (var i : uint = 0; i < numVertices; ++i)
			{
				// We want all the vertices of a triangle to translate the same way
				if ((i % 3) == 0)
				{
					offset = new Vector4(((Math.random() - 0.5) * (RANDOM_MAXIMUM - RANDOM_MINIMUM + 1)) + RANDOM_MINIMUM,
						((Math.random() - 0.5) * (RANDOM_MAXIMUM - RANDOM_MINIMUM + 1)) + RANDOM_MINIMUM,
						((Math.random() - 0.5) * (RANDOM_MAXIMUM - RANDOM_MINIMUM + 1)) + RANDOM_MINIMUM,
						offsetT);
				}
				
				vertexData.writeFloat(offset.x);
				vertexData.writeFloat(offset.y);
				vertexData.writeFloat(offset.z);
				vertexData.writeFloat(offset.w);
			}
			vertexData.position = 0;
						
			return new VertexStream(StreamUsage.DYNAMIC, format, vertexData);
		}
	}
}