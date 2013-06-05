package aerys.minko.example.core.blendingEffect
{
	import flash.display.BitmapData;
	import flash.events.Event;
	
	import aerys.minko.render.Effect;
	import aerys.minko.render.geometry.primitive.CubeGeometry;
	import aerys.minko.render.material.basic.BasicMaterial;
	import aerys.minko.render.resource.texture.TextureResource;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.type.enum.Blending;
	import aerys.minko.type.enum.TriangleCulling;

	public class BlendingEffectExample extends AbstractExampleApplication
	{
		private var currentT: uint 				= 0;
		private var refresh	: uint 				= 2000;
		private var texture : TextureResource 	= new TextureResource(1, 1);
		private var mesh 	: Mesh 				= new Mesh(
			CubeGeometry.cubeGeometry, 
			new BasicMaterial(
				{
					diffuseColor 	: 0xFFFFFFFF,
					blending 		: Blending.ALPHA,
					triangleCulling	: TriangleCulling.NONE,
					alphaThreshold	: 0.05,
					fadeMap			: texture,
					refresh 		: refresh
				}, 
				new Effect(new BlendingShader()))
		);
		
		public function BlendingEffectExample()
		{
			super();
		}
		
		override protected function initializeScene():void
		{
			super.initializeScene();
			
			scene.addChild(mesh);
			
			for (var i : uint = 0; i < 20; ++i)
			{
				var m : Mesh = new Mesh(CubeGeometry.cubeGeometry, new BasicMaterial({diffuseColor : Math.random() * 0xFFFFFFFF}));
				m.transform.appendTranslation(-5 + Math.random() * 10, -5 + Math.random() * 10, 5 + Math.random() * 5);
				scene.addChild(m);
			}
			
			initMap();
		}
		
		private function initMap() : void
		{
			var bitmapData : BitmapData = new BitmapData(512, 512, true, 0);
			
			bitmapData.perlinNoise(20, 20, 3, 10, false, true, 7, true);
			
			texture.setContentFromBitmapData(bitmapData, false);
		}
		
		override protected function enterFrameHandler(event:Event):void
		{
			super.enterFrameHandler(event);
		}
	}
}