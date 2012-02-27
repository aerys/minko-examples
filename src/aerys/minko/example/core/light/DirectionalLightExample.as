package aerys.minko.example.core.light
{
	import aerys.minko.render.effect.Effect;
	import aerys.minko.scene.node.mesh.primitive.TeapotMesh;
	import aerys.minko.type.math.Matrix4x4;
	import aerys.minko.type.math.Vector4;
	
	import flash.events.Event;

	public class DirectionalLightExample extends MinkoExampleApplication
	{
		protected var _matrix	: Matrix4x4	= new Matrix4x4();
		
		override protected function initializeScene() : void
		{
			cameraController.setPivot(0, 1.3, 0);
			
			scene.addChild(
				new TeapotMesh(new Effect(new DirectionalLightShader()))
			);
			
			scene.bindings.setProperties({
				"light color" 	: 0xffffffff,
				"ambient"		: .2
			});
		}
		
		override protected function enterFrameHandler(event:Event):void
		{
			_matrix.appendRotation(.05, Vector4.Y_AXIS);
			scene.bindings.setProperty(
				"light direction",
				_matrix.transformVector(Vector4.ONE)
			);
			
			super.enterFrameHandler(event);
		}
	}
}