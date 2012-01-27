package aerys.minko.example.core.light
{
	import aerys.minko.render.effect.SinglePassRenderingEffect;
	import aerys.minko.render.shader.IShader;
	import aerys.minko.scene.node.group.EffectGroup;
	import aerys.minko.scene.node.mesh.modifier.NormalMeshModifier;
	import aerys.minko.scene.node.mesh.primitive.TeapotMesh;
	import aerys.minko.type.math.ConstVector4;
	import aerys.minko.type.math.Matrix4x4;
	
	import flash.events.Event;

	public class DirectionalLightExample extends MinkoExampleApplication
	{
		protected var _shader	: IShader	= new DirectionalLightShader();
		protected var _matrix	: Matrix4x4	= new Matrix4x4();
		
		override protected function initializeScene() : void
		{
			cameraController.setPivot(0, 1.3, 0);
			
			scene.addChild(
				new EffectGroup(
					new SinglePassRenderingEffect(_shader),
					new NormalMeshModifier(new TeapotMesh())
				)
			);
		}
		
		override protected function enterFrameHandler(event:Event):void
		{
			_matrix.appendRotation(.1, ConstVector4.Y_AXIS);
			_shader.setNamedParameter("light direction", _matrix.transformVector(ConstVector4.ONE));
			
			super.enterFrameHandler(event);
		}
	}
}