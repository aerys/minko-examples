package aerys.minko.example.physics.primitive
{
	import aerys.minko.physics.api.ColliderController;
	import aerys.minko.physics.collider.Collider;
	import aerys.minko.physics.shape.description.primitive.BoxShape;
	import aerys.minko.render.geometry.primitive.CubeGeometry;
	import aerys.minko.render.material.basic.BasicMaterial;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.scene.node.light.AmbientLight;
	
	public class PhysicsPrimitiveExample extends AbstractPhysicsExampleApplication
	{
		private static const PORTAL_IN_MATERIAL : BasicMaterial = new BasicMaterial({
			diffuseColor : 0xFFA800FF
		});
		
		private static const PORTAL_OUT_MATERIAL : BasicMaterial = new BasicMaterial({
			diffuseColor : 0x0054FFFF
		});
		
		private static const CEIL_Y : Number = 50;
		
		override protected function initializeScene():void
		{
			super.initializeScene();
			
			scene.addChild(new AmbientLight(0xFFFFFFFF, 1));

			addCeil();
			
			scene.addController(new PhysicsPrimitiveCreationController());
		}
		
		private function addCeil() : void
		{
			var ceil : Mesh = new Mesh(CubeGeometry.cubeGeometry, new BasicMaterial());
			
			ceil.transform.appendScale(100, 1, 100)
				.appendTranslation(0, CEIL_Y, 0);
			
			var ceilGeometry	: BoxShape				= new BoxShape(50, 0.5, 50);
			var ceilCollider	: Collider				= new Collider(ceilGeometry);
			var ceilController	: ColliderController	= new ColliderController(ceilCollider, true, true);
			
			ceil.addController(ceilController);
			
			scene.addChild(ceil);
		}
	
	}
}