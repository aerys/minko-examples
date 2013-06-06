package aerys.minko.example.obj
{
	import aerys.minko.render.material.phong.PhongMaterial;
	import aerys.minko.scene.node.Group;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.scene.node.light.AmbientLight;
	import aerys.minko.scene.node.light.DirectionalLight;
	import aerys.minko.type.loader.ILoader;
	import aerys.minko.type.loader.SceneLoader;
	import aerys.minko.type.loader.parser.ParserOptions;
	import aerys.minko.type.parser.obj.MtlLoader;
	import aerys.minko.type.parser.obj.ObjParser;

	public class OpenObjExample extends AbstractExampleApplication
	{
		[Embed('../assets/dinosaur/dinosaur.obj', mimeType="application/octet-stream")]
		private static const DINOSAUR_OBJ	: Class;
		[Embed('../assets/dinosaur/dinosaur.mtl', mimeType="application/octet-stream")]
		private static const DINOSAUR_MTL	: Class;
		
		override protected function initializeScene() : void
		{
			super.initializeScene();
			
			var options : ParserOptions = new ParserOptions();
			
			options.parser = ObjParser;
			options.material = new PhongMaterial(scene);
			options.dependencyLoaderFunction = function(dependencyPath   : String,
														isTexture    	 : Boolean,
														options          : ParserOptions) : ILoader
			{
				// load embedded MTL file
				if (dependencyPath.indexOf('.mtl') >= 0)
				{
					var mtlLoader : MtlLoader = new MtlLoader(options);
					
					mtlLoader.loadClass(DINOSAUR_MTL);
					
					return mtlLoader;
				}
				
				return null;
			};
			
			scene.loadClass(DINOSAUR_OBJ, options).complete.add(
				function(loader : SceneLoader, scene : Group) : void
				{
					// look at the mesh
					cameraController.yaw = 2.;
					cameraController.distance = 60.;
					cameraController.lookAt.copyFrom(
						(scene.get('//mesh')[0] as Mesh).geometry.boundingSphere.center
					);
					
					// add some lights
					scene.addChild(new DirectionalLight()).addChild(new AmbientLight());
				}
			);
		}
	}
}