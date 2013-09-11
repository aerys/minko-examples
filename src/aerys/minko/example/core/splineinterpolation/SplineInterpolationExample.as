package aerys.minko.example.core.splineinterpolation
{
	import com.bit101.components.CheckBox;
	import com.bit101.utils.MinimalConfigurator;
	
	import flash.events.MouseEvent;
	
	import aerys.minko.render.geometry.primitive.CubeGeometry;
	import aerys.minko.render.geometry.primitive.SphereGeometry;
	import aerys.minko.render.material.basic.BasicMaterial;
	import aerys.minko.render.material.phong.PhongMaterial;
	import aerys.minko.scene.controller.animation.AnimationController;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.scene.node.light.AmbientLight;
	import aerys.minko.scene.node.light.DirectionalLight;
	import aerys.minko.type.animation.timeline.ITimeline;
	import aerys.minko.type.animation.timeline.SplineMatrixTimeline;
	import aerys.minko.type.enum.ShadowMappingQuality;
	import aerys.minko.type.enum.ShadowMappingType;
	import aerys.minko.type.interpolation.Path;
	import aerys.minko.type.loader.TextureLoader;
	import aerys.minko.type.math.Vector4;

	public final class SplineInterpolationExample extends AbstractExampleApplication
	{
		public var checkBoxDisplayPath		: CheckBox;
		
		[Embed(source="assets/textures/basketball.jpg")]
		private static const DIFFUSE_MAP_BALL	: Class;
		[Embed(source="assets/sponza_bricks/spnza_bricks_a_diff.jpg")]
		private static const DIFFUSE_MAP_FLOOR	: Class;
		
		private var _pathDebugMesh			: Mesh		= null;
		
		private static const NUM_LOOPS		: uint		= 4;
		private static const LOOP_DX		: Number	= 2.5;
		private static const LOOP_DY		: Number	= 0.25;
		private static const LOOP_DZ		: Number	= 2.5;
		
		public function SplineInterpolationExample()
		{
			super();
		}
		
		override protected function initializeScene() : void
		{
			super.initializeScene();
			
			var material : PhongMaterial = new PhongMaterial();

			material.diffuseMap		= TextureLoader.loadClass(DIFFUSE_MAP_BALL);
			material.castShadows	= true;
			material.receiveShadows	= true;
			
			var ball	: Mesh		= new Mesh(new SphereGeometry(32, 16, true), material);	
			
			// create the path out of a sequence of cubic Bezier splines
			var	path		: Path		= new Path(new Vector4(-LOOP_DX, 0, 0));
			
			var y			: Number	= 0.0;
			for (var loopId : uint = 0; loopId < NUM_LOOPS; ++loopId)
			{
				path.addBezierCubicSegment(
					new Vector4(-LOOP_DX, y,           LOOP_DZ),
					new Vector4( LOOP_DX, y + LOOP_DY, LOOP_DZ),
					new Vector4( LOOP_DX, y + LOOP_DY, 0)
				);
				y += LOOP_DY;
				
				path.addBezierCubicSegment(
					new Vector4( LOOP_DX, y,           -LOOP_DZ),
					new Vector4(-LOOP_DX, y + LOOP_DY, -LOOP_DZ),
					new Vector4(-LOOP_DX, y + LOOP_DY,  0)
				);				
				y += LOOP_DY;
			}
			path.addBezierCubicSegment(
				new Vector4(-LOOP_DX, y, LOOP_DZ),
				new Vector4(-LOOP_DX, 0, -LOOP_DZ),
				new Vector4(-LOOP_DX, 0, 0)
			);

			// control the mesh's transform with the generated spline
			var timeline	: SplineMatrixTimeline	= new SplineMatrixTimeline(
				'transform',
				5000,
				path,
				true,
				30
			);
			ball.addController(new AnimationController(
				new <ITimeline>[timeline as ITimeline],
				true
			));
			scene.addChild(ball);

			// get a goemetric representation of the spline for debug
			_pathDebugMesh	= new Mesh(
				path.getGeometry(0.01, 500),
				new BasicMaterial({ diffuseColor : 0xffffffff })
			);
			_pathDebugMesh.visible	= false;
			scene.addChild(_pathDebugMesh);

			
			var floorMaterial	: PhongMaterial = material.clone() as PhongMaterial;
			floorMaterial.diffuseMap	= TextureLoader.loadClass(DIFFUSE_MAP_FLOOR);
			
			var floor	: Mesh = new Mesh(CubeGeometry.cubeGeometry, floorMaterial);
			floor.transform
				.appendScale(10, 0.1, 10)
				.appendTranslation(0, -1.0, 0);
			scene.addChild(floor);
			
			initializeLights();
		}
		
		private function initializeLights() : void
		{
			var light	: DirectionalLight	= new DirectionalLight();
			light.shadowCastingType			= ShadowMappingType.PCF;
			light.shadowMapSize				= 1024;
			light.shadowQuality				= ShadowMappingQuality.LOW;
			light.shadowSpread				= 2;
			light.shadowWidth				= 100;
			light.shadowZFar         		= 200;
			light.shadowBias         		= 1 / 256;
			
			light.transform.lookAt(
				Vector4.ZERO,
				new Vector4(0.0, 2 * NUM_LOOPS * LOOP_DY, 0.0)
			);
			
			scene.addChild(light);
			scene.addChild(new AmbientLight(0xffffffff, 0.4));
		}
		
		override protected function initializeUI() : void
		{
			var cfg : MinimalConfigurator = new MinimalConfigurator(this);
			
			cfg.parseXML(
				<comps>
					<Panel x="10" y="10" width="90" height="30" >
					<HBox x="10" y="10" >
						<CheckBox label="Display path" id="checkBoxDisplayPath"
							event="click:displayPathClickHandler"/>
					</HBox>
					</Panel>
				</comps>
			);
			
			checkBoxDisplayPath.selected	= false;
		}
		
		public function displayPathClickHandler(event : MouseEvent) : void
		{			
			if (_pathDebugMesh)
				_pathDebugMesh.visible	= checkBoxDisplayPath.selected;
		}
	}
}