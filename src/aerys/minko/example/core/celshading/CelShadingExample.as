package aerys.minko.example.core.celshading
{
	import aerys.minko.render.effect.SinglePassRenderingEffect;
	import aerys.minko.render.shader.IShader;
	import aerys.minko.scene.node.group.EffectGroup;
	import aerys.minko.scene.node.mesh.modifier.NormalMeshModifier;
	import aerys.minko.scene.node.mesh.primitive.TeapotMesh;
	import aerys.minko.type.math.ConstVector4;
	import aerys.minko.type.math.Matrix4x4;
	import aerys.minko.type.math.Vector4;
	
	import flash.events.Event;

	public class CelShadingExample extends MinkoExampleApplication
	{
		private var _lightDirection	: Vector4	= new Vector4(1., -.5, 0.);
		private var _lightMatrix	: Matrix4x4	= new Matrix4x4();
		private var _shader			: IShader	= new CelShadingShader();
		
		override protected function initializeScene():void
		{
			super.initializeScene();
			
			viewport.backgroundColor = 0x666666;
			
			camera.position.set(0., 0., -6);
			cameraController.setCenter(0, 1.5, 0);
			
			scene.addChild(new EffectGroup(
				new SinglePassRenderingEffect(_shader),
				new NormalMeshModifier(new TeapotMesh(20))
			));
			
			_shader.setNamedParameter(
				"diffuse color",
				new Vector4(.9, .9, 1, 1)
			);
		}
		
		override protected function enterFrameHandler(event:Event):void
		{
			_lightMatrix.appendRotation(0.01, ConstVector4.Y_AXIS);
			_shader.setNamedParameter(
				"light direction",
				_lightMatrix.transformVector(_lightDirection)
			);
			
			super.enterFrameHandler(event);
		}
	}
}