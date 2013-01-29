package aerys.minko.example.core.sound // Ideal package name would be aerys.minko.scene.controller.sound
{
	import aerys.minko.scene.controller.AbstractScriptController;
	import aerys.minko.scene.node.ISceneNode;
	import aerys.minko.scene.node.Scene;
	import aerys.minko.scene.node.camera.AbstractCamera;
	import aerys.minko.type.math.Vector4;
	
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	public class SoundController extends AbstractScriptController
	{
		private var _loop					: Boolean			= true;
		private var _transform				: SoundTransform	= null;
		private var _channel				: SoundChannel		= null;
		private var _sound					: Sound				= null;
		private var _audibilityCurve		: Function			= null;

		public function get loop() : Boolean
		{
			return _loop;
		}

		public function set loop(value : Boolean) : void
		{
			_loop = value;
		}

		public function get transform() : SoundTransform
		{
			return _transform;
		}

		public function set transform(value : SoundTransform) : void
		{
			_transform = value;
		}

		public function get channel() : SoundChannel
		{
			return _channel;
		}

		public function set channel(value : SoundChannel) : void
		{
			_channel = value;
		}

		public function get sound() : Sound
		{
			return _sound;
		}

		public function set sound(value : Sound) : void
		{
			_sound = value;
		}

		public function get audibilityCurve() : Function
		{
			return _audibilityCurve;
		}
		
		public function set audibilityCurve(value : Function) : void
		{
			_audibilityCurve = value != null ? value : defaultAubibilityCurve;
		}

		public function SoundController(sound : Sound)
		{
			// We'll start the sound with the target of the controller is added.
			_sound = sound;
			
			// The default audibility curve is linear. You can change that.
			_audibilityCurve = defaultAubibilityCurve;
		}
		
		private function defaultAubibilityCurve(distance : Number) : Number
		{
			return 10 / (4 * Math.PI * distance);
		}
		
		protected override function targetAddedToScene(target : ISceneNode, scene : Scene) : void
		{
			super.targetAddedToScene(target, scene);
			
			// Play the sound.
			_channel = _sound.play(0, _loop ? int.MAX_VALUE : 1);
			_transform = _channel.soundTransform;
			
			// Update the left/right volumes immediately.
			update(target);
		}
		
		protected override function targetRemovedFromScene(target : ISceneNode, scene : Scene) : void
		{
			super.targetRemovedFromScene(target, scene);

			// Stop the sound when removed.
			_channel.stop();
		}
		
		protected override function update(target : ISceneNode) : void
		{
			super.update(target);
			
			// To compute the 3D volume, we need:
			// - the camera position in world space
			var camera		: AbstractCamera	= target.scene.activeCamera;
			var cameraPos	: Vector4			= camera.transform.getTranslation();
			// - the target in world space
			var targetPos	: Vector4			= target.transform.getTranslation();
			// - the distance betwen the camera and the target
			var direction	: Vector4			= cameraPos.decrementBy(targetPos);
			var distance	: Number			= direction.length;
			// - the direction the camera is looking to
			var front		: Vector4			= camera.localToWorld(Vector4.Z_AXIS);

			// Normalize vectors to use the dot product operation.
			front.scaleBy(-1).normalize();
			direction.normalize();
			
			// You can get the angle between the camera direction and the target with: 
			// Math.acos(Vector4.dotProduct(front, direction));

			// We need a vector to orient the angle so it can be signed.
			var orientation	: Vector4			= Vector4.crossProduct(Vector4.UP, front);
			// Now we can get a signed scaled angle between [-1 ; 1] with a dot product.
			var angle		: Number			= Vector4.dotProduct(orientation, direction);

			// The volume is computed based on the distance.
			var volume		: Number			= audibilityCurve(distance);

			// Simply adjust left/right volumes based on the angle.
			var left		: Number			= (angle + 1) / 2;
			var right		: Number			= (1 - angle) / 2;

			// Update the sound transforms.
			_transform.leftToLeft = left;
			_transform.rightToLeft = left;
			_transform.leftToRight = right;
			_transform.rightToRight = right;
			_transform.volume = volume;
			
			_channel.soundTransform = _transform;
		}
	}
}