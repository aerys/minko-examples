package aerys.minko.example.core.celshading
{
	import aerys.minko.render.effect.Effect;
	import aerys.minko.scene.node.mesh.Mesh;
	import aerys.minko.scene.node.mesh.geometry.primitive.TeapotGeometry;
	import aerys.minko.type.math.Matrix4x4;
	import aerys.minko.type.math.Vector4;
	
	import flash.events.Event;

	public class CelShadingExample extends MinkoExampleApplication
	{
		private var _lightDirection	: Vector4	= new Vector4(1., -.5, 0.);
		private var _lightMatrix	: Matrix4x4	= new Matrix4x4();
		
		override protected function initializeScene() : void
		{
			super.initializeScene();
			
			camera.position.set(0., 0., -7);
			cameraController.setPivot(0, 1.5, 0);
			
			scene.addChild(
				new Mesh(
					new TeapotGeometry(20),
					{
						thickness 		: 0.05,
						diffuseColor	: 0xffffffff
					},
					new Effect(new CelShadingShader())
				)
			);
		
			scene.bindings.setProperties({
				lightDiffuseColor	: 0xfffffffff,
				lightAmbient		: 0.4
			});
		}
		
		override protected function enterFrameHandler(event:Event):void
		{
			_lightMatrix.appendRotation(0.01, Vector4.Y_AXIS);
			scene.bindings.setProperty(
				"lightDirection",
				_lightMatrix.transformVector(_lightDirection)
			);
			
			super.enterFrameHandler(event);
		}
	}
}