package aerys.minko.example.core.cameraView
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import aerys.minko.render.RenderTarget;
	import aerys.minko.render.geometry.primitive.CubeGeometry;
	import aerys.minko.render.material.basic.BasicMaterial;
	import aerys.minko.render.material.basic.BasicProperties;
	import aerys.minko.render.resource.texture.TextureResource;
	import aerys.minko.scene.controller.animation.AnimationController;
	import aerys.minko.scene.controller.camera.CameraController;
	import aerys.minko.scene.node.ISceneNode;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.scene.node.Sprite;
	import aerys.minko.scene.node.camera.Camera;
	import aerys.minko.type.animation.timeline.ITimeline;
	import aerys.minko.type.animation.timeline.MatrixTimeline;
	import aerys.minko.type.enum.FrustumCulling;
	import aerys.minko.type.loader.SceneLoader;
	import aerys.minko.type.math.Matrix4x4;
	import aerys.minko.type.math.Vector4;

	public class CameraViewExample extends AbstractExampleApplication
	{
		
		private var secondCameraRenderTarget	: RenderTarget 	= new RenderTarget(512, 512, new TextureResource(512, 512), 0, 0x333333ff, true, 0);
		private var cubeMaterial				: BasicMaterial = new BasicMaterial();
		private var secondCamera				: Camera		= new Camera();
		
		override protected function initializeScene():void
		{
			super.initializeScene();
		
			stage.addEventListener(MouseEvent.CLICK, mouseClickEvent);
			
			initSecondCamera();
			initExtraPass();
			
			mouseClickEvent(null);
		}
		
		private function sceneLoaded(sceneLoader : SceneLoader, data : ISceneNode) : void
		{
			data.addController(getNewAnimation());
		}
		
		// init extra pass and create a sprite to display the result
		private function initExtraPass() : void
		{
			cubeMaterial.effect.addExtraPass(new AdditionalCameraBasicShader(secondCameraRenderTarget, 1));
			
			var sprite : Sprite = new Sprite(120, 0, viewport.width / 4, viewport.height / 4);
			sprite.material.diffuseMap = secondCameraRenderTarget.textureResource;
			
			scene.addChild(sprite);
		}
		
		// init a second camera and set the sceneproperties 
		private function initSecondCamera() : void
		{
			secondCamera.transform.lookAt(Vector4.ZERO, new Vector4(0, 0, -30));			
			
			var secondCameraController : CameraController = secondCamera.getControllersByType(CameraController)[0] as CameraController;
			scene.properties.setProperty("additionalCameraWorldToScreen", secondCameraController.cameraData.worldToScreen);

			scene.addChild(secondCamera);
			camera.enabled = true;
		}
		
		// generate a animation
		private function getNewAnimation() : AnimationController
		{
			return new AnimationController(
				new <ITimeline>[
					new MatrixTimeline(
						"transform", 
						new <uint>[0, 5000],
						new <Matrix4x4>[
							new Matrix4x4().appendTranslation(Math.random() * 20 - 10, 30, Math.random() * 10),
							new Matrix4x4().appendTranslation(Math.random() * 20 - 10, -30, Math.random() * 10)
						], true)
				], true);
		}
		
		// on click a cube is create
		private function mouseClickEvent(event : Event) : void
		{
			var cube : Mesh = new Mesh(CubeGeometry.cubeGeometry, cubeMaterial.clone() as BasicMaterial);
			cube.material.setProperty(BasicProperties.DIFFUSE_COLOR, uint(0xFFFFFFFF * Math.random()));
			
			cube.frustumCulling = FrustumCulling.DISABLED;
			cube.addController(getNewAnimation());
			scene.addChild(cube);

		}
	}
}