package aerys.minko.example.core.simplewatersim
{
	import aerys.minko.render.Effect;
	import aerys.minko.render.geometry.Geometry;
	import aerys.minko.render.geometry.primitive.QuadGeometry;
	import aerys.minko.render.geometry.stream.StreamUsage;
	import aerys.minko.render.geometry.stream.iterator.VertexIterator;
	import aerys.minko.render.geometry.stream.iterator.VertexReference;
	import aerys.minko.render.material.basic.BasicShader;
	import aerys.minko.render.material.Material;
	import aerys.minko.render.material.basic.BasicMaterial;
	import aerys.minko.render.resource.texture.TextureResource;
	import aerys.minko.render.Viewport;
	import aerys.minko.scene.controller.camera.ArcBallController;
	import aerys.minko.scene.node.camera.Camera;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.scene.node.Scene;
	import aerys.minko.type.enum.Blending;
	import aerys.minko.type.enum.SamplerFiltering;
	import aerys.minko.type.log.DebugLevel;
	import aerys.minko.type.math.Vector4;
	import aerys.monitor.Monitor;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class WaterSim extends Sprite {
		
		[Embed("../assets/skyprobe.jpg")]
		private static const SKYPROBE:Class;
		
		[Embed("../assets/wave.jpg")]
		private static const TEX_WAVE:Class;
		
		private static const SIZE:int = 128;
		
		private var view:Viewport;
		private var camera:Camera;
		private var scene:Scene;
		private var controller:ArcBallController;
		
		private var water:Mesh = null;
		private var waterMaterial:WaterMaterial;
		
		public function WaterSim() {
			view = new Viewport(0, 800, 600);
			scene = new Scene();
			camera = new Camera();
			
			controller = new ArcBallController();
			controller.bindDefaultControls(stage);
			controller.minDistance = 1;
			controller.distance = 150;
			controller.pitch = 1.;
			camera.addController(controller);
			scene.addChild(camera);
			
			stage.stageWidth = 800;
			stage.stageHeight = 600;
			stage.addChild(view);
			stage.addChild(Monitor.monitor.watch(scene, ['numDescendants', 'numTriangles', 'numPasses']));
			
			initWater();
			
			addEventListener(Event.ENTER_FRAME, onWaving);
			
			stage.frameRate = 60;
			stage.addEventListener(Event.ENTER_FRAME, loop);
			stage.addEventListener(Event.RESIZE, onResize);
		}
		
		private function initWater():void {
			var geom:Geometry = new XZPanel(false, SIZE, SIZE);
			
			var skyPart:TextureResource = new TextureResource(1024, 1024);
			skyPart.setContentFromBitmapData(new SKYPROBE().bitmapData, true);
			
			// a better heightmap would give us a better result.
			var height:BitmapData = new TEX_WAVE().bitmapData;
			var heightPart:TextureResource = new TextureResource(SIZE, SIZE);
			heightPart.setContentFromBitmapData(height, true);
			
			waterMaterial = new WaterMaterial(null, new Effect(new WaterShader()));
			waterMaterial.timer = 0;
			waterMaterial.size = 0.5 / (SIZE - 1);
			// you can set material's alpha value in diffuseColor.
			waterMaterial.diffuseColor = 0x0000ffff;
			waterMaterial.reflectivity = 0.8;
			waterMaterial.magnitude = 0.02;
			waterMaterial.lightDirection = new Vector4(0, -0.5, 1);
			waterMaterial.environmentMap = skyPart;
			waterMaterial.heightMap = heightPart;
			
			water = new Mesh(geom, waterMaterial);
			water.frustumCulling = 0;
			water.transform.appendUniformScale(200);
			scene.addChild(water);
			
			var vertices:VertexIterator = new VertexIterator(water.geometry.getVertexStream());
			var vertex:VertexReference;
			for each (vertex in vertices) {
				var x:uint = (vertex.x + 0.5) * (SIZE - 1);
				var z:uint = (vertex.z + 0.5) * (SIZE - 1);
				// read r value to get a height value between(0,1).
				vertex.y = (((height.getPixel(x, z) >> 16) & 0xFF) / 255);
			}
		}
		
		private function onWaving(e:Event):void {
			waterMaterial.timer += 0.025;
		}
		
		private function onResize(e:Event):void {
			view.width = stage.stageWidth;
			view.height = stage.stageHeight;
		}
		
		private function loop(e:Event):void {
			scene.render(view);
		}
		
	}
}