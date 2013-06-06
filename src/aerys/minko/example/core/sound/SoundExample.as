package aerys.minko.example.core.sound
{
	import flash.media.Sound;
	
	import aerys.minko.render.geometry.primitive.CubeGeometry;
	import aerys.minko.render.material.phong.PhongMaterial;
	import aerys.minko.scene.controller.animation.AnimationController;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.scene.node.light.AmbientLight;
	import aerys.minko.scene.node.light.DirectionalLight;
	import aerys.minko.type.animation.timeline.ITimeline;
	import aerys.minko.type.animation.timeline.MatrixTimeline;
	import aerys.minko.type.math.Matrix4x4;
	import aerys.minko.type.math.Vector4;
	
	public class SoundExample extends AbstractExampleApplication
	{
		[Embed(source="../assets/sound/breakbeat.mp3")]
		private static var SOUND			: Class;
		
		override protected function initializeScene() : void
		{
			super.initializeScene();

			// Add a mesh to the scene (it'll be our sound emitter).
			var mesh				: Mesh				= new Mesh(
				CubeGeometry.cubeGeometry,
				new PhongMaterial({ diffuseColor: int(Math.random() * int.MAX_VALUE) })
			);
			
			scene.addChild(mesh);

			// Add a sound controller to the mesh.
			var sound				: Sound				= new SOUND as Sound;
			var soundController		: SoundController	= new SoundController(sound);

			mesh.addController(soundController);

			// Make the mesh move using a simple animation controller.
			var time				: Vector.<uint> = new <uint>[0, 2000, 4000];
			
			var transforms			: Vector.<Matrix4x4>	= new <Matrix4x4>[
				new Matrix4x4().appendTranslation(-5),
				new Matrix4x4().appendTranslation(+5),
				new Matrix4x4().appendTranslation(-5)
			];
			
			var animationController	: AnimationController	= new AnimationController(new <ITimeline>[
				new MatrixTimeline('transform', time, transforms, true)
			]);

			mesh.addController(animationController);
			
			initializeLights();
		}

		protected function initializeLights() : void
		{
			var ambientLight		: AmbientLight		= new AmbientLight(0xffffffff, 0.6);
			scene.addChild(ambientLight);
			
			var directionalLight	: DirectionalLight	= new DirectionalLight();
			directionalLight.transform.lookAt(Vector4.Z_AXIS, Vector4.ZERO);			
			scene.addChild(directionalLight);

		}
	}
}