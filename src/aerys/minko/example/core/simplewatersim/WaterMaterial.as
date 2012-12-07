package aerys.minko.example.core.simplewatersim
{
	import aerys.minko.render.Effect;
	import aerys.minko.render.material.basic.BasicMaterial;
	import aerys.minko.render.resource.texture.ITextureResource;
	import aerys.minko.type.math.Vector4;
	
	/**
	 * ...
	 * @author sindney
	 */
	public class WaterMaterial extends BasicMaterial {
		
		private static const DEFAULT_NAME	: String	= 'WaterMaterial';
		private static const DEFAULT_EFFECT	: Effect	= new Effect(new WaterShader());
		
		public function get timer() : Number
		{
			return getProperty(WaterMaterialProperties.TIMER) as Number;
		}
		public function set timer(value : Number) : void
		{
			setProperty(WaterMaterialProperties.TIMER, value);
		}
		
		public function get size() : Number
		{
			return getProperty(WaterMaterialProperties.SIZE) as Number;
		}
		public function set size(value : Number) : void
		{
			setProperty(WaterMaterialProperties.SIZE, value);
		}
		
		public function get heightMap() : ITextureResource
		{
			return getProperty(WaterMaterialProperties.HEIGHT_MAP) as ITextureResource;
		}
		public function set heightMap(value : ITextureResource) : void
		{
			setProperty(WaterMaterialProperties.HEIGHT_MAP, value);
		}
		
		public function get environmentMap() : ITextureResource
		{
			return getProperty(WaterMaterialProperties.ENVIRONMENT_MAP) as ITextureResource;
		}
		public function set environmentMap(value : ITextureResource) : void
		{
			setProperty(WaterMaterialProperties.ENVIRONMENT_MAP, value);
		}
		
		public function get reflectivity() : Number
		{
			return getProperty(WaterMaterialProperties.REFLECTIVITY) as Number;
		}
		public function set reflectivity(value : Number) : void
		{
			setProperty(WaterMaterialProperties.REFLECTIVITY, value);
		}
		
		public function get magnitude() : Number
		{
			return getProperty(WaterMaterialProperties.MAGNITUDE) as Number;
		}
		public function set magnitude(value : Number) : void
		{
			setProperty(WaterMaterialProperties.MAGNITUDE, value);
		}
		
		public function get lightDirection() : Vector4
		{
			return getProperty(WaterMaterialProperties.LIGHT_DIRECTION);
		}
		public function set lightDirection(value : Vector4) : void
		{
			setProperty(WaterMaterialProperties.LIGHT_DIRECTION, value);
		}
		
		public function WaterMaterial(properties:Object = null, effect:Effect = null, name:String = DEFAULT_NAME) {
			super(properties, effect || DEFAULT_EFFECT, name);
		}
		
	}

}