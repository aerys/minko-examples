package aerys.minko.example.picking
{
	import aerys.minko.render.Viewport;
	import aerys.minko.render.effect.Effect;
	import aerys.minko.render.effect.basic.BasicShader;
	import aerys.minko.scene.node.Camera;
	import aerys.minko.scene.node.Group;
	import aerys.minko.scene.node.mesh.Mesh;
	import aerys.minko.scene.node.mesh.primitive.CubeMesh;
	import aerys.minko.scene.node.mesh.primitive.QuadMesh;
	import aerys.minko.type.enum.Blending;
	import aerys.minko.type.math.Vector4;
	
	import flash.events.IEventDispatcher;
	
	public class PickingBox extends Group
	{
		private static const EFFECT	: Effect	= new Effect(new BasicShader(Blending.ALPHA));
		
		private var _guide	: Group	= null;
		
		public function PickingBox(viewport		: Viewport,
								   camera		: Camera,
								   dispatcher 	: IEventDispatcher)
		{
			super();
			
			addController(new PickingBoxController(viewport, camera, dispatcher));
		}
		
		override protected function initialize() : void
		{
			super.initialize();
			
			var corner	: Mesh	= new CubeMesh(
				EFFECT,
				{ diffuseColor	: 0xffffff99}
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
			
			addChild(topFrontLeft);
			addChild(topFrontRight);
			addChild(topBackLeft);
			addChild(topBackRight);
			addChild(bottomFrontLeft);
			addChild(bottomFrontRight);
			addChild(bottomBackLeft);
			addChild(bottomBackRight);
			
			var plane 	: Mesh 	= new QuadMesh(EFFECT);
			var front 	: Group = new Group(plane.clone({ diffuseColor : 0x0000ff11 }));
			var back 	: Group = new Group(plane.clone({ diffuseColor : 0x0000ff11 }));
			var left 	: Group = new Group(plane.clone({ diffuseColor : 0xff000011 }));
			var right 	: Group = new Group(plane.clone({ diffuseColor : 0xff000011 }));
			var top 	: Group = new Group(plane.clone({ diffuseColor : 0x00ff0011 }));
			var bottom	: Group = new Group(plane.clone({ diffuseColor : 0x00ff0011 }));
			
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
			
			pickingPlanes.name = "pickingPlanes";
			addChild(pickingPlanes);
		}
		
		
	}
}