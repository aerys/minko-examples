package aerys.minko.example.core.indexstream_
{
	import com.bit101.utils.MinimalConfigurator;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	
	import aerys.minko.render.geometry.Geometry;
	import aerys.minko.render.geometry.primitive.CubeGeometry;
	import aerys.minko.render.geometry.primitive.SphereGeometry;
	import aerys.minko.render.geometry.stream.IVertexStream;
	import aerys.minko.render.geometry.stream.IndexStream;
	import aerys.minko.render.geometry.stream.StreamUsage;
	import aerys.minko.render.material.basic.BasicMaterial;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.type.math.Vector4;

	public class IndexStreamManipulationExample extends AbstractExampleApplication
	{
		private var _availableTriangles	: Vector.<uint> = new Vector.<uint>();
		private var _myIndexStream 		: IndexStream 	= new IndexStream(StreamUsage.DYNAMIC);
		private var _mesh 				: Mesh 			= null;
		
		override protected function initializeScene():void
		{
			super.initializeScene();
			
			var sphereGeometry 	: SphereGeometry 	= new SphereGeometry();
			var myGeometry 		: Geometry 			= new Geometry(new <IVertexStream>[sphereGeometry.getVertexStream(0)], _myIndexStream);
			
			_mesh	= new Mesh(myGeometry, new BasicMaterial({diffuseColor : 0xFF00FFFF}));
			
			extractTriangle(sphereGeometry.indexStream);
			// an index stream can't be empty !
			_myIndexStream.pushTriangle(0, 0, 0);
			scene.addChild(_mesh);
		
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		}
		
		override protected function initializeUI():void
		{
			var cfg : MinimalConfigurator = new MinimalConfigurator(this);
			
			cfg.parseXML(
				<comps>
					<PushButton label="Show Triangle" x="10" y="10"
								event="click:showTriangle"/>
					<PushButton label="Hide Triangle" x="10" y="30"
								event="click:hideTriangle"/>
				</comps>
			);
		}
		
		private function keyDownHandler(event : KeyboardEvent) : void
		{
			switch(event.keyCode)
			{
				case Keyboard.LEFT:
					hideTriangle();
					break;
				
				case Keyboard.RIGHT:
					showTriangle();
					break;
			}
		}
		
		public function showTriangle(event : Event = null) : void
		{
			if (_availableTriangles.length == 0)
				return;
			
			var i : uint = uint(Math.random() * (_availableTriangles.length / 3));
			
			_myIndexStream.pushTriangle(_availableTriangles[i * 3], _availableTriangles[i * 3 + 1], _availableTriangles[i * 3 + 2]);
			
			_availableTriangles.splice(i * 3, 3);
		}
		
		public function hideTriangle(event : Event = null) : void
		{
			var numTriangle : uint = _myIndexStream.length / 3;
			var index 		: uint = uint(Math.random() * numTriangle);
			
			if (index == 0 && numTriangle > 1)
				index = 1;
			if (index == 0)
				return;
			
			var data : ByteArray = _myIndexStream.lock();
				
			data.position = index * 2;
			_availableTriangles.push(data.readShort(), data.readShort(), data.readShort());
			_myIndexStream.unlock(false);
				
			_myIndexStream.deleteTriangle(index);
		}
		
		private function extractTriangle(indexStream : IndexStream) : void
		{
			var data 		: ByteArray = indexStream.lock();
			var dataLength 	: uint 		= data.length;	
			
			while (data.position < dataLength)
				_availableTriangles.push(data.readShort());
			
			indexStream.unlock(false);
		}
		
		override protected function enterFrameHandler(event:Event):void
		{
			super.enterFrameHandler(event);
			
			_mesh.transform.appendRotation(0.2, Vector4.Y_AXIS);
		}
	}
}