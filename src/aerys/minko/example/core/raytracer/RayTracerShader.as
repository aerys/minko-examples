package aerys.minko.example.core.raytracer
{
	import aerys.minko.render.shader.ActionScriptShader;
	import aerys.minko.render.shader.SValue;
	import aerys.minko.type.enum.Blending;
	
	public final class RayTracerShader extends ActionScriptShader
	{
		private const BACKGROUND_COLOR	: SValue	= float4(0, 0, 0, 1);
		private const PLANE_THICKNESS	: SValue	= float(0.001);
		
		private const TYPE_PLANE		: String	= "plane";
		private const TYPE_SPHERE		: String	= "sphere";
		private const SCENE				: Array		= [
			{
				type:		TYPE_SPHERE,
				position:	float3(0.5, multiply(sin(divide(frameId, 30)), .5), 0),
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
				position:	float3(-0.5, multiply(sin(divide(frameId, 30)), -.5), 0),
				radius:		float(.4),
				color:		float4(0, 1, 0, 1)
			},
			{
				type:		TYPE_PLANE,
				plane:		float4(0, 1, 0, -.5),
				color:		float4(1, 1, 1, 1)
			}
		];
		
		private var _position	: SValue	= null;
		
		override protected function getOutputPosition():SValue
		{
			_position = multiply(vertexPosition, float4(2, 2, 1, 1));
			
			return _position;
		}
		
		override protected function getOutputColor() : SValue
		{
			var p 		: SValue 	= interpolate(_position);
			var o 		: SValue 	= float3(p.xy, 0);
			var r 		: SValue 	= normalize(float3(p.xy, 1));
			var output	: SValue	= BACKGROUND_COLOR;
			
			for each (var object : Object in SCENE)
			{
				var intersect : SValue = null;
				
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
		
		private function intersectPlane(origin		: SValue,
										ray			: SValue,
										plane		: SValue) : SValue
		{
			var d : SValue = dotProduct3(ray, plane.xyz);
			
			d = absolute(subtract(d, plane.w));
			
			return lessThan(d, PLANE_THICKNESS);
		}
		
		private function intersectSphere(origin		: SValue,
										 ray		: SValue,
										 position	: SValue,
										 radius		: SValue) : SValue
		{
			origin = add(origin, position);
			
			var a : SValue = length(ray);
			var b : SValue = multiply(2, dotProduct3(origin, ray));
			var c : SValue = subtract(length(origin), multiply(radius, radius));
			
			// disc = b² - 4ac
			var disc : SValue = subtract(multiply(b, b), multiply(4, a, c));
			var discSqrt : SValue = sqrt(disc);
			
			// if (b < 0) q = (-b - distSqrt) / 2.0
			var q : SValue = divide(add(b, discSqrt), -2.0);
			
			// else q = (-b + distSqrt) / 2.0;
			q.incrementBy(
				multiply(greaterEqual(b, 0), discSqrt)
			);
			
			var t0 : SValue = divide(q, a);
			var t1 : SValue = divide(c, q);
			var tmp : SValue = t0;
			
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