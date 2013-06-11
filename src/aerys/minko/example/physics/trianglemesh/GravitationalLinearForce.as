package aerys.minko.example.physics.trianglemesh
{
	import flash.geom.Vector3D;
	
	import aerys.minko.physics.collider.Collider;
	import aerys.minko.physics.constraint.force.IForceGenerator;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.type.math.Matrix4x4;
	import aerys.minko.type.math.Ray;
	import aerys.minko.type.math.Vector4;
	
	// http://www.gamasutra.com/view/feature/131997/games_demystified_super_mario_.php
	public final class GravitationalLinearForce implements IForceGenerator
	{
		private static var TMP_VECTOR	: Vector4		= new Vector4();
		private static var TMP_NORMAL	: Vector4		= new Vector4();
		private var _planet				: Mesh			= null;
		private var _planetTransform	: Matrix4x4		= new Matrix4x4();
		private var _planetCenter		: Vector4		= new Vector4();
		
		public function GravitationalLinearForce(aPlanet : Mesh = null)
		{
			this.planet = aPlanet;
		}
		
		public function get planet():Mesh
		{
			return _planet;
		}

		public function set planet(value:Mesh):void
		{
			_planet = value;
			_planet.getWorldToLocalTransform(true, _planetTransform);
			_planet.getLocalToWorldTransform().transformVector(_planet.geometry.boundingSphere.center, _planetCenter);
		}

		public function generateLinearForceMultipliers(collider:Collider):Vector3D
		{
			var colliderCenter		: Vector4			= new Vector4(collider.center.x, collider.center.y, collider.center.z);
			var rayDir				: Vector4			= Vector4.subtract(_planetCenter, colliderCenter).normalize();
			var ray					: Ray				= new Ray(colliderCenter, rayDir);
			var triangleId			: int				= -1;
			
			triangleId = _planet.geometry.cast(ray, _planetTransform, TMP_VECTOR, null, TMP_NORMAL);
			
			// We retry with a random deviant of the vector
			if (triangleId == -1)
			{
				ray = new Ray(colliderCenter, randomDeviantVector4(ray.direction, Math.PI * 0.125));
				triangleId = _planet.geometry.cast(ray, _planetTransform, TMP_VECTOR, null, TMP_NORMAL);
			}
			
			// In the best cases, this shouldn't happen, but it's the best cheap fallback we can use.
			if (triangleId == -1)
			{
				return rayDir.scaleBy(9.81).toVector3D();
			}

			return TMP_NORMAL.scaleBy(-9.81).toVector3D();
		}
		
		public function generateTorqueForceMultipliers(collider:Collider):Vector3D
		{
			return null;
		}
		
		private function randomDeviantVector4(v : Vector4, angle : Number, up : Vector4 = null) : Vector4
		{
			if (up == null)
			{
				up = Vector4.crossProduct(v, Vector4.X_AXIS);
				if (up.lengthSquared < Number.MIN_VALUE * Number.MIN_VALUE)
				{
					up = Vector4.crossProduct(v, Vector4.Y_AXIS);
				}
				up.normalize();
			}
			up = new Matrix4x4().appendRotation(Math.random() * (Math.PI * 2), v).deltaTransformVector(up);
			
			return new Matrix4x4().appendRotation(angle, up).deltaTransformVector(v);
		}
	}
}