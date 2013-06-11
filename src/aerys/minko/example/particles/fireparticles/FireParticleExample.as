package aerys.minko.example.particles.fireparticles
{
	import aerys.minko.particles.controller.ParticleSystemController;
	import aerys.minko.particles.modifier.init.StartColor;
	import aerys.minko.particles.modifier.init.StartSize;
	import aerys.minko.particles.modifier.init.StartSprite;
	import aerys.minko.particles.modifier.init.StartVelocity;
	import aerys.minko.particles.modifier.update.SizeOverTime;
	import aerys.minko.particles.modifier.update.VelocityOverTime;
	import aerys.minko.particles.sampler.LinearlyInterpolatedNumber;
	import aerys.minko.particles.sampler.RandomBetweenColors;
	import aerys.minko.particles.sampler.RandomBetweenConstants;
	import aerys.minko.particles.shape.SphereEmitterShape;
	import aerys.minko.render.effect.hdr.HDREffect;
	import aerys.minko.render.geometry.Geometry;
	import aerys.minko.render.geometry.primitive.CubeGeometry;
	import aerys.minko.render.material.Material;
	import aerys.minko.render.material.phong.PhongMaterial;
	import aerys.minko.scene.node.Group;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.scene.node.light.PointLight;
	import aerys.minko.type.clone.CloneOptions;
	import aerys.minko.type.clone.ControllerCloneAction;
	import aerys.minko.type.enum.NormalMappingType;
	import aerys.minko.type.loader.TextureLoader;
	import aerys.minko.type.math.Vector4;

	public final class FireParticleExample extends AbstractExampleApplication
	{
		// more information at the following URL:
		// http://doc.minko.io/wiki/Create_Procedural_Fire_Animations_Using_Particles
		
		// sprite sheet used to decorate the fire particles
		[Embed("../assets/fire_spritesheet.png")]
		private static const FIRE_SPRITESHEET	: Class;
		
		[Embed("../assets/sponza_bricks/spnza_bricks_a_diff.jpg")]
		private static const BRICK_DIFFUSE		: Class;
		[Embed("../assets/sponza_bricks/spnza_bricks_a_ddn.jpg")]
		private static const BRICK_NORMALS		: Class;
		[Embed("../assets/sponza_bricks/spnza_bricks_a_spec.jpg")]
		private static const BRICK_SPECULAR		: Class;
		
		override protected function initializeScene() : void
		{						
			super.initializeScene();
			
			stage.frameRate	= 60;
			viewport.backgroundColor = 0;
			
			cameraController.yaw		= 0.25*Math.PI;
			cameraController.pitch		= 0.275*Math.PI;
			cameraController.lookAt.set(0, 20, 0);
			cameraController.distance	= 100.0;
			
			// create an empty geometry that will only support the controller
			var fireMesh	: Mesh 			= new Mesh(new Geometry(), new Material());
			fireMesh.material.diffuseMap	= TextureLoader.loadClass(FIRE_SPRITESHEET);
			
			var particleController : ParticleSystemController = new ParticleSystemController();			
			fireMesh.addController(particleController);
			
			// specify a particle emission shape and a particle emission rate
			particleController.emitterShape	= new SphereEmitterShape(5.0);
			particleController.rate 		= 200.0;

			// provide a modifier to control initial particle color
			particleController.addModifier(new StartColor(new RandomBetweenColors(0x3f1205ff, 0x7f260fff)));
			
			// provide modifiers to control the particle size (at the beginning, and across time)
			particleController.addModifier(new StartSize(new RandomBetweenConstants(5.0, 10.0)));
			particleController.addModifier(new SizeOverTime(new LinearlyInterpolatedNumber(1.0, 0.0)));
			
			// provide modifiers to control the particle velocity (at the beginning, and across time)
			particleController.addModifier(new StartVelocity(
				new RandomBetweenConstants(0.0, 5.0),
				new RandomBetweenConstants(5.0, 50.0),
				new RandomBetweenConstants(0.0, 5.0))
			);
			particleController.addModifier(new VelocityOverTime(
				new LinearlyInterpolatedNumber(1.0, 0.0),
				new LinearlyInterpolatedNumber(1.0, 0.0),
				new LinearlyInterpolatedNumber(1.0, 0.0)
			));
			
			// provide a modifier to randomly pick one of the sprites from the mesh's diffuse map
			var numRows	: uint	= 2;
			var numCols	: uint	= 2;
			particleController.addModifier(new StartSprite(
				numRows, 
				numCols, 
				new RandomBetweenConstants(0, numRows*numCols-1)
			));
			
			
			// clone the main fire mesh in order to get a collection of bonfires 
			var distance	: Number	= 35.0;
			var numFires	: uint		= 8;
			
			var options : CloneOptions = CloneOptions.defaultOptions;
			options.setActionForControllerClass(
				ParticleSystemController, 
				ControllerCloneAction.REASSIGN
			);
			
			for (var i:uint = 0; i < numFires; ++i)
			{
				var fireClone	: Mesh 			= fireMesh.clone(options) as Mesh;
				var fireLight	: PointLight	= new PointLight(0xff9955ff);
				
				var angle		: Number		= 2.0 * Math.PI * (i / numFires);
				var cloneX		: Number 		= distance * Math.cos(angle);
				var cloneZ		: Number		= distance * Math.sin(angle);
				
				var fireGroup	: Group	= new Group();
				fireGroup.addChild(fireClone);
				fireGroup.addChild(fireLight);
				fireGroup.transform.appendTranslation(cloneX, 20.0, cloneZ);
				scene.addChild(fireGroup);
			}
			
			// add an additional textured mesh for the room
			var roomMaterial : PhongMaterial	= new PhongMaterial();
			roomMaterial.diffuseMap				= TextureLoader.loadClass(BRICK_DIFFUSE);
			roomMaterial.normalMap				= TextureLoader.loadClass(BRICK_NORMALS);
			roomMaterial.specularMap			= TextureLoader.loadClass(BRICK_SPECULAR);
			roomMaterial.uvScale				= new Vector4(3, 3);
			roomMaterial.normalMappingType		= NormalMappingType.NORMAL;
			roomMaterial.diffuseMultiplier		= 0.05;
			roomMaterial.diffuseColor			= 0xbbbbbbff;
			roomMaterial.castShadows			= false;
			roomMaterial.receiveShadows			= false;
			
			var roomMesh : Mesh = new Mesh(new CubeGeometry(), roomMaterial);
			roomMesh.geometry
				.computeTangentSpace()
				.invertWinding()
				.flipNormals()
				.disposeLocalData();
			roomMesh.transform
				.setTranslation(0.0, 0.5, 0.0)
				.appendScale(150, 100, 150);
			
			scene.addChild(roomMesh);
		}
		
	}
}