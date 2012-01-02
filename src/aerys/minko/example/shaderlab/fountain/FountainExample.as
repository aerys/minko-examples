package aerys.minko.example.shaderlab.fountain
{
	import aerys.minko.render.effect.AbstractSinglePassEffect;
	import aerys.minko.render.shader.IShader;
	import aerys.minko.scene.node.group.LoaderGroup;
	import aerys.minko.scene.node.group.MaterialGroup;
	import aerys.minko.scene.node.group.TransformGroup;
	import aerys.minko.scene.node.mesh.primitive.ParticlesMesh;
	import aerys.minko.type.math.ConstVector4;
	import aerys.minko.types.parser.MKParser;
	
	import flash.events.Event;
	import flash.net.URLRequest;

	public class FountainExample extends MinkoExampleApplication
	{
		private static const NUM_PARTICLES	: uint	= 100;
		private static const NUM_STREAMS	: uint	= 10;
		
		override protected function initializeScene():void
		{
			LoaderGroup.registerParser("mk", MKParser);
			
			var fountain : LoaderGroup = new LoaderGroup();
			
			fountain.load(new URLRequest("../assets/materials/fountain.mk"))
					.addEventListener(Event.COMPLETE, materialLoadedHandler);
			
			scene.addChild(fountain);
		}
	
		private function materialLoadedHandler(event : Event) : void
		{
			var particles : ParticlesMesh = new ParticlesMesh(NUM_PARTICLES);
			var mat : MaterialGroup = MaterialGroup(event.target[0]);
			var shader : IShader = AbstractSinglePassEffect(mat.effect).shader;

			shader.setNamedParameter("num particles", NUM_PARTICLES);
			
			for (var i : int = 0; i < NUM_STREAMS; ++i)
			{
				var tg : TransformGroup = new TransformGroup(particles);
		
				tg.transform
					.appendRotation(Math.PI * 2 * i / NUM_STREAMS, ConstVector4.Y_AXIS);
				mat.addChild(tg);
			}
		}
	}
}