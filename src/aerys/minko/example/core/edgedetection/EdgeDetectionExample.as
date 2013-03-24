package aerys.minko.example.core.edgedetection 
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import aerys.minko.example.core.edgedetection.effects.AntiAliasedOutlineEffect;
	import aerys.minko.example.core.edgedetection.effects.OutlineEffect;
	import aerys.minko.example.core.edgedetection.effects.SmoothOutlineEffect;
	import aerys.minko.example.core.edgedetection.effects.SubstractedOutlineEffect;
	import aerys.minko.example.core.edgedetection.shaders.RGBDepthShader;
	import aerys.minko.example.core.edgedetection.shaders.pre.DepthMapPass;
	import aerys.minko.example.core.edgedetection.shaders.pre.NormalMapPass;
	import aerys.minko.render.Effect;
	import aerys.minko.render.geometry.primitive.CubeGeometry;
	import aerys.minko.render.material.Material;
	import aerys.minko.render.material.phong.PhongEffect;
	import aerys.minko.render.material.phong.PhongMaterial;
	import aerys.minko.render.shader.vertex.VertexNormalShader;
	import aerys.minko.scene.node.Group;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.scene.node.light.AmbientLight;
	import aerys.minko.type.math.Vector4;
	import aerys.monitor.Monitor;
	
	/**
	 * This example illustrates how to use the depth and normal information of the scene
	 * to detect edges/corners and create a cartoon effect or a software antialiasing solution
	 * 
	 * How it works:
	 * First, vertex depths and normals are pre-computed on the scene and stored in 2 differents textures.
	 * The scene is rendered and stored in the backbuffer like with all the other post processing effects.
	 * During the post processing, the 2 maps are filtered to evaluate how much a pixel "looks like an edge".
	 * -> Depths of near pixels are compared and disruption in the normals (ie, corners) are detected.
	 * The 2 filters are then combined in one image showing the edges in white.
	 * This image is finally substracted from or used as a blur mask on the backbuffer.
	 * 
	 * When running the example, press R to go through all the rendering modes.
	 * 0 (default)	: no processing
	 * 1 			: RGBDepthMap, the depth of the scene from the camera point of view in a nice rainbow scale
	 * 2			: Normal Map, the vertex normals like in the other example available on the wiki
	 * 3			: edge detection, this example uses the algorithm used in the game Stalker but many other solutions would work
	 * 4			: fast blur to remove small gaps in the filter
	 * 5			: we substract the edge map from the back buffer so all the pixels on the edges turn black
	 * 				  we could also mix the backbuffer with another color to get a colored outline
	 * 					eg: color = mix(color, float(1,0,0,0), isEdge); to get a red outline
	 * 6			: we blur only part of the image, the edges, effectively applying selective antialiasing. 
	 * 				  This can be used to have AA on a post processing filter where hardware AA is not available.
	 *  
	 * 
	 * Ideas and more theory at:
	 * 		http://http.developer.nvidia.com/GPUGems2/gpugems2_chapter09.html
	 * 		http://http.developer.nvidia.com/GPUGems3/gpugems3_ch19.html
	 * 
	 */

	public class EdgeDetectionExample extends AbstractExampleApplication 
	{ 
		private var _rotatingGroup				: Group;
		private var _cubeMaterial 				: Material;
		
		private var _outlineEffect 				: OutlineEffect;
		private var _smoothedOutlineEffect  	: SmoothOutlineEffect;
		private var _substractedOutlineEffect	: SubstractedOutlineEffect;
		private var _antiAliasedOutlineEffect	: AntiAliasedOutlineEffect;
		
		private var _phongEffect				: Effect;
		private var _rgbDepthEffect				: Effect;
		private var _normalEffect				: Effect;
		
		private static const RENDERING_TITLES : Array = [	
			"NO POST PROCESSING", 
			"RGB DEPTH MAP", 
			"NORMAL MAP", 
			"OUTLINE",
			"SMOOTHED OUTLINE",
			"SUBSTRACTED OUTLINE",
			"ANTIALIASED OUTLINE"]; 
		
		private	var _renderingMode 	: int 		= 0;
		public 	var rendering		: String 	= "PRESS R TO START!";
		
		override protected function initializeScene() : void 
		{
			super.initializeScene();
			cameraController.distance = 30;
			cameraController.yaw = -1.;
			cameraController.distanceStep = 5;
			
			initShaders();
			
			var mat : PhongMaterial = new PhongMaterial(scene, _phongEffect);
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
			
			var smallCubeGeometry : CubeGeometry = new CubeGeometry();
			smallCubeGeometry.computeNormals().disposeLocalData();
			
			_rotatingGroup = new Group();
			
			//Let's make a diamond made of cubes (non visible diamonds are omitted)
			for (var x : int = -5; x <= 5; x++) 
			{
				for (var z : int = -5; z <= 5; z++) 
				{
					for (var y : int = -5; y <= 5; y++)
					{
						if((Math.abs(x) + Math.abs(z) + Math.abs(y)) == 5) //distance from the center is 5
						{
							var smallCube : Mesh = new Mesh(smallCubeGeometry, mat.clone() as Material);
							smallCube.material.diffuseColor = ((Math.random() * 0xffffff) << 8) | 0xff;
							smallCube.transform.setTranslation(x, y, z);
							_rotatingGroup.addChild(smallCube);
						}
					}
				}
			}
			
			scene.addChild(_rotatingGroup);
			
			scene.addChild(new AmbientLight(0xffffffff, 1));
			
			Monitor.monitor.watch(this, ['rendering']);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		protected function initShaders() : void 
		{
			var depthMapPass : DepthMapPass = new DepthMapPass();
			var normalMapPass : NormalMapPass = new NormalMapPass();
			
			_outlineEffect = new OutlineEffect(depthMapPass.map, normalMapPass.map);
			_smoothedOutlineEffect = new SmoothOutlineEffect(depthMapPass.map, normalMapPass.map);
			_substractedOutlineEffect = new SubstractedOutlineEffect(depthMapPass.map, normalMapPass.map);
			_antiAliasedOutlineEffect = new AntiAliasedOutlineEffect(depthMapPass.map, normalMapPass.map, 1024); 
			
			_rgbDepthEffect = new Effect(new RGBDepthShader());
			_normalEffect = new Effect(new VertexNormalShader());
			_phongEffect = new PhongEffect();
			
			_phongEffect.addExtraPass(depthMapPass.pass).addExtraPass(normalMapPass.pass);
			_rgbDepthEffect.addExtraPass(depthMapPass.pass).addExtraPass(normalMapPass.pass);
			_normalEffect.addExtraPass(depthMapPass.pass).addExtraPass(normalMapPass.pass);
		}
		
		protected function onKeyDown(event:KeyboardEvent) : void 
		{
			switch(event.keyCode)
			{
				case Keyboard.R:
					cycleRenderingMode();
					break;
				default:
					break;
			}
		}      
		
		protected function cycleRenderingMode() : void 
		{
			if(++_renderingMode >= RENDERING_TITLES.length)
			{
				_renderingMode = 0;
			}
			
			switch(_renderingMode) 
			{
				case 0:
					scene.postProcessingEffect = null;
					switchEffect(_phongEffect);
					break;
				case 1:
					switchEffect(_rgbDepthEffect);
					break;
				case 2: 
					switchEffect(_normalEffect);
					break;
				case 3: 
					switchEffect(_phongEffect);
					scene.postProcessingEffect = _outlineEffect;
					break;
				case 4: 
					scene.postProcessingEffect = _smoothedOutlineEffect;
					break;
				case 5: 
					scene.postProcessingEffect = _substractedOutlineEffect;
					break;
				case 6: 
					scene.postProcessingEffect = _antiAliasedOutlineEffect;
					break;
				default:
					break;
			}
			
			rendering = RENDERING_TITLES[_renderingMode];
		}
		
		protected function switchEffect( effect : Effect ) : void 
		{
			for ( var i : int ; i < _rotatingGroup.numChildren ; i++ )
			{
				(_rotatingGroup.getChildAt(i) as Mesh).material.effect = effect;
			}
			_cubeMaterial.effect = effect;
		}
		
		override protected function enterFrameHandler(e : Event) : void 
		{
			super.enterFrameHandler(e);
			_rotatingGroup.transform.appendRotation(0.001, Vector4.Y_AXIS);
		}
		
	}
}

