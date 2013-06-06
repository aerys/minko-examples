package aerys.minko.example.core.edgedetection.shaders {
	
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.material.basic.BasicShader;
	import aerys.minko.render.shader.SFloat;

	public class InverseExponentialZBufferShader extends BasicShader{
		
		private var exponant : int;
		
		public function InverseExponentialZBufferShader(target		: RenderTarget	= null,
														priority	: Number		= 0.,
														exponant 	: int 			= -8){
			super(target, priority);
			this.exponant = exponant;
		}
		
		override protected function getPixelColor() : SFloat{
			return pack(getDepth());
		}
		
		protected function getDepth() : SFloat {
			var eyeToVertex : SFloat = length(subtract(localToWorld(interpolate(vertexXYZ)).xyz, cameraPosition.xyz));
			var _depth	: SFloat = divide(eyeToVertex, subtract(cameraZFar, cameraZNear));
			return subtract(1, exp(multiply(_depth, exponant)));
		}
		
	}
}