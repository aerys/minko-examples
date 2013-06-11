package aerys.minko.example.physics.convexhull
{
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import aerys.minko.physics.api.ColliderController;
	import aerys.minko.physics.collider.Collider;
	import aerys.minko.physics.dynamics.DynamicsProperties;
	import aerys.minko.physics.dynamics.PhysicsMaterialProfile;
	import aerys.minko.physics.shape.description.container.MultiprofileShape;
	import aerys.minko.physics.shape.description.primitive.BoxShape;
	import aerys.minko.physics.shape.description.primitive.ConvexShape;
	import aerys.minko.physics.shape.polyhedra.RenderStreamsPolyhedraShapeDescription;
	import aerys.minko.render.geometry.Geometry;
	import aerys.minko.render.geometry.primitive.CubeGeometry;
	import aerys.minko.render.geometry.primitive.TeapotGeometry;
	import aerys.minko.render.geometry.stream.VertexStream;
	import aerys.minko.render.material.Material;
	import aerys.minko.render.material.phong.PhongMaterial;
	import aerys.minko.scene.node.Mesh;
	import aerys.monitor.Monitor;

	public class PhysicsConvexHullExample extends AbstractPhysicsExampleApplication
	{
		private static const TARGET_FPS	: Number	= 30;
		private static const GEOMETRY	: Geometry	= new TeapotGeometry(4);	
		
		private var _lastTime	: int	= 0;
		private var _teapot		: Mesh;
		
		override protected function initializeScene():void
		{
			super.initializeScene();	
			
			initializeCamera();
			initializePool();
			
			_lastTime = getTimer()	
		}
		
		override protected function enterFrameHandler(event : Event) : void
		{
			var time : int = getTimer();
			
			if (Monitor.monitor.framerate >= TARGET_FPS  && _lastTime  + 500 < getTimer())
			{
				addTeapot();
				_lastTime = time;
			}	
			
			super.enterFrameHandler(event);
		}
	
		
		private function initializeCamera() : void
		{
			cameraController.distance = 50.;
			cameraController.pitch = 1.1;
			cameraController.yaw = -0.2;
		}
		
		private function initializePool() : void
		{
			var materialBox : Material =  new PhongMaterial({ diffuseColor   :  0xffaa44ee,
																	 receiveShadows : true,
																	 castShadows 	: true }
			);
			var materialTeaPot : Material = new PhongMaterial({ diffuseColor		:  0xffeeaaff,
																	   receiveShadows 	: true, 
																	   castShadows 		: true });
			
			var pool_top 	: Mesh = new Mesh(CubeGeometry.cubeGeometry, materialBox);
			var pool_bot 	: Mesh = pool_top.clone() as Mesh;
			var pool_left 	: Mesh = pool_top.clone() as Mesh;
			var pool_right 	: Mesh = pool_top.clone() as Mesh;
			_teapot = new Mesh(GEOMETRY, materialTeaPot);

			var poolCollider	: Collider = new Collider(new BoxShape(10, 4, 0.5));
			var poolController 	: ColliderController	= new ColliderController(poolCollider, true, true);
			
			var poolSideCollider   : Collider = new Collider(new BoxShape(0.5, 4, 7.5));
			var poolSideController : ColliderController	= new ColliderController(poolSideCollider, true, true);

			
			var teapotCollider   : Collider = new Collider(
				new MultiprofileShape(
					new ConvexShape( new RenderStreamsPolyhedraShapeDescription(
						_teapot.geometry.getVertexStream() as VertexStream,
						_teapot.geometry.indexStream, true)),
					null,
					new PhysicsMaterialProfile(1, 0.8, 0.3)), 
				new DynamicsProperties()		
			);
				
		
			var teapotController : ColliderController	= new ColliderController(teapotCollider, true, true);
			
			_teapot.addController(teapotController);
			pool_top.addController(poolController);
			pool_bot.addController(poolController);
			pool_left.addController(poolSideController);
			pool_right.addController(poolSideController);
			
			pool_top.transform.appendScale(20, 8, 1).appendTranslation(15., 4, 7.);
			pool_bot.transform.appendScale(20, 8, 1).appendTranslation(15., 4, -7.);
			pool_left.transform.appendScale(1, 8, 15).appendTranslation(4.5, 4, 0.);
			pool_right.transform.appendScale(1, 8, 15).appendTranslation(25.5, 4, 0.);
			_teapot.transform.appendUniformScale(0.75).appendTranslation(15, 30, 0);
			
			scene.addChild(pool_top);
			scene.addChild(pool_bot);
			scene.addChild(pool_right);
			scene.addChild(pool_left);
		}
		
		private function addTeapot() : void
		{
			var teapot 		: Mesh 	   = _teapot.clone() as Mesh;
			var randomMat 	: Material = new PhongMaterial({ diffuseColor 	: ((Math.random() * 0xffffff) << 8) | 0xff,
																	receiveShadows  : true,
																	castShadows 	: true }); 
			teapot.material = randomMat;
			scene.addChild(teapot);
		}
		
		public function PhysicsConvexHullExample()
		{
		}
	}
}