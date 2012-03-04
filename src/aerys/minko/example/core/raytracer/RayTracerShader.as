package aerys.minko.example.core.raytracer
{
	import aerys.minko.render.shader.ActionScriptShader;
	import aerys.minko.render.shader.SFloat;
	import aerys.minko.type.enum.Blending;
	
	public final class RayTracerShader extends ActionScriptShader
	{
		private const BACKGROUND_COLOR	: SFloat	= float4(0, 0, 0, 1);
		private const PLANE_THICKNESS	: SFloat	= float(0.001);
		
		private const TYPE_PLANE		: String	= "plane";
		private const TYPE_SPHERE		: String	= "sphere";
		private const SCENE				: Array		= [
			{
				type:		TYPE_SPHERE,
				position:	float3(0.5, multiply(sin(divide(time, 30)), .5), 0),
				radius:		float(.5),
				color:		float4(0, 0, 1, 1)
			},
			/*{
				type:		TYPE_SPHERE,
				position:	float3(0, multiply(sin(divide(frameId, 30)), .25), 0),
				radius:		float(.2),
				color:		float4(1, 0, 0, 1)
			},*/
			{
				type:		TYPE_SPHERE,
				position:	float3(-0.5, multiply(sin(divide(time, 30)), -.5), 0),
				radius:		float(.4),
				color:		float4(0, 1, 0, 1)
			},
			{
				type:		TYPE_PLANE,
				plane:		float4(0, 1, 0, -.5),
				color:		float4(1, 1, 1, 1)
			}
		];
		
		private var _position	: SFloat	= null;
		
		override protected function getVertexPosition():SFloat
		{
			_position = multiply(vertexXYZ, float4(2, 2, 1, 1));
			
			return _position;
		}
		
		override protected function getPixelColor() : SFloat
		{
			var p 		: SFloat 	= interpolate(_position);
			var o 		: SFloat 	= float3(p.xy, 0);
			var r 		: SFloat 	= normalize(float3(p.xy, 1));
			var output	: SFloat	= BACKGROUND_COLOR;
			
			for each (var object : Object in SCENE)
			{
				var intersect : SFloat = null;
				
				switch (object.type)
				{
					case TYPE_PLANE :
						intersect = intersectPlane(o, r, object.plane);
						break ;
					case TYPE_SPHERE :
						intersect = intersectSphere(o, r, object.position, object.radius);
						break ;
				}
				
				output = blend(
					multiply(intersect, object.color),
					output,
					Blending.ALPHA
				);
			}
			
			return output;
		}
		
		private function intersectPlane(origin		: SFloat,
										ray			: SFloat,
										plane		: SFloat) : SFloat
		{
			var d : SFloat = dotProduct3(ray, plane.xyz);
			
			d = absolute(subtract(d, plane.w));
			
			return lessThan(d, PLANE_THICKNESS);
		}
		
		private function intersectSphere(origin		: SFloat,
										 ray		: SFloat,
										 position	: SFloat,
										 radius		: SFloat) : SFloat
		{
			origin = add(origin, position);
			
			var a : SFloat = length(ray);
			var b : SFloat = multiply(2, dotProduct3(origin, ray));
			var c : SFloat = subtract(length(origin), multiply(radius, radius));
			
			// disc = b² - 4ac
			var disc : SFloat = subtract(multiply(b, b), multiply(4, a, c));
			var discSqrt : SFloat = sqrt(disc);
			
			// if (b < 0) q = (-b - distSqrt) / 2.0
			var q : SFloat = divide(add(b, discSqrt), -2.0);
			
			// else q = (-b + distSqrt) / 2.0;
			q.incrementBy(
				multiply(greaterEqual(b, 0), discSqrt)
			);
			
			var t0 : SFloat = divide(q, a);
			var t1 : SFloat = divide(c, q);
			var tmp : SFloat = t0;
			
			// make sure t0 is smaller than t1
			t0 = min(t0, t1);
			t1 = max(tmp, t1);
			
			return multiply(
				// if (disc < 0) return false
				greaterEqual(disc, 0),
				// if t1 is less than zero, the object is in the ray's negative direction
				// and consequently the ray misses the sphere
				greaterEqual(t1, 0)
			);
		}
	}
}