package aerys.minko.example.particles.fountain
{
	import aerys.minko.particles.controller.ParticleSystemController;
	import aerys.minko.particles.modifier.init.StartAngularVelocity;
	import aerys.minko.particles.modifier.init.StartForce;
	import aerys.minko.particles.modifier.init.StartSize;
	import aerys.minko.particles.modifier.init.StartSprite;
	import aerys.minko.particles.modifier.update.ColorOverTime;
	import aerys.minko.particles.modifier.update.SizeOverTime;
	import aerys.minko.particles.sampler.Constant;
	import aerys.minko.particles.sampler.LinearlyInterpolatedColor;
	import aerys.minko.particles.sampler.LinearlyInterpolatedNumber;
	import aerys.minko.particles.sampler.RandomBetweenConstants;
	import aerys.minko.particles.shape.ConeEmitterShape;
	import aerys.minko.particles.shape.CylinderEmitterShape;
	import aerys.minko.particles.type.enum.ParticleEmissionDirection;
	import aerys.minko.render.geometry.primitive.CubeGeometry;
	import aerys.minko.render.material.basic.BasicMaterial;
	import aerys.minko.render.resource.texture.TextureResource;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.type.clone.CloneOptions;
	import aerys.minko.type.clone.ControllerCloneAction;
	import aerys.minko.type.loader.TextureLoader;
	import aerys.minko.type.math.Vector4;
	
	public class FountainExample extends AbstractExampleApplication
	{
		
		override protected function initializeScene() : void
		{
			super.initializeScene();

			var mesh			: Mesh			= new Mesh(new CubeGeometry(), new BasicMaterial());
			
			viewport.backgroundColor = 0;
			cameraController.distance = 40;
			
			var psc				: ParticleSystemController	= new ParticleSystemController();
			
			
			// Simulate the particles in world space in order to have a trail of flames behind the rotating ring.
			psc.inWorldSpace = true;
			
			// Setting the emission
			psc.rate = 300;
			psc.lifetime = new Constant(3.);
			
			//  use cylinder shape and emission direction defined by shape to create a spray.
			psc.emitterShape = new ConeEmitterShape(Math.PI/20, 0.1, 2);
			psc.emissionDirection = ParticleEmissionDirection.SHAPE;
			psc.emissionVelocity = new RandomBetweenConstants(15., 20.);
			
			// decrease size of the particles.
			psc.addModifier(new StartSize(new Constant(0.1)));
			
			// Modify the color from white to light blue over the lifetime of the particle
			psc.addModifier(new ColorOverTime(new LinearlyInterpolatedColor(0xffffffff, 0x00aaffff)));
			
			// Add an downward force corresponding to gravity.
			psc.addModifier(new StartForce(
				Constant.SAMPLER_ZERO,
				new Constant(-9.81),
				Constant.SAMPLER_ZERO));
						
			mesh.addController(psc);
			scene.addChild(mesh);
			
			
			var options : CloneOptions = CloneOptions.defaultOptions;
			
			// Clone the controller instead of reassigning for the particle systems to use the correct transform
			options.setActionForControllerClass(ParticleSystemController, ControllerCloneAction.CLONE);
			
			// Clone the particle system target mesh and move the clones to create a fountain
			for (var i : uint = 0; i < 8; ++i)
			{
				var clone	: Mesh						= mesh.clone(options) as Mesh;
				var ctrl	: ParticleSystemController	= clone.getControllersByType(ParticleSystemController)[0] as ParticleSystemController;
				
				ctrl.lifetime = new Constant(2.);
				
				clone.transform.appendRotation(i & 0x1 ? -Math.PI / 8 : -Math.PI / 4, new Vector4(0, 0, 1));
				clone.transform.appendTranslation(i & 0x1 ? 5 : 4, 0, 0);
				clone.transform.appendRotation(i * Math.PI / 4, new Vector4(0, 1, 0));
				
				scene.addChild(clone);
			}
		}
	}
}