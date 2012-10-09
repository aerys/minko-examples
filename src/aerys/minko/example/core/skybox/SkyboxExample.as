package aerys.minko.example.core.skybox
{
	
	import aerys.minko.render.Effect;
	import aerys.minko.render.geometry.primitive.CubeGeometry;
	import aerys.minko.render.material.Material;
	import aerys.minko.render.resource.texture.CubeTextureResource;
	import aerys.minko.scene.controller.camera.ArcBallController;
	import aerys.minko.scene.node.Mesh;
	
	public class SkyboxExample extends MinkoExampleApplication
	{
		[Embed(source="../assets/skybox/negx.jpg")]
		private static const NEG_X : Class;
		
		[Embed(source="../assets/skybox/negy.jpg")]
		private static const NEG_Y : Class;
		
		[Embed(source="../assets/skybox/negz.jpg")]
		private static const NEG_Z : Class;
		
		[Embed(source="../assets/skybox/posx.jpg")]
		private static const POS_X : Class;
		
		[Embed(source="../assets/skybox/posy.jpg")]
		private static const POS_Y : Class;
		
		[Embed(source="../assets/skybox/posz.jpg")]
		private static const POS_Z : Class;
		
	    override protected function initializeScene() : void
		{
			super.initializeScene();
			
			// lock camera to center
			cameraController.distanceStep = 0.;
			
			// create cubemap
			var texture : CubeTextureResource = new CubeTextureResource(1024);
			texture.setContentFromBitmapDatas(
				new POS_X().bitmapData,
				new NEG_X().bitmapData,
				new POS_Y().bitmapData,
				new NEG_Y().bitmapData,
				new POS_Z().bitmapData,
				new NEG_Z().bitmapData,
				true
			);
			
			// create geometry with custom shader.
	        var skybox : Mesh = new Mesh(
				CubeGeometry.cubeGeometry,
				new Material(new Effect(new SkyBoxShader()), { diffuseCubeMap: texture })
			);
			
			skybox.transform.setScale(50, 50, 50);
			
	        scene.addChild(skybox);
	    }
	}
}
