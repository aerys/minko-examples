package aerys.minko.example.core.celshading
{
	import aerys.minko.render.effect.basic.BasicShader;
	import aerys.minko.render.shader.SFloat;
	import aerys.minko.render.shader.Shader;
	import aerys.minko.type.math.Vector4;
	
	public class CelShadingShader extends BasicShader
	{
		private static const NUM_LEVELS					: uint		= 6;
		
		private static const DEFAULT_THICKNESS			: Number	= 0.04;
		private static const DEFAULT_AMBIENT			: Number	= .2;
		private static const DEFAULT_LIGHT_DIRECTION	: Vector4	= new Vector4(1., -1., 0.);
		private static const DEFAULT_DIFFUSE_COLOR		: Vector4	= new Vector4(1., 1., 1., 1.);
		
		private var _isEdge	: SFloat	= null;
		
		override protected function getVertexPosition() : SFloat
		{
			var eyeToVertex : SFloat = normalize(subtract(
				multiply4x4(vertexXYZ, localToWorldMatrix),
				cameraPosition
			));
			
			_isEdge = lessThan(
				-0.05,
				dotProduct3(vertexNormal, eyeToVertex)
			);
			
			var thickness : SFloat	= meshBindings.getParameter('thickness', 1);
			var delta : SFloat = multiply(_isEdge, vertexNormal.xyz, thickness);
			
			var pos : SFloat = multiply4x4(
				add(vertexXYZ, float4(delta, 0)),
				localToWorldMatrix
			);
			
			// WORKAROUND
			_isEdge = float4(_isEdge.x, _isEdge.x, _isEdge.x, _isEdge.x);
			// !WORKAROUND
				
			return multiply4x4(pos, worldToScreenMatrix);
		}
		
		override protected function getPixelColor() : SFloat
		{
			var vertexNormal : SFloat = normalize(interpolate(vertexNormal));
			var lightDirection : SFloat = sceneBindings.getParameter("lightDirection", 3);
			
			lightDirection.normalize();
			
			// diffuse lighting
			var lambertFactor : SFloat = saturate(
				negate(dotProduct3(lightDirection, vertexNormal))
			);
			
			// cel shading
			lambertFactor = multiply(lambertFactor, NUM_LEVELS);
			lambertFactor = subtract(lambertFactor, fractional(lambertFactor));
			lambertFactor = divide(lambertFactor, NUM_LEVELS);
			
			// ambient lighting
			var ambient	: SFloat = sceneBindings.getParameter("lightAmbient", 1);
			
			lambertFactor.incrementBy(ambient);
			
			var diffuseColor 	: SFloat	= super.diffuse.getDiffuse();
			var lightColor 		: SFloat 	= sceneBindings.getParameter("lightDiffuseColor", 3);
			
			// outline
			var outline : SFloat = lessThan(interpolate(_isEdge).x, 0.1);
			
			lambertFactor.scaleBy(outline);
			
			return float4(
				multiply(diffuseColor.rgb, lightColor, lambertFactor),
				diffuseColor.a
			);
		}
	}
}