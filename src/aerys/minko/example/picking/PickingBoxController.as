package aerys.minko.example.picking
{
	import aerys.minko.render.Viewport;
	import aerys.minko.render.effect.Effect;
	import aerys.minko.scene.controller.AbstractController;
	import aerys.minko.scene.controller.PickingController;
	import aerys.minko.scene.node.Camera;
	import aerys.minko.scene.node.Group;
	import aerys.minko.scene.node.mesh.Mesh;
	import aerys.minko.scene.node.mesh.geometry.primitive.QuadGeometry;
	import aerys.minko.type.Signal;
	import aerys.minko.type.enum.Blending;
	import aerys.minko.type.enum.TriangleCulling;
	import aerys.minko.type.math.Matrix4x4;
	import aerys.minko.type.math.Plane;
	import aerys.minko.type.math.Vector4;
	
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.utils.getTimer;
	
	public final class PickingBoxController extends AbstractController
	{
		private static const PLANES	: Object	=
		{
			front	: new Plane(0, 0, 1, 0.5),
			back	: new Plane(0, 0, -1, 0.5),
			top		: new Plane(0, -1, 0, 0.5),
			bottom	: new Plane(0, 1, 0, 0.5),
			right	: new Plane(-1, 0, 0, 0.5),
			left	: new Plane(1, 0, 0, 0.5)
		};
		
		private var _viewport	: Viewport			= null;
		private var _camera		: Camera			= null;
		private var _dispatcher	: IEventDispatcher	= null;
		
		private var _picking	: PickingController	= new PickingController();
		
		private var _target		: PickingBox		= null;

		private var _plane		: Plane				= null;
		private var _delta		: Vector4			= null;
		private var _guide		: Group				= null;
		private var _cursor		: Point				= new Point();
		
		private var _moved		: Signal			= new Signal('PickingBoxController.moved');
		
		public function get moved() : Signal
		{
			return _moved;
		}
		
		public function PickingBoxController(viewport 	: Viewport,
											 camera		: Camera,
											 dispatcher	: IEventDispatcher)
		{
			super(PickingBox);
			
			_viewport = viewport;
			_camera = camera;
			_dispatcher = dispatcher;
			
			_picking.bindDefaultInputs(dispatcher);
			
			initialize();
		}
		
		private function initialize() : void
		{
			_picking.mouseDown.add(mouseDownHandler);
			_picking.mouseRollOver.add(mouseRollOverHandler);
			_picking.mouseRollOut.add(mouseRollOutHandler);
			
			targetAdded.add(targetAddedHandler);
		}
		
		private function targetAddedHandler(ctrl 	: PickingBoxController,
											target	: PickingBox) : void
		{
			_target = target;
//			_target.selectedMeshChanged.add(selectedMeshChangedHandler);
			_target.planes.addController(_picking);
		}
		
		/*private function selectedMeshChangedHandler(box		: PickingBox,
													oldMesh	: Mesh,
													newMesh	: Mesh) : void
		{
			
		}*/
		
		private function mouseRollOverHandler(ctrl		: PickingController,
											  target	: Mesh,
											  mouseX	: Number,
											  mouseY	: Number) : void
		{
			target.properties.setProperty(
				'diffuseColor',
				uint(target.bindings.getProperty('diffuseColor')) | 0x88
			);
			
			_target.active = true;
			
			Mouse.cursor = MouseCursor.HAND;
		}
		
		private function mouseRollOutHandler(ctrl	: PickingController,
											 target	: Mesh,
											 mouseX	: Number,
											 mouseY	: Number) : void
		{
			target.properties.setProperty(
				'diffuseColor',
				uint(target.bindings.getProperty('diffuseColor')) & 0xffffff00
			);
			
			_target.active = false;
			
			Mouse.cursor = MouseCursor.AUTO;
		}
		
		private function mouseDownHandler(ctrl		: PickingController,
										  target	: Mesh,
										  mouseX	: Number,
										  mouseY	: Number) : void
		{
			if (!target || !PLANES[target.name])
				return ;
			
			_picking.mouseRollOver.remove(mouseRollOverHandler);
			_picking.mouseRollOut.remove(mouseRollOutHandler);
			
			_dispatcher.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			
			_plane = PLANES[target.name];
			_delta = getIntersection(_plane, mouseX, mouseY);
			
			var color : uint = uint(target.bindings.getProperty('diffuseColor'));
			_guide = new Group(
				new Mesh(
					QuadGeometry.quadGeometry,
					{
						diffuseColor 	: color,
						blending		: Blending.ADDITIVE,
						size			: 1,
						thickness		: 0.05,
						maxDistance		: 10,
						normal			: _plane.normal
					},
					new Effect(new PickingGuideShader())
				)
			);
			
			target.properties.setProperty(
				'diffuseColor',
				uint(target.bindings.getProperty('diffuseColor')) | 0x88
			);
			
			_guide.transform
				.prependTranslation(0, 0, 1)
				.prependUniformScale(_camera.cameraData.zFar)
			target.parent.addChild(_guide);
			
			_dispatcher.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler, false, 1000);
			
			Mouse.cursor = MouseCursor.HAND;
		}
		
		private function mouseUpHandler(event : MouseEvent) : void
		{
			_dispatcher.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			_dispatcher.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			
			if (_guide)
			{
				_picking.mouseRollOver.add(mouseRollOverHandler);
				_picking.mouseRollOut.add(mouseRollOutHandler);
				
				_guide.parent = null;
				_guide = null;
			}
			
			Mouse.cursor = MouseCursor.AUTO;
		}
		
		private function mouseMoveHandler(event : MouseEvent) : void
		{
			event.stopImmediatePropagation();
			
			var i : Vector4 = getIntersection(_plane, event.stageX, event.stageY);
			var x : Number	= i.x - _delta.x;
			var y : Number 	= i.y - _delta.y;
			var z : Number	= i.z - _delta.z;
			
			if (event.shiftKey)
			{
				var t : Vector4 = _target.transform.getTranslation();
				
				x = Math.round(t.x + x);
				y = Math.round(t.y + y);
				z = Math.round(t.z + z);
				_target.transform.setTranslation(x, y, z);
			}
			else
				_target.transform.prependTranslation(x, y, z);
			
			_cursor.x = event.stageX;
			_cursor.y = event.stageY;
			
//			_moved.execute(this, x, y, z);
			
			var scale : Vector4 = _target.selectedMesh.localToWorld.getScale();
			
			_target.selectedMesh.transform.appendTranslation(
				x,// / scale.x,
				y,// / scale.y,
				z// / scale.z
			);
			
			event.updateAfterEvent();
		}
		
		private function getIntersection(plane	: Plane,
										 x		: Number,
										 y		: Number) : Vector4 
		{
			var stageWidth	: Number	= _viewport.width;
			var stageHeight	: Number	= _viewport.height;
			
			var xPercent	: Number	= 2 * (x / stageWidth - 0.5);
			var yPercent 	: Number	= 2 * (y / stageHeight - 0.5);
			
			var fov			: Number	= _camera.cameraData.fieldOfView;
			var worldToView	: Matrix4x4	= _camera.cameraData.worldToView;
			var viewToWorld	: Matrix4x4	= new Matrix4x4().copyFrom(worldToView).invert();
			
			var dx	: Number = Math.tan(fov * 0.5) * xPercent * (stageWidth / stageHeight);
			var dy	: Number = -Math.tan(fov * 0.5) * yPercent;
			
			var p1 : Vector4 = new Vector4(
				dx * _camera.cameraData.zNear, dy * _camera.cameraData.zNear, _camera.cameraData.zNear
			);
			var p2 : Vector4 = new Vector4(
				dx * _camera.cameraData.zFar, dy * _camera.cameraData.zFar, _camera.cameraData.zFar
			);
			
			var m : Matrix4x4 = new Matrix4x4().copyFrom(_target.localToWorld).append(_camera.cameraData.worldToView);
			
			m.invert();
			
			p1 = m.transformVector(p1);
			p2 = m.transformVector(p2);
			
			var dir : Vector4 = Vector4.subtract(p2, p1);
			
			dir.normalize();
			
			var t : Number = -(Vector4.dotProduct(p1, plane.normal) + plane.d) /
				Vector4.dotProduct(dir, plane.normal);
			
			return Vector4.add(p1, new Vector4(t * dir.x, t * dir.y, t * dir.z));
		}
	}
}