package aerys.minko.example.core.terrain
{
	import aerys.minko.render.Effect;
	import aerys.minko.render.geometry.Geometry;
	import aerys.minko.render.geometry.primitive.QuadGeometry;
	import aerys.minko.render.geometry.stream.StreamUsage;
	import aerys.minko.render.geometry.stream.VertexStream;
	import aerys.minko.render.geometry.stream.iterator.VertexIterator;
	import aerys.minko.render.geometry.stream.iterator.VertexReference;
	import aerys.minko.render.material.Material;
	import aerys.minko.render.material.basic.BasicMaterial;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.scene.node.light.AmbientLight;
	import aerys.minko.scene.node.light.DirectionalLight;
	import aerys.minko.type.enum.Blending;
	import aerys.minko.type.loader.TextureLoader;
	import aerys.minko.type.math.Vector4;
	
	import com.bit101.utils.MinimalConfigurator;
	
	import flash.display.BitmapData;
	import flash.events.MouseEvent;

	public class TerrainExample extends AbstractExampleApplication
	{
		[Embed(source="../assets/terrain.jpg")]
		private static const TERRAIN_TEXTURE	: Class;
		
		private static const SIZE				: uint	= 250;
		
		private var _terrain	: Mesh	= null;
		
		override protected function initializeScene() : void
		{
			super.initializeScene();
			
			cameraController.distance = 150;
			cameraController.pitch = 1.;
			cameraController.yaw = Math.PI * .25;
			
			scene.properties.setProperties({
				lightEnabled		: true,
				lightDiffuseColor	: 0xffffff,
				lightDiffuse		: 0.9,
				lightAmbientColor	: 0xffffff,
				lightAmbient		: 0.1,
				lightDirection		: new Vector4(0, -1, -.2)
			});
			
			initializeWater();
			initializeTerrain();
		}
		
		private function initializeWater() : void
		{
			var water : Mesh = new Mesh(
				QuadGeometry.quadGeometry,
				new BasicMaterial({
					diffuseColor 	: 0x00336699,
					blending		: Blending.ADDITIVE
				})
			);
			
			water.transform
				.appendRotation(Math.PI * 0.5, Vector4.X_AXIS)
				.appendTranslation(0, -0.07)
				.appendUniformScale(100);
			
			scene.addChild(water);
		}
		
		override protected function initializeUI() : void
		{
			var cfg : MinimalConfigurator = new MinimalConfigurator(this);
			
			cfg.parseXML(
				<comps>
					<PushButton label="Generate Terrain" x="10" y="10"
								event="click:generateTerrainButtonClickHandler"/>
				</comps>
			);
		}
		
		public function generateTerrainButtonClickHandler(event : MouseEvent) : void
		{
			initializeTerrain();
		}
		
		private function initializeTerrain() : void
		{
			if (_terrain)
			{
				_terrain.parent = null;
				_terrain.geometry.dispose();
			}
				
			var terrainGeometry : Geometry	= new QuadGeometry(false, SIZE, SIZE, StreamUsage.DYNAMIC);
			var heightmap : BitmapData = new BitmapData(SIZE, SIZE, false, 0);
            var vertexStream : VertexStream = terrainGeometry.getVertexStream() as VertexStream;
			var vertices : VertexIterator = new VertexIterator(vertexStream);
			
			heightmap.perlinNoise(200, 200, 8, Math.random() * 0xffffffff, false, true, 7, true);
			
            vertexStream.lock();
            
			for each (var vertex : VertexReference in vertices)
			{
				var x : uint = (vertex.x + 0.5) * (SIZE - 1);
				var y : uint = (vertex.y + 0.5) * (SIZE - 1);
				
				vertex.z = heightmap.getPixel(x, y) / 0xffffff;
			}
            
            vertexStream.unlock();
			
			_terrain = new Mesh(
				terrainGeometry,
				new Material(
					new Effect(new TerrainShader()),
					{
						lightEnabled	: true,
						diffuseMap		: TextureLoader.loadClass(TERRAIN_TEXTURE)
					}
				)				
			);
			
			terrainGeometry.computeNormals().disposeLocalData();
			
			_terrain.transform
				.appendRotation(Math.PI * 0.5, Vector4.X_AXIS)
				.appendTranslation(0, 0.5, 0)
				.appendUniformScale(100);
            
            var light : DirectionalLight = new DirectionalLight();
            
            light.diffuse = .5;
            light.specular = 0.;
            light.transform.lookAt(Vector4.ZERO, Vector4.ONE);
            
            scene.addChild(light)
                .addChild(new AmbientLight(0xffffffff, .5))
			    .addChild(_terrain);
		}
	}
}