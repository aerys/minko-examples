package aerys.minko.example.particles.ringoffire
{
	import aerys.minko.particles.controller.ParticleSystemController;
	import aerys.minko.particles.modifier.init.StartAngularVelocity;
	import aerys.minko.particles.modifier.init.StartForce;
	import aerys.minko.particles.modifier.init.StartSprite;
	import aerys.minko.particles.modifier.update.ColorOverTime;
	import aerys.minko.particles.modifier.update.SizeOverTime;
	import aerys.minko.particles.sampler.Constant;
	import aerys.minko.particles.sampler.LinearlyInterpolatedColor;
	import aerys.minko.particles.sampler.LinearlyInterpolatedNumber;
	import aerys.minko.particles.sampler.RandomBetweenConstants;
	import aerys.minko.particles.shape.CylinderEmitterShape;
	import aerys.minko.particles.type.enum.ParticleEmissionDirection;
	import aerys.minko.render.geometry.primitive.CubeGeometry;
	import aerys.minko.render.material.basic.BasicMaterial;
	import aerys.minko.render.resource.texture.TextureResource;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.type.loader.TextureLoader;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	
	public class RingOfFireExample extends AbstractExampleApplication
	{
		[Embed("firefull.jpg")]
		private static const FIRE_TEXTURE	: Class;
		
		private var fireTexture : TextureResource	= TextureLoader.loadClass(FIRE_TEXTURE);
		
		private var _mesh			: Mesh			= new Mesh(new CubeGeometry(), new BasicMaterial());
		
		
		private var _time			: Number;
		private var _rotate			: Boolean	= true;
		
		override protected function initializeScene() : void
		{
			super.initializeScene();
			viewport.backgroundColor = 0;
			cameraController.distance = 20;
			
			var psc				: ParticleSystemController	= new ParticleSystemController();
			
			// Setting the emission
			//  use a small, nearly hollow cylinder as shape in orderto create a ring.
			psc.emitterShape = new CylinderEmitterShape(1, 5, 5);
			psc.rate = 3000;
			// random lifetime to prevent a visible limit between a zone where particles live and an empty zone.
			psc.lifetime = new RandomBetweenConstants(0.2, 0.8);
			
			// Reddish color to orange, the blue component is useful in order to have a white core where a lote of particles are present, which looks hotter.
			psc.addModifier(new ColorOverTime(new LinearlyInterpolatedColor(0xfc210a00, 0xd6810000)));
			
			// Make the particles rotate over their lifetime.
			psc.addModifier(new StartAngularVelocity(new RandomBetweenConstants(1, 5)));
			
			// Add an upward force for the flames and a small dispersion on the z axis.
			psc.addModifier(new StartForce(
				new RandomBetweenConstants(-2, 2),
				new RandomBetweenConstants(8, 10),
				new RandomBetweenConstants(-2, 2)));
			
			// Make the size of the particle decrease over time.
			psc.addModifier(new SizeOverTime(new LinearlyInterpolatedNumber(1.3, 0.2)));
			
			// Set sprite sheet sampling
			psc.addModifier(new StartSprite(2, 2, new RandomBetweenConstants(0., 4.)));
			
			_mesh.addController(psc);
			scene.addChild(_mesh);		
			_mesh.rotationZ = 15;
			_mesh.material.diffuseMap = fireTexture;
			
			// Simulate the particles in world space in order to have a trail of flames behind the rotating ring.
			psc.inWorldSpace = true;
			
			_time = getTimer();
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		}
		
		private function keyDownHandler(event	: KeyboardEvent) : void
		{
			switch(event.keyCode)
			{
				case Keyboard.SPACE:
				{
					_rotate = !_rotate;
					break;
				}
				default:
				{
					
				}
			}
			
		}
		
		override protected function enterFrameHandler(event : Event) : void
		{
			super.enterFrameHandler(event);
			
			var now	: Number	= getTimer();
			
			if (_rotate)
				_mesh.rotationX += (now - _time) / 1000 * 1.5;
			
			_time = now;
		}
	}
}