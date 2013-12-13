package aerys.minko.example.core.contextloss
{
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import aerys.minko.render.Viewport;
	import aerys.minko.render.geometry.Geometry;
	import aerys.minko.render.geometry.primitive.CubeGeometry;
	import aerys.minko.render.geometry.stream.StreamUsage;
	import aerys.minko.render.material.Material;
	import aerys.minko.render.material.basic.BasicMaterial;
	import aerys.minko.render.resource.Context3DResource;
	import aerys.minko.render.resource.texture.TextureResource;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.type.loader.TextureLoader;
	
	public class ContextLossExample extends AbstractExampleApplication
	{
		private static const DIFFUSE_MAP_TEXTURE	: String = "../assets/sponza_bricks/spnza_bricks_a_diff.jpg";
		
		[Embed("../assets/sponza_bricks/spnza_bricks_a_spec.jpg")]
		private static const SPECULAR_MAP_TEXTURE	: Class;
		
		[Embed("../assets/atf/leaf.atf", mimeType="application/octet-stream")]
		private static const ATF_TEXTURE	: Class;
		
		private var _diffuse					: TextureResource;
		private var _specular					: TextureResource;
		private var _atfTexture					: TextureResource;
		
		private var _dynamicGeometry			: Geometry;
		private var _staticGeometry				: Geometry;
		
		private var _textureResourceToAsset		: Dictionary = new Dictionary();
		
		private var _meshToGeometry				: Dictionary = new Dictionary();
		private var _geometryToMeshes			: Dictionary = new Dictionary();
		
		private var _geometryToType				: Dictionary = new Dictionary();
		
		override protected function initializeScene() : void
		{
			super.initializeScene();
			
			initTextures();
			initMeshes();
		}
		
		private function initMeshes() : void
		{
			var material : Material = new BasicMaterial({
				diffuseMap 		: _diffuse,
				specularMap		: _specular
			});
			var material2 : Material = new BasicMaterial({
				diffuseMap 		: _atfTexture
			});
			
			
			// Dynamic streams are kept in memory and are automatically reuploaded to the GPU
			_dynamicGeometry	= new CubeGeometry(StreamUsage.DYNAMIC, StreamUsage.DYNAMIC);
			
			var dynamicMesh1	: Mesh = new Mesh(_dynamicGeometry, material);
			var dynamicMesh2	: Mesh = new Mesh(_dynamicGeometry, material);
			
			
			// Static streams are not kept in memory and will need to be recreated to be reuploaded to the GPU
			_staticGeometry		= new CubeGeometry(StreamUsage.STATIC, StreamUsage.STATIC);
			
			var staticMesh1		: Mesh = new Mesh(_staticGeometry, material2);
			var staticMesh2		: Mesh = new Mesh(_staticGeometry, material2);
			var staticMesh3		: Mesh = new Mesh(_staticGeometry, material2);
			
			linkMeshToGeometry(staticMesh1, _staticGeometry);
			linkMeshToGeometry(staticMesh2, _staticGeometry);
			//linkMeshToGeometry(staticMesh3, _staticGeometry); // with this line commented, staticMesh3 will not be updated on context loss.
						
			dynamicMesh1.transform.setTranslation(3, 0, 0);
			dynamicMesh2.transform.setTranslation(1, 0, 0);
			staticMesh1.transform.setTranslation(-1, 0, 0);
			staticMesh2.transform.setTranslation(-3, 0, 0);
			staticMesh3.transform.setTranslation(0, 1.5, 0);
			
			scene.addChild(dynamicMesh1)
				.addChild(dynamicMesh2)
				.addChild(staticMesh1)
				.addChild(staticMesh2)
				.addChild(staticMesh3);
			
			viewport.contextLost.add(viewportContextLostHandler);
		}
		
		private function linkMeshToGeometry(mesh : Mesh, geometry : Geometry) : void
		{
			//Linking meshes and geometries together so that we can reinitialize the geometries later on context loss 
			if (!_geometryToMeshes[geometry])
				_geometryToMeshes[geometry] = new Vector.<Mesh>;
			
			var previousGeometry : Geometry = _meshToGeometry[mesh];
			
			if (previousGeometry)
			{
				var previousGeometryMeshes : Vector.<Mesh> = _geometryToMeshes[previousGeometry];
				if (previousGeometryMeshes)
				{
					var index : int = previousGeometryMeshes.indexOf(mesh);
					if (index)
					{
						previousGeometryMeshes.splice(index, 1);
						if (!previousGeometryMeshes.length)
							delete _geometryToMeshes[previousGeometry];
					}
				}
			}
			
			_meshToGeometry[mesh] = geometry;
			_geometryToMeshes[geometry].push(mesh);
		}
		
		private function viewportContextLostHandler(viewport : Viewport, context : Context3DResource) : void
		{
			for(var mesh : * in _meshToGeometry)
			{
				var geometry	: Geometry		= _meshToGeometry[mesh];
				var meshes		: Vector.<Mesh>	= _geometryToMeshes[geometry];
				
				var newGeometry : Geometry = new CubeGeometry(StreamUsage.STATIC, StreamUsage.STATIC);
				
				for each(var linkedMesh : Mesh in meshes)
				{
					linkedMesh.geometry = newGeometry;
					linkMeshToGeometry(linkedMesh, newGeometry);
				}
			}
		}
		
		private function initTextures() : void
		{
			//Textures loaded with TextureLoader.loadClass will automatically be reloaded on context loss
			_diffuse	= TextureLoader.load(new URLRequest(DIFFUSE_MAP_TEXTURE));
			
			//Textures loaded with TextureLoader.load will automatically be reloaded on context loss
			_specular	= TextureLoader.loadClass(SPECULAR_MAP_TEXTURE);
			
			//Textures loaded with TextureLoader.loadBytes will need to be manually reloaded on context loss
			var data : ByteArray = new ATF_TEXTURE();
			
			_atfTexture	= TextureLoader.loadBytes(data);
			_atfTexture.contextLost.add(textureContextLostHandler);
			
			_textureResourceToAsset[_atfTexture] = ATF_TEXTURE;
		}
		
		private function textureContextLostHandler(textureResource : TextureResource) : void
		{
			var asset : Class = _textureResourceToAsset[textureResource];
			
			var data : ByteArray = new asset();
			
			TextureLoader.loadBytes(data, true, textureResource);
		}
	}
}