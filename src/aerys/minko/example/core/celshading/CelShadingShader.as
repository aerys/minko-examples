package aerys.minko.example.core.celshading
{
	import aerys.minko.render.shader.ActionScriptShader;
	import aerys.minko.render.shader.SValue;
	import aerys.minko.type.math.ConstVector4;
	
	public class CelShadingShader extends ActionScriptShader
	{
		private static const NUM_LEVELS					: uint			= 6;
		
		private static const DEFAULT_THICKNESS			: Number		= 0.04;
		private static const DEFAULT_AMBIENT			: Number		= .2;
		private static const DEFAULT_LIGHT_DIRECTION	: ConstVector4	= new ConstVector4(1., -1., 0.);
		private static const DEFAULT_DIFFUSE_COLOR		: ConstVector4	= new ConstVector4(1., 1., 1., 1.);
		
		private var _isEdge	: SValue	= null;
		
		override protected function getOutputPosition() : SValue
		{
			var eyeToVertex : SValue = normalize(subtract(vertexPosition, cameraLocalPosition));
			
			_isEdge = lessThan(
				-0.05,
				dotProduct3(vertexNormal, eyeToVertex)
			);
			
			var thickness : SValue	= getNamedParameter("thickness", DEFAULT_THICKNESS);
			var delta : SValue = multiply(_isEdge, vertexNormal.xyz, thickness);
			
			return multiply4x4(
				add(vertexPosition, float4(delta, 0)),
				localToScreenMatrix
			);
		}
		
		override protected function getOutputColor() : SValue
		{
			var vertexNormal : SValue = normalize(interpolate(vertexNormal));
			var lightDirection : SValue = getNamedParameter(
				"light direction",
				DEFAULT_LIGHT_DIRECTION
			);
			
			lightDirection.normalize();
			
			// diffuse lighting
			var lambertFactor : SValue = saturate(
				negate(dotProduct3(lightDirection, vertexNormal))
			);
			
			// cel shading
			lambertFactor = multiply(lambertFactor, NUM_LEVELS);
			lambertFactor = subtract(lambertFactor, fractional(lambertFactor));
			lambertFactor = divide(lambertFactor, NUM_LEVELS);
			
			// ambient lighting
			var ambient	: SValue = getNamedParameter(
				"ambient",
				DEFAULT_AMBIENT
			);
			
			lambertFactor.incrementBy(ambient);
			
			var diffuseColor : SValue = getNamedParameter(
				"diffuse color",
				DEFAULT_DIFFUSE_COLOR
			);
			
			// outline
			var outline : SValue = lessThan(interpolate(_isEdge), 0.1);
			
			lambertFactor.scaleBy(outline);
			
			return float4(
				multiply(diffuseColor.rgb, lambertFactor),
				diffuseColor.a
			);
		}
	}
}