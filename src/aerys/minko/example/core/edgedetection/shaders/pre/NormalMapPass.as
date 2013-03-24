package aerys.minko.example.core.edgedetection.shaders.pre 
{
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.shader.Shader;
	import aerys.minko.render.shader.vertex.VertexNormalShader;
	
	public class NormalMapPass extends AbstractPrePass 
	{
		public function NormalMapPass(	width 			: int = 2048,
										height			: int = 2048,
										backgroundColor : uint = 0xffffffff) 
		{
			super(width, height, backgroundColor);
		}
		
		protected override function initShader(map : RenderTarget) : Shader 
		{
			return new VertexNormalShader(map, 75);
		}
		
	}
}