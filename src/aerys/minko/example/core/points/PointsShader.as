package aerys.minko.example.core.points
{
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.effect.basic.BasicShader;
	import aerys.minko.render.shader.SFloat;
	
	public class PointsShader extends BasicShader
	{
		public function PointsShader(target : RenderTarget = null, priority : Number = 0.0)
		{
			super(target, priority);
		}
		
		override protected function getVertexPosition() : SFloat
		{
			var pointsCount : uint 		= meshBindings.getConstant('pointsCount');
			var positions 	: SFloat 	= meshBindings.getParameter('pointsPositions', pointsCount * 3);
			var position 	: SFloat 	= getFieldFromArray(vertexId.x, positions);
//			var pointSize 	: SFloat 	= meshBindings.getParameter('pointsSize', 1);
			var pointSize 	: SFloat 	= float(0.1);
			var corner 		: SFloat 	= multiply(vertexXY, float4(pointSize.xx, 0, 0));
			
			position = localToView(float4(position.xyz, 1));
			position = add(position, corner);
			
			return multiply4x4(position, projectionMatrix);
		}
		
		override protected function getPixelColor() : SFloat
		{
			return meshBindings.getParameter('diffuseColor', 4);
		}
	}
}