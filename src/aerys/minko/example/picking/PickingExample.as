package aerys.minko.example.picking
{
	import aerys.minko.render.effect.Effect;
	import aerys.minko.render.effect.basic.BasicShader;
	import aerys.minko.scene.controller.PickingController;
	import aerys.minko.scene.node.Group;
	import aerys.minko.scene.node.mesh.Mesh;
	import aerys.minko.scene.node.mesh.primitive.CubeMesh;
	import aerys.minko.scene.node.mesh.primitive.QuadMesh;
	import aerys.minko.type.bounding.BoundingSphere;
	import aerys.minko.type.enum.Blending;
	import aerys.minko.type.enum.TriangleCulling;
	import aerys.minko.type.math.Matrix4x4;
	import aerys.minko.type.math.Plane;
	import aerys.minko.type.math.Vector4;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;

	public class PickingExample extends MinkoExampleApplication
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
		
		private var _rotate		: Boolean			= false;
		private var _box		: Group				= null;
		private var _target		: Mesh				= null;
		private var _plane		: Plane				= null;
		private var _guide		: Group				= null;
		private var _delta		: Vector4			= null;
		private var _cursor		: Point				= new Point();
		private var _picking	: PickingController	= null;
		
		override protected function initializeScene() : void
		{
			viewport.backgroundColor = 0x101010;
			
			initializePickingBox();
		}
		
		private function initializePickingBox() : void
		{
			var corner	: Mesh	= new CubeMesh(
				new Effect(new BasicShader()),
				{ "diffuseColor"	: 0xffffffff}
			);
			
			var topFrontLeft		: Group	= new Group(corner.clone());
			var topFrontRight		: Group	= new Group(corner.clone());
			var topBackLeft			: Group	= new Group(corner.clone());
			var topBackRight		: Group	= new Group(corner.clone());
			var bottomFrontLeft		: Group	= new Group(corner.clone());
			var bottomFrontRight	: Group	= new Group(corner.clone());
			var bottomBackLeft		: Group	= new Group(corner.clone());
			var bottomBackRight		: Group	= new Group(corner.clone());
			
			topFrontLeft.transform
				.appendUniformScale(0.1)
				.appendTranslation(-0.5, 0.5, -0.5);
			topFrontRight.transform
				.appendUniformScale(0.1)
				.appendTranslation(0.5, 0.5, -0.5);
			topBackLeft.transform
				.appendUniformScale(0.1)
				.appendTranslation(-0.5, 0.5, 0.5);
			topBackRight.transform
				.appendUniformScale(0.1)
				.appendTranslation(0.5, 0.5, 0.5);
			bottomFrontLeft.transform
				.appendUniformScale(0.1)
				.appendTranslation(-0.5, -0.5, -0.5);
			bottomFrontRight.transform
				.appendUniformScale(0.1)
				.appendTranslation(0.5, -0.5, -0.5);
			bottomBackLeft.transform
				.appendUniformScale(0.1)
				.appendTranslation(-0.5, -0.5, 0.5);
			bottomBackRight.transform
				.appendUniformScale(0.1)
				.appendTranslation(0.5, -0.5, 0.5);
			
			_box = new Group(
				topFrontLeft,
				topFrontRight,
				topBackLeft,
				topBackRight,
				bottomFrontLeft,
				bottomFrontRight,
				bottomBackLeft,
				bottomBackRight
			);
			
			var plane 	: Mesh 	= new QuadMesh(new Effect(new BasicShader(Blending.ALPHA)));
			var front 	: Group = new Group(plane.clone({ "diffuseColor" : 0x0000ff11 }));
			var back 	: Group = new Group(plane.clone({ "diffuseColor" : 0x0000ff11 }));
			var left 	: Group = new Group(plane.clone({ "diffuseColor" : 0xff000011 }));
			var right 	: Group = new Group(plane.clone({ "diffuseColor" : 0xff000011 }));
			var top 	: Group = new Group(plane.clone({ "diffuseColor" : 0x00ff0011 }));
			var bottom	: Group = new Group(plane.clone({ "diffuseColor" : 0x00ff0011 }));
			
			front[0].name = "front";
			front.transform.appendTranslation(0., 0., -0.5);
			back[0].name = "back";
			back.transform
				.appendRotation(Math.PI, Vector4.Y_AXIS)
				.appendTranslation(0., 0., 0.5);
			left[0].name = "left";
			left.transform
				.appendRotation(Math.PI * .5, Vector4.Y_AXIS)
				.appendTranslation(-.5, 0, 0);
			right[0].name = "right";
			right.transform
				 .appendRotation(Math.PI * -.5, Vector4.Y_AXIS)
				 .appendTranslation(.5, 0, 0);
			top[0].name = "top";
			top.transform
			   .appendRotation(Math.PI * .5, Vector4.X_AXIS)
			   .appendTranslation(0., .5, 0.);
			bottom[0].name = "bottom";
			bottom.transform
				  .appendRotation(Math.PI * -.5, Vector4.X_AXIS)
				  .appendTranslation(0., -.5, 0.);
			
			var pickingPlanes : Group = new Group(
				front,
				back,
				left,
				right,
				top,
				bottom
			);
			
			_picking = new PickingController(stage);
			_picking.mouseDown.add(mouseDownHandler);
			_picking.mouseRollOver.add(mouseRollOverHandler);
			_picking.mouseRollOut.add(mouseRollOutHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			pickingPlanes.addController(_picking);
			
			_box.addChild(pickingPlanes);
			
			scene.addChild(_box);
		}
		
		private function mouseRollOverHandler(ctrl		: PickingController,
											  target	: Mesh,
											  mouseX	: Number,
											  mouseY	: Number) : void
		{
			target.bindings.setProperty(
				"diffuseColor",
				uint(target.bindings.getProperty("diffuseColor")) | 0x88
			);
			
			Mouse.cursor = MouseCursor.HAND;
		}
		
		private function mouseRollOutHandler(ctrl	: PickingController,
											 target	: Mesh,
											 mouseX	: Number,
											 mouseY	: Number) : void
		{
			target.bindings.setProperty(
				"diffuseColor",
				uint(target.bindings.getProperty("diffuseColor")) & 0xffffff11
			);
			
			Mouse.cursor = MouseCursor.AUTO;
		}
		
		private function mouseDownHandler(ctrl		: PickingController,
										  target	: Mesh,
										  mouseX	: Number,
										  mouseY	: Number) : void
		{
			_picking.mouseRollOver.remove(mouseRollOverHandler);
			_picking.mouseRollOut.remove(mouseRollOutHandler);
			
			_plane = PLANES[target.name];
			_delta = getIntersection(_plane, mouseX, mouseY);
			
			_target = target;
			var color : uint = uint(_target.bindings.getProperty("diffuseColor"));
			_guide = new Group(
				new QuadMesh(
					new Effect(new PickingGuideShader()),
					{
						diffuseColor 	: color,
						size			: 1,
						thickness		: 0.05,
						maxDistance		: 10,
						normal			: _plane.normal
					}
				)
			);
			
//			Matrix4x4.copy(_target.parent.transform, _guide.transform);
			_guide.transform
				.prependTranslation(0, 0, 1)
				.prependUniformScale(camera.zFar)
//			scene.addChild(_guide);
			_target.parent.addChild(_guide);
			
//			_target.bindings.setProperty("diffuseColor", color | 0x66);
			
			cameraController.unbindDefaultControls(stage);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			
			Mouse.cursor = MouseCursor.HAND;
		}
		
		private function mouseUpHandler(event : MouseEvent) : void
		{
			_picking.mouseRollOver.add(mouseRollOverHandler);
			_picking.mouseRollOut.add(mouseRollOutHandler);
			
			cameraController.bindDefaultControls(stage);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			
			if (_target)
			{
				/*_target.bindings.setProperty(
					"diffuseColor",
					uint(_target.bindings.getProperty("diffuseColor")) & 0xffffff33
				);*/
				_target = null;
			}
			
			if (_guide)
			{
				_guide.parent = null;
				_guide = null;
			}
			
			Mouse.cursor = MouseCursor.AUTO;
		}
		
		private function mouseMoveHandler(event : MouseEvent) : void
		{
			var i : Vector4 = getIntersection(_plane, event.stageX, event.stageY);
			var x : Number	= i.x - _delta.x;
			var y : Number 	= i.y - _delta.y;
			var z : Number	= i.z - _delta.z;
			
			if (event.shiftKey)
			{
				var t : Vector4 = _box.transform.getTranslation();
				
				x = Math.round(t.x + x);
				y = Math.round(t.y + y);
				z = Math.round(t.z + z);
				_box.transform.setTranslation(x, y, z);
			}
			else
				_box.transform.prependTranslation(x, y, z);
			
			_cursor.x = event.stageX;
			_cursor.y = event.stageY;
				
			event.updateAfterEvent();
		}
		
		public function getIntersection(plane	: Plane,
										x		: Number,
										y		: Number) : Vector4 
		{
			var stageWidth	: Number	= viewport.width;
			var stageHeight	: Number	= viewport.height;
			
			var xPercent	: Number	= 2 * (x / stageWidth - 0.5);
			var yPercent 	: Number	= 2 * (y / stageHeight - 0.5);
			
			var fov			: Number	= camera.fieldOfView;
			var worldToView	: Matrix4x4	= camera.worldToView;
			var viewToWorld	: Matrix4x4	= Matrix4x4.invert(worldToView);
			
			var dx	: Number = Math.tan(fov * 0.5) * xPercent * (stageWidth / stageHeight);
			var dy	: Number = -Math.tan(fov * 0.5) * yPercent;
			
			var p1 : Vector4 = new Vector4(
				dx * camera.zNear, dy * camera.zNear, camera.zNear
			);
			var p2 : Vector4 = new Vector4(
				dx * camera.zFar, dy * camera.zFar, camera.zFar
			);
			
			var m : Matrix4x4 = Matrix4x4.multiply(camera.worldToView, _box.localToWorld);
			
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