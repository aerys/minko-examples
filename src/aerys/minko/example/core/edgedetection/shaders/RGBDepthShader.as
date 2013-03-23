package aerys.minko.example.core.edgedetection.shaders 
{
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.shader.SFloat;

	public class RGBDepthShader extends InverseExponentialZBufferShader 
	{
		public function RGBDepthShader(	target		: RenderTarget	= null,
										priority	: Number		= 0.,
										exponant 	: int 			= -8)
		{
			super(target, priority, exponant);
		}
		
		override protected function getPixelColor() : SFloat
		{
			return rgb(getDepth());
		}
		
		protected function rgb(t : SFloat) : SFloat 
		{
			t = clamp(t, 0., 1.);
			//b -> c
			var rgb : SFloat = float3(0., multiply( 4., subtract(t, 0.25)), 1.);
			//c -> g
			var cg : SFloat = greaterEqual( t , 0.25);
			rgb.g = ternary( cg , float(1.) , rgb.g );
			rgb.b = ternary( cg , subtract(1, multiply(4., subtract(t, 0.25))) , rgb.b);
			// g -> y
			var gy : SFloat = greaterEqual( t , 0.5);
			rgb.r = ternary( gy , multiply( 4. , subtract( t , 0.5 )), rgb.r);
			rgb.g = ternary( gy , float(1.), rgb.g);
			rgb.b = ternary( gy , float(0.), rgb.b);
			// y -> r
			var yr : SFloat = greaterEqual( t , 0.75);
			rgb.r = ternary( yr , float(1.), rgb.r);
			rgb.g = ternary( yr , subtract(1, multiply(4., subtract( t, 0.75 ))), rgb.g);
			return rgb;
		}
		
	}
}