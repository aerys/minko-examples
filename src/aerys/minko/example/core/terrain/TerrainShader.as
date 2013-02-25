package aerys.minko.example.core.terrain
{
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.material.basic.BasicShader;
	import aerys.minko.render.shader.SFloat;
	import aerys.minko.render.shader.part.phong.PhongShaderPart;
	
	public class TerrainShader extends BasicShader
	{
        private var _phong  : PhongShaderPart;
        
		public function TerrainShader(target:RenderTarget=null, priority:Number=0.0)
		{
			super(target, priority);
            
            _phong = new PhongShaderPart(this);
		}
		
		override protected function getPixelColor() : SFloat
		{
			var diffuseMap	: SFloat	= meshBindings.getTextureParameter('diffuseMap');
            
            // splatting
			var uv			: SFloat	= interpolate(float2(0, vertexXYZ.z));
			var diffuse		: SFloat	= sampleTexture(diffuseMap, uv);
			var phong   	: SFloat	= add(_phong.getDynamicLighting(), _phong.getStaticLighting());
			
			return float4(multiply(diffuse.rgb, phong), diffuse.a);
		}
	}
}