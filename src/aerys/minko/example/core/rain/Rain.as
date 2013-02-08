package
{
	import aerys.minko.render.Effect;
	import aerys.minko.render.material.Material;
	import aerys.minko.render.resource.texture.TextureResource;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.type.loader.TextureLoader;
	
	public class Rain extends MinkoExampleApplication
	{
		[Embed(source = "rain.png")]private static const RainTexture:Class;
		
		override protected function initializeScene():void
		{
			super.initializeScene();
			
			viewport.backgroundColor = 0x0;
			
			var raintexture:TextureResource=TextureLoader.loadClass(RainTexture);
			
			var m:Mesh = new Mesh(new RainGeometry(10), new Material(new Effect(new RainShader(raintexture,10)), {pointSize: 0.005, pointSizeDelta: 0.02,speed: new <Number>[0.001, 0.009,0]}))
			m.z = m.x = m.y = -5;
			
			scene.addChild(m);
		}
	}
}