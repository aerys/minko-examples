package aerys.minko.example.core.worldspaceparticles
{
	import aerys.minko.particles.controller.ParticleSystemController;
	import aerys.minko.particles.modifier.init.StartColor;
	import aerys.minko.particles.modifier.init.StartSize;
	import aerys.minko.particles.modifier.update.ColorOverTime;
	import aerys.minko.particles.sampler.Constant;
	import aerys.minko.particles.sampler.ConstantColor;
	import aerys.minko.particles.sampler.LinearlyInterpolatedColor;
	import aerys.minko.particles.sampler.RandomBetweenColors;
	import aerys.minko.particles.sampler.RandomBetweenConstants;
	import aerys.minko.particles.shape.PointEmitterShape;
	import aerys.minko.particles.shape.SphereEmitterShape;
	import aerys.minko.particles.type.enum.ParticleEmissionDirection;
	import aerys.minko.scene.controller.EnterFrameController;
	import aerys.minko.scene.node.ISceneNode;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.type.loader.TextureLoader;
	
	public class WorldParticleController extends ParticleSystemController
	{
		[Embed("../assets/particles/bubble.png")]
		private static const TEXTURE	: Class;
		
		public function WorldParticleController()
		{
			var particleRate			: Number				= 100;
			var particleLifeTime		: Constant				= new Constant(0.5);
			var particleEmitterShape	: SphereEmitterShape	= new SphereEmitterShape(0.1,0); 
			
			super(
				particleRate,
				particleLifeTime,
				particleEmitterShape,
				ParticleEmissionDirection.AWAY_FROM_SOURCE,
				new Constant(6),
				true // particles are in worldSpace
			);
						
			//color
			add(
				new StartColor(
					new ConstantColor(
						0xFF0000FF
					)
				)
			);
			
			add(
				new ColorOverTime(
					new LinearlyInterpolatedColor(
						0xFFFF00FF,
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
			Mesh(target).material.setProperty("diffuseMap", TextureLoader.loadClass(TEXTURE));
			
			super.targetAddedHandler(ctrl, target);
		}
	}
}