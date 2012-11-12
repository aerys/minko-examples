package aerys.minko.example.core.vertexattributes
{
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.geometry.stream.format.VertexComponent;
	import aerys.minko.render.shader.SFloat;
	import aerys.minko.render.shader.Shader;
	import aerys.minko.render.shader.part.phong.LightAwareDiffuseShaderPart;
	import aerys.minko.render.shader.part.phong.PhongShaderPart;
	
	public class ShatterShader extends Shader
	{
		private var _diffuse	: LightAwareDiffuseShaderPart;
		private var _phong		: PhongShaderPart;
		
		public function ShatterShader(renderTarget : RenderTarget = null, priority : Number = .0) : void
		{
			super(renderTarget, priority);
			_diffuse	= new LightAwareDiffuseShaderPart(this);
			_phong		= new PhongShaderPart(this);
		}
		
		// Interpolation function
		private function damping(src : SFloat, dst : SFloat, dt : SFloat, factor : SFloat) : SFloat
		{
			return divide(add(multiply(src, factor), multiply(dst, dt)), add(factor, dt));
		}
		
		protected override function getVertexPosition():SFloat
		{
			// We read the position attribute from a Vertex
			var vertexPosition 	: SFloat 	= getVertexAttribute(VertexComponent.XYZ);
			// Reading a custom VertexAttribute is the same way
			var offset 			: SFloat 	= getVertexAttribute(ShatterVertexComponent.SHATTER_VECTOR);
			// We want to animate the shattering
			var time 			: SFloat 	= multiply(this.time, 0.0005);
			var shift 			: SFloat 	= absolute(max(0.0, cos(add(offset.w, time))));
			
			offset = damping(offset.xyz, float3(0, 0, 0), float(1. / 1.5), shift);
			
			return localToScreen(add(vertexPosition, float4(offset.xyz, 0)));
		}
		
		override protected function getPixelColor() : SFloat
		{
			var color	 : SFloat = _diffuse.getDiffuseColor();
			var lighting : SFloat = _phong.getLightingColor();
			
			color = float4(multiply(lighting, color.rgb), color.a);
			
			return color;
		}
	}
}