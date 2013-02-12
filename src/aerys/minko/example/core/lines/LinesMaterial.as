package aerys.minko.example.core.lines
{
	import aerys.minko.render.Effect;
	import aerys.minko.render.material.Material;
	import aerys.minko.render.material.basic.BasicProperties;
	
	public class LinesMaterial extends Material
	{
		public function get diffuseColor() : Object
		{
			return getProperty(BasicProperties.DIFFUSE_COLOR);
		}
		public function set diffuseColor(value : Object) : void
		{
			setProperty(BasicProperties.DIFFUSE_COLOR, value);
		}
		
		public function get thickness() : Number
		{
			return getProperty('lineThickness');
		}
		public function set thickness(value : Number) : void
		{
			setProperty('lineThickness', value);
		}
		
		public function LinesMaterial(properties	: Object	= null,
									  name			: String	= null)
		{
			super(new Effect(new LinesShader()), properties, name);
		}
	}
}