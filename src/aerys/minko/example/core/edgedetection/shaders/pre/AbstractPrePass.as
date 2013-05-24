package aerys.minko.example.core.edgedetection.shaders.pre {
	
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.resource.texture.TextureResource;
	import aerys.minko.render.shader.Shader;
	
	public class AbstractPrePass {
		
		private var _map	: RenderTarget	= null;
		private var _pass	: Shader		= null;
		
		public function AbstractPrePass(	width 			: int 		= 2048,
											height			: int 		= 2048,
											backgroundColor : uint 		= 0xffffffff ) {
			_map = new RenderTarget(
					width,
					height,
					new TextureResource(width, height),
					0,
					backgroundColor
			);
			_pass = initShader( _map );
		}
		
		protected function initShader( map	: RenderTarget ) : Shader {
			throw new Error("NotYetImplemented");
		}
		
		public function get pass() : Shader {	
			return _pass;
		}
		
		public function get map() : RenderTarget {
			return _map;
		}
	}
}