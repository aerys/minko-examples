package aerys.minko.example.core.cameraview_
{
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.material.basic.BasicShader;
	import aerys.minko.render.shader.SFloat;
	
	public class AdditionalCameraBasicShader extends BasicShader
	{
		public function AdditionalCameraBasicShader(target:RenderTarget=null, priority:Number=0.0)
		{
			super(target, priority);
		}
		
		override protected function getVertexPosition():SFloat
		{
			
			return multiply4x4(
				localToWorld(
					vertexAnimation.getAnimatedVertexPosition()),
					sceneBindings.getParameter('additionalCameraWorldToScreen', 16)
			);
		}
	}
}