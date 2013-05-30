package aerys.minko.example.core.healspellparticles
{
	import aerys.minko.particles.controller.ParticleSystemController;
	import aerys.minko.particles.modifier.init.StartColor;
	import aerys.minko.particles.modifier.init.StartForce;
	import aerys.minko.particles.modifier.init.StartSize;
	import aerys.minko.particles.modifier.init.StartVelocity;
	import aerys.minko.particles.modifier.update.ColorOverTime;
	import aerys.minko.particles.modifier.update.SizeOverTime;
	import aerys.minko.particles.sampler.Constant;
	import aerys.minko.particles.sampler.LinearlyInterpolatedColor;
	import aerys.minko.particles.sampler.LinearlyInterpolatedNumber;
	import aerys.minko.particles.sampler.RandomBetweenColors;
	import aerys.minko.particles.sampler.RandomBetweenConstants;
	import aerys.minko.particles.shape.CylinderEmitterShape;
	import aerys.minko.scene.controller.EnterFrameController;
	import aerys.minko.scene.node.ISceneNode;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.type.loader.TextureLoader;
	
	public class HealSpellParticleController extends ParticleSystemController
	{
		[Embed("../../../../../../assets/particles/heal.png")]
		private static const HEAL_TEXTURE	: Class;
		
		public function HealSpellParticleController()
		{
			var particleRate			: Number				= 300;
			var particleLifeTime		: Constant				= new Constant(1.5);
			var particleEmitterShape	: CylinderEmitterShape	= new CylinderEmitterShape(40, 12, 4);
			
			super(
				particleRate,
				particleLifeTime,
				particleEmitterShape,
				0,
				Constant.SAMPLER_ZERO
			);
			
			//speed			
			add(
				new StartVelocity(
					Constant.SAMPLER_ZERO,
					new RandomBetweenConstants(-20., 0.),
					Constant.SAMPLER_ZERO
				)
			);
			
			add(
				new StartForce(
					new RandomBetweenConstants(-20., 20.),
					new RandomBetweenConstants(-10., -2.),
					new RandomBetweenConstants(-20., 20.)
				)
			);
			
			
			//size
			add(
				new StartSize(
					new RandomBetweenConstants(1.5, 5)
				)
			);
			
			add(
				new SizeOverTime(
					new LinearlyInterpolatedNumber(1, 0.7)
				)
			);
			
			//color
			add(
				new StartColor(
					new RandomBetweenColors(
						0x006619FF,
						0x19FF80FF
					)
				)
			);
			
			add(
				new ColorOverTime(
					new LinearlyInterpolatedColor(
						0x0066B2FF,
						0x000000FF
					)
				)
			);
		}
		
		override protected function targetAddedHandler(ctrl:EnterFrameController, target:ISceneNode):void
		{
			if (!target is Mesh)
				return;
			
			//We make sure the target has the right texture
			Mesh(target).material.setProperty("diffuseMap", TextureLoader.loadClass(HEAL_TEXTURE));
			
			super.targetAddedHandler(ctrl, target);
		}
	}
}