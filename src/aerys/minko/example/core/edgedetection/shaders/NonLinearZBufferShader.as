package aerys.minko.example.core.edgedetection.shaders 
{
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.material.basic.BasicShader;
	import aerys.minko.render.shader.SFloat;
	
	/**
	 * This shader increases the depth details of objects closed to the camera
	 */
	
	public class NonLinearZBufferShader extends BasicShader 
	{
		public function NonLinearZBufferShader(	target		: RenderTarget	= null,
										   		priority	: Number		= 0.) 
		{
			super(target, priority);
		}
		
		override protected function getPixelColor() : SFloat 
		{
			var eyeToVertex : SFloat = length(subtract(localToWorld(interpolate(vertexXYZ)).xyz,cameraPosition.xyz));
			var a 		: SFloat = divide(cameraZFar, subtract(cameraZFar, cameraZNear));
			var b 		: SFloat = divide(multiply(cameraZFar, cameraZNear), subtract(cameraZNear, cameraZFar));
			var _depth 	: SFloat = add(a, divide(b, eyeToVertex));
			return pack(_depth);
		}
		
	}
}