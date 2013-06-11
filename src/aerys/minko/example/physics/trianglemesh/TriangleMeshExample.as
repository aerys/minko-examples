package aerys.minko.example.physics.trianglemesh
{
	import aerys.minko.physics.World;
	import aerys.minko.physics.api.ColliderController;
	import aerys.minko.physics.collider.Collider;
	import aerys.minko.physics.dynamics.DynamicsProperties;
	import aerys.minko.physics.shape.description.primitive.BoxShape;
	import aerys.minko.physics.shape.description.primitive.TriangleMeshShape;
	import aerys.minko.physics.shape.polyhedra.RenderStreamsPolyhedraShapeDescription;
	import aerys.minko.render.geometry.Geometry;
	import aerys.minko.render.geometry.primitive.CubeGeometry;
	import aerys.minko.render.geometry.primitive.SphereGeometry;
	import aerys.minko.render.geometry.stream.StreamUsage;
	import aerys.minko.render.geometry.stream.VertexStream;
	import aerys.minko.render.material.phong.PhongMaterial;
	import aerys.minko.scene.node.Group;
	import aerys.minko.scene.node.ISceneNode;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.scene.node.light.AmbientLight;
	import aerys.minko.scene.node.light.DirectionalLight;
	import aerys.minko.type.loader.ILoader;
	import aerys.minko.type.loader.SceneLoader;
	import aerys.minko.type.loader.parser.ParserOptions;
	import aerys.minko.type.math.Matrix4x4;
	import aerys.minko.type.parser.collada.ColladaParser;
	
	public final class TriangleMeshExample extends AbstractExampleApplication
	{
		[Embed(source="../assets/trianglemesh/planets/rock01.DAE", mimeType="application/octet-stream")]
		private static const PLANET1 		: Class;
		
		protected var _physicsWorld			: World						= null;
		private var _planet					: Mesh						= null;
		private var _gravitationalForce		: GravitationalLinearForce	= null;
		
		public function TriangleMeshExample()
		{
			super();
			
			SceneLoader.registerParser(ColladaParser);
			
			scene.addChild(new DirectionalLight());
			scene.addChild(new AmbientLight());
			initializePhysics();
			loadPlanetModel();
			
			_physicsWorld.running = true;
		}
		
		private function initializePhysics() : void
		{
			_physicsWorld = new World();
			scene.addController(_physicsWorld);
		}
		
		private function loadPlanetModel() : void
		{
			var group	: Group					= new Group();
			var options : ParserOptions			= new ParserOptions();
			
			options.vertexStreamUsage			= StreamUsage.DYNAMIC;
			options.indexStreamUsage			= StreamUsage.DYNAMIC;

			var loader	: ILoader				= group.loadClass(PLANET1, options);
			loader.complete.add(planetLoadedHandler);
		}
		
		private function planetLoadedHandler(loader : ILoader, group : Group) : void
		{
			var meshes		: Vector.<ISceneNode>	= group.get("//mesh");
			var mesh		: Mesh					= null;
			var material	: PhongMaterial			= new PhongMaterial(scene);
			
			for each (mesh in meshes)
			{
				var localToWorld	: Matrix4x4	= mesh.getLocalToWorldTransform(true).prependUniformScale(0.3);
				material.diffuseColor = ((Math.random() * 0xffffff) << 8) | 0xff;
				mesh = new Mesh(mesh.geometry.applyTransform(localToWorld), material);
				initializePlanet(mesh);
			}
			
			initializeFallingCube(20);
		}
		
		private function initializePlanet(mesh	: Mesh = null) : void
		{
			var geometry 			: Geometry									= null;
			
			if (mesh == null)
			{
				geometry = new SphereGeometry(20, 20)
					.applyTransform(new Matrix4x4().appendUniformScale(10));
				var material			: PhongMaterial	= new PhongMaterial(scene);
				material.diffuseColor = ((Math.random() * 0xffffff) << 8) | 0xff;
				_planet = new Mesh(geometry, material);
				_planet.transform.appendTranslation(0, 10, 0);
			}
			else
			{
				_planet = mesh;
				geometry = mesh.geometry;
			}
			
			var shapeDescription	: RenderStreamsPolyhedraShapeDescription	= new RenderStreamsPolyhedraShapeDescription(
				geometry.getVertexStream() as VertexStream,
				geometry.indexStream,
				false
			);
			
			var sphereGeometry		: TriangleMeshShape							= new TriangleMeshShape(shapeDescription);
			var sphereCollider		: Collider									= new Collider(sphereGeometry);
			var sphereController	: ColliderController						= new ColliderController(sphereCollider, true, true);
			
			_planet.addController(sphereController);
			_gravitationalForce = new GravitationalLinearForce(_planet);
			_physicsWorld.addGlobalForceGenerator(_gravitationalForce);
			
			scene.addChild(_planet);
		}
		
		private function initializeFallingCube(nbCubes : uint = 10) : void
		{
			var geometry		: Geometry	= CubeGeometry.cubeGeometry;
			
			for (var i : uint = 0; i < nbCubes; ++i)
			{
				var material		: PhongMaterial	= new PhongMaterial(scene);
				material.diffuseColor = ((Math.random() * 0xffffff) << 8) | 0xff;
				var mesh			: Mesh		= new Mesh(geometry, material);
				mesh.transform.appendTranslation(
					(Math.random() < .5 ? -1 : 1) * Math.random() * 30,
					(Math.random() < .5 ? -1 : 1) * Math.random() * 30,
					(Math.random() < .5 ? -1 : 1) * Math.random() * 30
				);
				
				var boxGeometry		: BoxShape							= new BoxShape(.5, .5, .5);
				var boxDynamics		: DynamicsProperties				= new DynamicsProperties();
				var boxCollider		: Collider							= new Collider(boxGeometry, boxDynamics);
				var boxController	: ColliderController				= new ColliderController(boxCollider, true, true);
				
				mesh.addController(boxController);
				
				scene.addChild(mesh);
			}
		}
		
	}
}