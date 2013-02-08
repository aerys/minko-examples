package
{
	import aerys.minko.render.geometry.stream.format.VertexComponent;
	import aerys.minko.render.geometry.stream.format.VertexComponentType;
	import aerys.minko.render.geometry.stream.format.VertexFormat;
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.resource.texture.TextureResource;
	import aerys.minko.render.shader.SFloat;
	import aerys.minko.render.shader.Shader;
	import aerys.minko.render.shader.ShaderSettings;
	import aerys.minko.type.enum.Blending;
	import aerys.minko.type.enum.DepthTest;
	import aerys.minko.type.enum.SamplerFiltering;
	import aerys.minko.type.enum.SamplerMipMapping;
	import aerys.minko.type.enum.SamplerWrapping;
	import aerys.minko.type.enum.TriangleCulling;
	
	
	public class RainShader extends Shader
	{
		public static const POINT_DATA:VertexComponent = new VertexComponent(['offsetX', 'offsetY'], VertexComponentType.FLOAT_2);
		public static const VERTEX_FORMAT:VertexFormat = new VertexFormat(POINT_DATA, VertexComponent.XYZ);
		
		private var _uv:SFloat = null;
		private var raintexture:TextureResource;
		private var size:Number;
		
		public function RainShader(texture:TextureResource,size:Number=10,target:RenderTarget = null, priority:Number = 0.0)
		{
			super(target, priority);
			this.size = size;
			raintexture = texture;
		}
		
		override protected function initializeSettings(settings:ShaderSettings):void
		{
			super.initializeSettings(settings);
			
			settings.triangleCulling = TriangleCulling.NONE;
			settings.blending = Blending.ADDITIVE;
			settings.depthWriteEnabled = false;
			settings.depthTest = DepthTest.ALWAYS;
		}
		
		override protected function getVertexPosition():SFloat
		{
			var speed:SFloat =  meshBindings.getParameter('speed', 3);

			var time:SFloat = multiply(this.time,speed);
			
			_uv  = getVertexAttribute(POINT_DATA);
						
			var pointSize:SFloat = meshBindings.getParameter('pointSize', 1);
			var position:SFloat = getVertexAttribute(VertexComponent.XYZ);
			
			pointSize.y = subtract(pointSize.x,multiply(meshBindings.getParameter('pointSizeDelta', 1),subtract(absolute(dotProduct3(normalize(speed), cameraDirection)),1)));
			
			var corner:SFloat = multiply(_uv, pointSize.xy);
			
			_uv = divide(add(_uv, 1),2);
						
			position.xyz = multiply(fractional(divide(subtract(position.xyz, time.xyz), size) ),size);
			
			position = localToView(position);
			
			position.incrementBy(corner);
			
			return multiply4x4(position, projectionMatrix);
		}
		
		override protected function getPixelColor():SFloat
		{			
			return sampleTexture(getTexture(raintexture,SamplerFiltering.LINEAR,SamplerMipMapping.DISABLE,SamplerWrapping.CLAMP), interpolate(_uv));
		}
	}
}