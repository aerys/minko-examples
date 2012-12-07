package aerys.minko.example.core.celshading
{
	import aerys.minko.render.Effect;
	import aerys.minko.render.geometry.primitive.TeapotGeometry;
	import aerys.minko.render.material.Material;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.type.math.Matrix4x4;
	import aerys.minko.type.math.Vector4;
	
	import flash.events.Event;

	public class CelShadingExample extends AbstractExampleApplication
	{
		private var _lightDirection	: Vector4	= new Vector4(1., -.5, 0.);
		private var _lightMatrix	: Matrix4x4	= new Matrix4x4();
		
		override protected function initializeScene() : void
		{
			super.initializeScene();
			
			cameraController.distance = 10;
			cameraController.lookAt.set(0, 1.5, 0);
			
			scene.addChild(new Mesh(
				new TeapotGeometry(20),
				new Material(
					new Effect(new CelShadingShader()),
					{
						thickness 		: 0.05,
						diffuseColor	: 0xffffffff
					}
				)
			));
		
			scene.properties.setProperties({
				lightDiffuseColor	: 0xfffffffff,
				lightAmbient		: 0.4
			});
		}
		
		override protected function enterFrameHandler(event : Event):void
		{
			_lightMatrix.appendRotation(0.01, Vector4.Y_AXIS);
			scene.properties.setProperty(
				'lightDirection',
				_lightMatrix.transformVector(_lightDirection)
			);
			
			super.enterFrameHandler(event);
		}
	}
}