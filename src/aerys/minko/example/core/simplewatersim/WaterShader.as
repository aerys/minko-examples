package aerys.minko.example.core.simplewatersim 
{
	import aerys.minko.render.material.basic.BasicProperties;
	import aerys.minko.render.material.basic.BasicShader;
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.shader.part.projection.ProbeProjectionShaderPart;
	import aerys.minko.render.shader.SFloat;
	import aerys.minko.type.enum.SamplerFiltering;
	import aerys.minko.type.enum.SamplerMipMapping;
	import aerys.minko.type.enum.SamplerWrapping;
	import aerys.minko.type.enum.TriangleCulling;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author sindney
	 */
	public class WaterShader extends BasicShader {
		
		private var _probeProjectionPart:ProbeProjectionShaderPart;
		
		private var proxy:SFloat = null;
		
		public function WaterShader(renderTarget:RenderTarget = null, priority:Number = 0) {
			super(renderTarget, priority);
			
			_probeProjectionPart = new ProbeProjectionShaderPart(this);
		}
		
		override protected function getVertexPosition():SFloat {
			var time:SFloat = float(meshBindings.getParameter(WaterMaterialProperties.TIMER, 1));
			var mag:SFloat = float(meshBindings.getParameter(WaterMaterialProperties.MAGNITUDE, 1));
			
			// vertex.y is the (0-1) scaled vertex position.
			// then multiply by 2*PI, together with sin function, our vertex.y starts to wave.
			proxy = vertexAnimation.getAnimatedVertexPosition();
			proxy.y = float(multiply(sin(add(multiply(proxy.y, 6.28), time)), mag));
			
			return localToScreen(proxy);
		}
		
		override protected function getPixelColor():SFloat {
			var time:SFloat = float(meshBindings.getParameter(WaterMaterialProperties.TIMER, 1));
			var size:SFloat = float(meshBindings.getParameter(WaterMaterialProperties.SIZE, 1));
			
			// Calculate Normal
			
			var height:SFloat = meshBindings.getTextureParameter(
				WaterMaterialProperties.HEIGHT_MAP, 
				SamplerFiltering.LINEAR, 
				SamplerMipMapping.LINEAR, 
				SamplerWrapping.CLAMP
			);
			
			var offset:SFloat = float2(add(proxy.x, 0.5), add(proxy.z, 0.5));
			
			var p0:SFloat = float(sin(add(multiply(sampleTexture(height, interpolate(offset)).r, 6.28), time)));
			var p1:SFloat = float(sin(add(multiply(sampleTexture(height, interpolate(float2(add(offset.x, size), offset.y))).r, 6.28), time)));
			var p2:SFloat = float(sin(add(multiply(sampleTexture(height, interpolate(float2(offset.x, add(offset.y, size)))).r, 6.28), time)));
			
			var normal:SFloat = normalize(float4(subtract(p0, p1), 1, subtract(p0, p2), 1));
			
			// Environment Mapping
			
			var worldCameraPos:SFloat = this.cameraPosition;
			var worldVertexToCamera:SFloat = normalize(interpolate(normalize(subtract(worldCameraPos, localToWorld(proxy)))));
			var worldNormal:SFloat = normalize(localToWorld(normal));
			
			var reflected:SFloat = normalize(reflect(worldVertexToCamera, worldNormal));
			
			var reflectionMap:SFloat = meshBindings.getTextureParameter(WaterMaterialProperties.ENVIRONMENT_MAP);
			var reflectionMapUV:SFloat = _probeProjectionPart.projectVector(negate(reflected.xzy), new Rectangle(0, 0, 1, 1));
			var reflectionColor:SFloat = sampleTexture(reflectionMap, reflectionMapUV);
			
			var reflectivity : SFloat = meshBindings.getParameter(WaterMaterialProperties.REFLECTIVITY, 1);
			reflectionColor = float4(multiply(reflectionColor.xyz, reflectivity), 1);
			
			// Result
			
			var lightDir:SFloat = normalize(meshBindings.getParameter(WaterMaterialProperties.LIGHT_DIRECTION, 3));
			var diffColor:SFloat = diffuse.getDiffuseColor();
			diffColor = float4(multiply(diffColor.rgb, saturate(negate(dotProduct3(lightDir, normal)))).rgb, diffColor.a);
			
			return float4(add(reflectionColor, diffColor).rgb, diffColor.a);
		}
		
	}

}