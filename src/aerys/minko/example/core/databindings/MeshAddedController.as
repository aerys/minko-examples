package aerys.minko.example.core.databindings
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import aerys.minko.render.material.environment.EnvironmentMappingProperties;
	import aerys.minko.render.resource.texture.TextureResource;
	import aerys.minko.scene.controller.AbstractController;
	import aerys.minko.scene.node.Group;
	import aerys.minko.scene.node.ISceneNode;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.scene.node.Scene;
	import aerys.minko.type.binding.DataProvider;
	import aerys.minko.type.enum.EnvironmentMappingType;
	
	public class MeshAddedController extends AbstractController
	{
		private var dataProvider : DataProvider = new DataProvider();
		
		public function MeshAddedController()
		{
			super(Group);
			initialize();
			
			var bitmapData 	: BitmapData 		= new BitmapData(256, 256, true, 0xFFFFFFFF);
			var texture		: TextureResource 	= new TextureResource(256, 256);
			
			bitmapData.perlinNoise(5, 5, 8, 3, true, true);
			texture.setContentFromBitmapData(bitmapData, true);
			
			dataProvider.setProperty(EnvironmentMappingProperties.ENVIRONMENT_MAP, texture);
			dataProvider.setProperty(EnvironmentMappingProperties.ENVIRONMENT_MAPPING_TYPE, EnvironmentMappingType.BLINN_NEWELL);
			dataProvider.setProperty(EnvironmentMappingProperties.REFLECTIVITY, 0.7);
		}
		
		private function initialize() : void
		{
			targetAdded.add(targetAddedHandler);
			targetRemoved.add(targetRemovedHandler);
		}

		protected function targetAddedHandler(ctrl		: MeshAddedController,
											  target	: Scene) : void
		{
			target.descendantAdded.add(descendantAddedHandler);
			target.descendantRemoved.add(descendantRemovedHandler);
		}
		
		protected function targetRemovedHandler(ctrl	: MeshAddedController,
												target	: Scene) : void
		{
			target.added.remove(descendantAddedHandler);
			target.removed.remove(descendantRemovedHandler);
		}
		
		private function descendantAddedHandler(root		: Group,
									  			descendant	: ISceneNode) : void
		{
			if (descendant is Mesh)
				Mesh(descendant).bindings.addProvider(dataProvider);
		}
		
		private function descendantRemovedHandler(root		: Group,
										descendant	: ISceneNode) : void
		{
			if (descendant is Mesh && Mesh(descendant).bindings.hasProvider(dataProvider))
				Mesh(descendant).bindings.removeProvider(dataProvider);
		}
		
	}
}