/**
 * Created with IntelliJ IDEA.
 * User: mickael
 * Date: 22/04/12
 * Time: 17:54
 * To change this template use File | Settings | File Templates.
 */
package aerys.minko.example.core.skybox
{
	
	import aerys.minko.render.effect.Effect;
	import aerys.minko.render.resource.texture.CubeTextureResource;
	import aerys.minko.scene.node.mesh.Mesh;
	import aerys.minko.scene.node.mesh.geometry.primitive.CubeGeometry;
	
	public class SkyboxTest extends MinkoExampleApplication
	{
		[Embed(source="../assets/reflections/escher.env.jpg")]
		private static const CUBE_MAP : Class;
		
	    override protected function initializeScene() : void
		{
			var texture : CubeTextureResource = new CubeTextureResource(1024);
			texture.setContentFromBitmapData(new CUBE_MAP().bitmapData, true);
			
	        var skybox : Mesh = new Mesh(
				CubeGeometry.cubeGeometry,
				{ diffuseCubeMap: texture }, 
				new Effect(new SkyBoxShader())
			);
			
			skybox.transform.setScale(50, 50, 50);
			
	        scene.addChild(skybox);
	    }
	}
}
