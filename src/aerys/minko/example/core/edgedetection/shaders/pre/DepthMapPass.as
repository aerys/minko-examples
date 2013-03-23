package aerys.minko.example.core.edgedetection.shaders.pre 
{
	import aerys.minko.example.core.edgedetection.shaders.NonLinearZBufferShader;
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.shader.Shader;
	
	public class DepthMapPass extends AbstractPrePass 
	{
		public function DepthMapPass( 	width 			: int = 2048,
										height			: int = 2048,
										backgroundColor : uint = 0xffffffff) 
		{
			
			super(width, height, backgroundColor);
		}
		
		protected override function initShader(map : RenderTarget) : Shader 
		{
			return new NonLinearZBufferShader(map);
		}
	}
}