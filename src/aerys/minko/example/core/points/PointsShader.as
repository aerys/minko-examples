package aerys.minko.example.core.points
{
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.geometry.stream.format.VertexComponent;
	import aerys.minko.render.geometry.stream.format.VertexComponentType;
	import aerys.minko.render.geometry.stream.format.VertexFormat;
	import aerys.minko.render.shader.SFloat;
	import aerys.minko.render.shader.Shader;
	import aerys.minko.render.shader.ShaderSettings;
	import aerys.minko.type.enum.Blending;
	import aerys.minko.type.enum.DepthTest;
	import aerys.minko.type.enum.TriangleCulling;
	
	public class PointsShader extends Shader
	{
		public static const POINT_OFFSET	: VertexComponent	= new VertexComponent(
			['phase', 'speed'],
			VertexComponentType.FLOAT_2
		);
		public static const POINT_DATA		: VertexComponent	= new VertexComponent(
			['offsetX', 'offsetY'],
			VertexComponentType.FLOAT_2
		);
		
		public static const VERTEX_FORMAT	: VertexFormat	= new VertexFormat(
			POINT_DATA,
			POINT_OFFSET,
			VertexComponent.XYZ,
			VertexComponent.RGB
		);
		
		private static const TIMESCALE	: Number	= 0.30;
		
		private var _varColor	: SFloat	= null;
		private var _shiftColor	: SFloat	= null;
		
		public function PointsShader(target : RenderTarget = null, priority : Number = 0.0)
		{
			super(target, priority);
		}
		
		override protected function initializeSettings(settings:ShaderSettings):void
		{
			super.initializeSettings(settings);
			
			settings.triangleCulling = TriangleCulling.NONE;
			settings.blending = Blending.ADDITIVE;
			settings.depthWriteEnabled = false;
			settings.depthTest = DepthTest.ALWAYS;
		}
		
		override protected function getVertexPosition() : SFloat
		{
			var time 		: SFloat 	= multiply(this.time, 0.001, TIMESCALE);
			var uv 			: SFloat 	= getVertexAttribute(POINT_DATA).xy;
			var shift		: SFloat	= cos(add(multiply(time, uv.y), uv.x));
			
			_varColor = vertexRGBColor;
			_shiftColor = multiply(
				min(1, add(6, multiply(5.75, shift))),
				min(1, subtract(multiply(2, time), uv.x))
			);
			
			var pointSize	: SFloat	= meshBindings.getParameter('pointSize', 1);
			var position 	: SFloat 	= getVertexAttribute(VertexComponent.XYZ);
			var corner 		: SFloat 	= multiply(
				getVertexAttribute(POINT_OFFSET),
				float4(pointSize.xx, 0, 0)
			);
			
			position = add(position, float4(0, power(multiply(shift, 0.1), 1.5), 0, 0));
			
			position = localToView(position);
			position.incrementBy(corner);
			
			return multiply4x4(position, projectionMatrix);
		}
		
		override protected function getPixelColor() : SFloat
		{
			var xy : SFloat = interpolate(getVertexAttribute(POINT_OFFSET).xy);
			var d : SFloat = dotProduct2(xy, xy);
			
			d = subtract(1, multiply(d, 4));
			
			kill(subtract(d, .2));
			
			var c : SFloat = interpolate(_varColor);
			
			c.scaleBy(power(d, 3));
			c.incrementBy(multiply(0.5, power(d, 20)));
			c.scaleBy(interpolate(_shiftColor));
			
			return c;
		}
	}
}