package aerys.minko.example.core.vertexattributes
{
	import aerys.minko.render.geometry.stream.format.VertexComponent;
	import aerys.minko.render.geometry.stream.format.VertexComponentType;

	public final class ShatterVertexComponent
	{
		public static const SHATTER_VECTOR		: VertexComponent	= VertexComponent.create(
			['sx', 'sy', 'sz', 'st'],
			VertexComponentType.FLOAT_4
		);
	}
}