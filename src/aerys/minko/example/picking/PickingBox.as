package aerys.minko.example.picking
{
	import aerys.minko.render.Viewport;
	import aerys.minko.render.effect.Effect;
	import aerys.minko.render.effect.basic.BasicShader;
	import aerys.minko.scene.node.Camera;
	import aerys.minko.scene.node.Group;
	import aerys.minko.scene.node.Scene;
	import aerys.minko.scene.node.mesh.Mesh;
	import aerys.minko.scene.node.mesh.geometry.primitive.CubeGeometry;
	import aerys.minko.scene.node.mesh.geometry.primitive.QuadGeometry;
	import aerys.minko.type.Signal;
	import aerys.minko.type.bounding.BoundingBox;
	import aerys.minko.type.enum.Blending;
	import aerys.minko.type.enum.DepthTest;
	import aerys.minko.type.enum.TriangleCulling;
	import aerys.minko.type.math.Matrix4x4;
	import aerys.minko.type.math.Vector4;
	
	import flash.events.IEventDispatcher;
	
	public class PickingBox extends Group
	{
		private static const EFFECT			: Effect	= new Effect(
			new BasicShader(null, -2)
		);
		
		private static const CORNER_MESH	: Mesh		= new Mesh(
			CubeGeometry.cubeGeometry,
			{ 
				diffuseColor	: 0xffffff99,
				depthTest		: DepthTest.ALWAYS
			},
			EFFECT
		);
		
		private var _topFrontLeft			: Mesh		= CORNER_MESH.clone() as Mesh;
		private var _topFrontRight			: Mesh		= CORNER_MESH.clone() as Mesh;
		private var _topBackLeft			: Mesh		= CORNER_MESH.clone() as Mesh;
		private var _topBackRight			: Mesh		= CORNER_MESH.clone() as Mesh;
		private var _bottomFrontLeft		: Mesh		= CORNER_MESH.clone() as Mesh;
		private var _bottomFrontRight		: Mesh		= CORNER_MESH.clone() as Mesh;
		private var _bottomBackLeft			: Mesh		= CORNER_MESH.clone() as Mesh;
		private var _bottomBackRight		: Mesh		= CORNER_MESH.clone() as Mesh;
		
		private var _guide					: Group		= null;
		private var _planes					: Group		= null;
		
		private var _active					: Boolean	= false;
		
		private var _selectedMesh			: Mesh		= null;
		
		//		private var _selectedMeshChanged	: Signal	= new Signal();
		
		public function get planes() : Group
		{
			return _planes;
		}
		
		public function get active() : Boolean
		{
			return _active;
		}
		public function set active(value : Boolean) : void
		{
			_active = value;
		}
		
		public function get selectedMesh() : Mesh
		{
			return _selectedMesh;
		}
		public function set selectedMesh(value : Mesh) : void
		{
			_selectedMesh = value;
			
			if (value)
			{
				value.removedFromScene.add(selectedMeshRemovedFromSceneHandler);
				updateFromBoundingBox(value.geometry.boundingBox, value.localToWorld);
			}
		}
		
		/*public function get selectedMeshChanged() : Signal
		{
		return _selectedMeshChanged;
		}*/
		
		public function PickingBox(viewport		: Viewport,
								   camera		: Camera,
								   dispatcher 	: IEventDispatcher)
		{
			super();
			
			initialize();
			
			addController(
				new PickingBoxController(viewport, camera, dispatcher)
			);
		}
		
		private function initialize() : void
		{
			_topFrontLeft.transform
				.appendUniformScale(0.05)
				.appendTranslation(-0.5, 0.5, -0.5);
			_topFrontRight.transform
				.appendUniformScale(0.05)
				.appendTranslation(0.5, 0.5, -0.5);
			_topBackLeft.transform
				.appendUniformScale(0.05)
				.appendTranslation(-0.5, 0.5, 0.5);
			_topBackRight.transform
				.appendUniformScale(0.05)
				.appendTranslation(0.5, 0.5, 0.5);
			_bottomFrontLeft.transform
				.appendUniformScale(0.05)
				.appendTranslation(-0.5, -0.5, -0.5);
			_bottomFrontRight.transform
				.appendUniformScale(0.05)
				.appendTranslation(0.5, -0.5, -0.5);
			_bottomBackLeft.transform
				.appendUniformScale(0.05)
				.appendTranslation(-0.5, -0.5, 0.5);
			_bottomBackRight.transform
				.appendUniformScale(0.05)
				.appendTranslation(0.5, -0.5, 0.5);
			
			addChild(_topFrontLeft);
			addChild(_topFrontRight);
			addChild(_topBackLeft);
			addChild(_topBackRight);
			addChild(_bottomFrontLeft);
			addChild(_bottomFrontRight);
			addChild(_bottomBackLeft);
			addChild(_bottomBackRight);
			
			var plane 	: Mesh 	= new Mesh(
				QuadGeometry.quadGeometry,
				{
					blending 	: Blending.ALPHA//,
					//					depthTest	: DepthTest.ALWAYS
				},
				new Effect(new BasicShader(null, -1))
			);
			
			var frontMesh	: Mesh	= plane.clone() as Mesh;
			var leftMesh	: Mesh	= plane.clone() as Mesh;
			var topMesh		: Mesh	= plane.clone() as Mesh;
			
			frontMesh.properties.setProperty('diffuseColor', 0x0000ff00);
			leftMesh.properties.setProperty('diffuseColor', 0xff000000);
			topMesh.properties.setProperty('diffuseColor', 0x00ff0000);
			
			var backMesh	: Mesh	= frontMesh.clone() as Mesh;
			var rightMesh	: Mesh	= leftMesh.clone() as Mesh;
			var bottomMesh	: Mesh	= topMesh.clone() as Mesh;
			
			var front 		: Group = new Group(frontMesh);
			var back 		: Group = new Group(backMesh);
			var left 		: Group = new Group(leftMesh);
			var right 		: Group = new Group(rightMesh);
			var top 		: Group = new Group(topMesh);
			var bottom		: Group	= new Group(bottomMesh);
			
			front.getChildAt(0).name = "front";
			front.transform.appendTranslation(0., 0., -0.5);
			back.getChildAt(0).name = "back";
			back.transform
				.appendRotation(Math.PI, Vector4.Y_AXIS)
				.appendTranslation(0., 0., 0.5);
			left.getChildAt(0).name = "left";
			left.transform
				.appendRotation(Math.PI * .5, Vector4.Y_AXIS)
				.appendTranslation(-.5, 0, 0);
			right.getChildAt(0).name = "right";
			right.transform
				.appendRotation(Math.PI * -.5, Vector4.Y_AXIS)
				.appendTranslation(.5, 0, 0);
			top.getChildAt(0).name = "top";
			top.transform
				.appendRotation(Math.PI * .5, Vector4.X_AXIS)
				.appendTranslation(0., .5, 0.);
			bottom.getChildAt(0).name = "bottom";
			bottom.transform
				.appendRotation(Math.PI * -.5, Vector4.X_AXIS)
				.appendTranslation(0., -.5, 0.);
			
			_planes = new Group(
				front,
				back,
				left,
				right,
				top,
				bottom
			);
			
			_planes.name = "pickingPlanes";
			addChild(_planes);
		}
		
		public function updateFromBoundingBox(boundingBox 			: BoundingBox,
											  targetLocalToWorld	: Matrix4x4) : void
		{
			var max : Vector4 	= targetLocalToWorld.transformVector(boundingBox.max);
			var min : Vector4 	= targetLocalToWorld.transformVector(boundingBox.min);
			var t	: Vector4	= targetLocalToWorld.getTranslation();
			
			transform.setTranslation(t.x, t.y, t.z);
			
			max = Vector4.subtract(max, t);
			min = Vector4.subtract(min, t);
			
			_topBackRight.transform.setTranslation(max.x, max.y, max.z);
			_topBackLeft.transform.setTranslation(min.x, max.y, max.z);
			_topFrontRight.transform.setTranslation(max.x, max.y, min.z);
			_topFrontLeft.transform.setTranslation(min.x, max.y, min.z);
			
			_bottomFrontLeft.transform.setTranslation(min.x, min.y, min.z);
			_bottomFrontRight.transform.setTranslation(max.x, min.y, min.z);
			_bottomBackLeft.transform.setTranslation(min.x, min.y, max.z);
			_bottomBackRight.transform.setTranslation(max.x, min.y, max.z);
			
			_planes.transform.setScale(
				max.x - min.x + 0.01,
				max.y - min.y + 0.01,
				max.z - min.z + 0.01
			);
		}
		
		private function selectedMeshRemovedFromSceneHandler(mesh	: Mesh,
															 scene	: Scene) : void
		{
			mesh.removedFromScene.remove(selectedMeshRemovedFromSceneHandler);
			
			selectedMesh = null;
			parent = null;
		}
	}
}