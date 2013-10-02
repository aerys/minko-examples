package aerys.minko.example.core.blendingeffect_
{
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.geometry.stream.format.VertexComponent;
	import aerys.minko.render.material.basic.BasicShader;
	import aerys.minko.render.shader.SFloat;
	
	public class BlendingShader extends BasicShader
	{
		public function BlendingShader(renderTarget:RenderTarget=null, priority:Number=0.0)
		{
			super(renderTarget, priority);
		}
		
		override protected function getPixelColor():SFloat
		{
			var refresh : SFloat 	= meshBindings.getParameter("refresh", 1, 0);
			var fadeMap	: SFloat	= meshBindings.getTextureParameter("fadeMap");
			var uv 		: SFloat 	= interpolate(getVertexAttribute(VertexComponent.UV));
			var color 	: SFloat 	= meshBindings.getParameter("diffuseColor", 4);
			var alphaV	: SFloat 	= sampleTexture(fadeMap, uv)
			
			var a : SFloat = divide(-1, multiply(alphaV, refresh));
			
			color.a = add(multiply(a, modulo(time, refresh)), 1);
			
			return color;
		}
	}
}