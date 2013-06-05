package aerys.minko.example.particles.snowparticles
{
	import aerys.minko.particles.controller.ParticleSystemController;
	import aerys.minko.particles.modifier.init.StartColor;
	import aerys.minko.particles.modifier.init.StartSize;
	import aerys.minko.particles.modifier.init.StartVelocity;
	import aerys.minko.particles.sampler.Constant;
	import aerys.minko.particles.sampler.RandomBetweenColors;
	import aerys.minko.particles.sampler.RandomBetweenConstants;
	import aerys.minko.particles.shape.CylinderEmitterShape;
	import aerys.minko.particles.type.enum.ParticleEmissionDirection;
	import aerys.minko.scene.controller.EnterFrameController;
	import aerys.minko.scene.node.ISceneNode;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.type.loader.TextureLoader;
	
	public class SnowParticleController extends ParticleSystemController
	{
		[Embed("../assets/particles/bubble.png")]
		private static const SNOW_TEXTURE	: Class;
		
		public function SnowParticleController(density : Number = 0.5)
		{
			if (density > 1)
				density = 1;
			if (density < 0)
				density = 0;
			
			var particleRate			: Number				= density * 600;
			var particleLifeTime		: Constant				= new Constant(10);
			var particleEmitterShape	: CylinderEmitterShape	= new CylinderEmitterShape(200, 0, 0); 
				
			super(
				particleRate,
				particleLifeTime,
				particleEmitterShape,
				ParticleEmissionDirection.NONE,
				Constant.SAMPLER_ZERO
			);
			
			//speed			
			add(
				new StartVelocity(
					Constant.SAMPLER_ZERO,
					new RandomBetweenConstants(-3. , 3.),
					new RandomBetweenConstants(10., 22.)
				)
			);
			
			//size
			add(
				new StartSize(
					new RandomBetweenConstants(0.9, 1.5)
				)
			);
			
			//color
			add(
				new StartColor(
					new RandomBetweenColors(
						0xAAAAFFFF,
						0xFFFFFFFF
					)
				)
			);
		}
		
		override protected function targetAddedHandler(ctrl:EnterFrameController, target:ISceneNode):void
		{
			if (!target is Mesh)
				return;
			
			//We make sure the target has the right texture
			Mesh(target).material.setProperty("diffuseMap", TextureLoader.loadClass(SNOW_TEXTURE));
			
			super.targetAddedHandler(ctrl, target);
		}
	}
}