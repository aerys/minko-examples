package aerys.minko.example.core.edgedetection {
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import aerys.minko.example.core.edgedetection.shaders.RGBDepthShader;
	import aerys.minko.example.core.edgedetection.shaders.pre.DepthMapPass;
	import aerys.minko.example.core.edgedetection.shaders.pre.NormalMapPass;
	import aerys.minko.render.Effect;
	import aerys.minko.render.geometry.primitive.CubeGeometry;
	import aerys.minko.render.geometry.primitive.TeapotGeometry;
	import aerys.minko.render.material.Material;
	import aerys.minko.render.material.phong.PhongEffect;
	import aerys.minko.render.material.phong.PhongMaterial;
	import aerys.minko.render.shader.vertex.VertexNormalShader;
	import aerys.minko.scene.node.Group;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.scene.node.light.AmbientLight;
	import aerys.minko.scene.node.light.PointLight;
	import aerys.minko.type.enum.ShadowMappingType;
	import aerys.minko.type.math.Vector4;
	import aerys.monitor.Monitor;
	
	/**
	 * This example illustrates how to use depth and normal information of the scene
	 * to detect edges/corners and create a cartoon effect or a software antialiasing solution
	 * 
	 * First, vertex depths and normals are pre computed on the scene and stored in 2 differents RGBA maps.
	 * The scene is then normally rendered in the backbuffer like with all the other post processing effects.
	 * During the post processing, the 2 maps are filtered to evaluate how much a pixel looks like an edge.
	 * Depths of nearby pixels are compared and disruption in the normals (ie, corners) are detected.
	 * The 2 filters are then combined in one image showing the edges in white.
	 * This image is finally substracted or used as a blur mask on the backbuffer.
	 * 
	 * When running the example, press R to go through all the rendering modes.
	 * 0 (default)	: no processing
	 * 1 			: RGBDepthMap, the depth of the scene from the camera point of view in a nice rainbow scale
	 * 2			: Normal Map, the vertex normals like in the other example available on the wiki
	 * 3			: edge detection, this example uses the algorithm used in Stalker but many solution would work
	 * 4			: fast blur to remove small gaps in the filter
	 * 5			: we substract the edge map from the back buffer so all the pixels on the edges turn black
	 * 				  we could also mix the backbuffer with another color to get a colored outline
	 * 					eg: color = mix(color, float(1,0,0,0), isEdge); to get a red outline
	 * 6			: we blur only part of the image, the edges, effectively applying selective antialiasing. 
	 * 				  This can be used to have AA on a post processing filter where hardware AA is not available.
	 *  
	 *  @author Jeremy Comte
	 */

	public class EdgeDetectionExample extends AbstractExampleApplication { 
		
		private var _teapotGroup			: Group;
		private var _cubeMaterial 			: Material;
		
		private var outlineEffectStep1 		: StepByStepOutlineEffect;
		private var outlineEffectStep2  	: StepByStepOutlineEffect;
		private var outlineEffectSubtracted	: StepByStepOutlineEffect;
		private var outlineEffectAA			: StepByStepOutlineEffect;
		
		private var phongEffect				: Effect;
		private var rgbDepthEffect			: Effect;
		private var normalEffect			: Effect;
		
		private static const RENDERING_TITLES : Array = [	
			"NO POST PROCESSING", 
			"RGB DEPTH MAP", 
			"NORMAL MAP", 
			"OUTLINE",
			"SMOOTHED OUTLINE",
			"SUBSTRACTED OUTLINE",
			"ANTIALIASED OUTLINE"]; 
		
		public 	var renderingMode : int = 0;
		public 	var rendering:String =  "PRESS R TO START!";
		
		override protected function initializeScene() : void {
			super.initializeScene();
			cameraController.distance = 100;
			cameraController.yaw = -1.;
			cameraController.distanceStep = 5;
			
			initShaders();
			
			var mat : PhongMaterial = new PhongMaterial(scene, phongEffect);
			mat.castShadows = true;
			mat.receiveShadows = true;
			
			_cubeMaterial  = mat.clone() as PhongMaterial;
			
			var bigCube : Mesh = new Mesh(new CubeGeometry(), _cubeMaterial);
			
			bigCube.geometry
				.computeTangentSpace()
				.invertWinding()
				.flipNormals()
				.disposeLocalData();
			bigCube.transform.setScale(200, 200, 200);
			
			_cubeMaterial.diffuseMultiplier = 0.5;
			_cubeMaterial.ambientMultiplier = 0.5;
			_cubeMaterial.diffuseColor = 0xbbbbbbff;
			_cubeMaterial.castShadows = false;
			
			scene.addChild(bigCube);
			
			var teapotGeometry : TeapotGeometry = new TeapotGeometry(4);
			
			teapotGeometry.computeNormals().disposeLocalData();
			
			_teapotGroup = new Group();
			
			for (var teapotId : uint = 0; teapotId < 50; ++teapotId) {
				var smallTeapot : Mesh = new Mesh(
					teapotGeometry,
					mat.clone() as Material,
					'teapot'
				);
				
				smallTeapot.material.diffuseColor = ((Math.random() * 0xffffff) << 8) | 0xff;
				
				smallTeapot.transform.setTranslation(
					50 * (Math.random() - .5),
					50 * (Math.random() - .5),
					50 * (Math.random() - .5)
				);
				
				smallTeapot.transform.setRotation(
					2 * Math.PI * Math.random(),
					2 * Math.PI * Math.random(),
					2 * Math.PI * Math.random()
				);
				
				_teapotGroup.addChild(smallTeapot);
			}
			
			scene.addChild(_teapotGroup);
			
			initializeLights();
			
			Monitor.monitor.watch(this, ['rendering']);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		protected function initializeLights() : void {
			scene.addChild(new AmbientLight(0xffffffff, 0.6));
			cameraController.maxDistance = 100;
			cameraController.distance = 75;
			
			var pointLight : PointLight		= new PointLight();
			
			pointLight.shadowCastingType	= ShadowMappingType.EXPONENTIAL;
			pointLight.shadowZNear          = 0.1;
			pointLight.shadowZFar           = 100.;
			pointLight.shadowMapSize		= 1024;
			pointLight.attenuationDistance  = 80;
			
			scene.addChild(pointLight);
		}
		
		protected function initShaders() : void {
			var depthMapPass	: DepthMapPass 	= new DepthMapPass();
			var normalMapPass	: NormalMapPass = new NormalMapPass();
			
			outlineEffectStep1 		= new StepByStepOutlineEffect(depthMapPass.map, normalMapPass.map, 1);
			outlineEffectStep2 		= new StepByStepOutlineEffect(depthMapPass.map, normalMapPass.map, 2);
			outlineEffectSubtracted = new StepByStepOutlineEffect(depthMapPass.map, normalMapPass.map);
			outlineEffectAA			= new StepByStepOutlineEffect(depthMapPass.map, normalMapPass.map, -1, true, 1024); 
			
			rgbDepthEffect 	= new Effect(new RGBDepthShader());
			normalEffect	= new Effect(new VertexNormalShader());
			phongEffect 	= new PhongEffect();
			
			phongEffect.addExtraPass(depthMapPass.pass).addExtraPass(normalMapPass.pass);
			rgbDepthEffect.addExtraPass(depthMapPass.pass).addExtraPass(normalMapPass.pass);
			normalEffect.addExtraPass(depthMapPass.pass).addExtraPass(normalMapPass.pass);
		}
		
		protected function onKeyDown(event:KeyboardEvent) : void {
			switch(event.keyCode){
				case Keyboard.R:
					cycleRenderingMode();
					break;
				default:
					break;
			}
		}      
		
		protected function cycleRenderingMode() : void {
			if(++renderingMode >= RENDERING_TITLES.length){
				renderingMode = 0;
			}
			
			switch(renderingMode) {
				case 0:
					scene.postProcessingEffect = null;
					switchEffect(phongEffect);
					break;
				case 1:
					switchEffect(rgbDepthEffect);
					break;
				case 2: 
					switchEffect(normalEffect);
					break;
				case 3: 
					switchEffect(phongEffect);
					scene.postProcessingEffect = outlineEffectStep1;
					break;
				case 4: 
					scene.postProcessingEffect = outlineEffectStep2;
					break;
				case 5: 
					scene.postProcessingEffect = outlineEffectSubtracted;
					break;
				case 6: 
					scene.postProcessingEffect = outlineEffectAA;
					break;
				default:
					break;
			}
			
			rendering = RENDERING_TITLES[renderingMode];
		}
		
		protected function switchEffect( effect : Effect ) : void {
			for ( var i : int ; i < _teapotGroup.numChildren ; i++ ){
				(_teapotGroup.getChildAt(i) as Mesh).material.effect = effect;
			}
			_cubeMaterial.effect = effect;
		}
		
		override protected function enterFrameHandler(e : Event):void {
			super.enterFrameHandler(e);
			_teapotGroup.transform.appendRotation(0.001, Vector4.Y_AXIS);
		}
		
	}
}

