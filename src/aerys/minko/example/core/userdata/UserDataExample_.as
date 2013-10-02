package aerys.minko.example.core.userdata
{
	import aerys.minko.render.geometry.primitive.CubeGeometry;
	import aerys.minko.render.geometry.primitive.SphereGeometry;
	import aerys.minko.render.material.basic.BasicMaterial;
	import aerys.minko.scene.node.Group;
	import aerys.minko.scene.node.ISceneNode;
	import aerys.minko.scene.node.Mesh;

	public class UserDataExample_ extends AbstractExampleApplication
	{
		private var _material : BasicMaterial = new BasicMaterial({diffuseColor : 0xFF00FFFF});
		
		override protected function initializeScene():void
		{
			super.initializeScene();
			
			for (var i : uint = 0; i < 10; ++i)
			{
				var node1 : Mesh = new Mesh(CubeGeometry.cubeGeometry, _material);
			
				node1.userData.setProperty('type', 'cube');
				
				var node2 : Mesh = new Mesh(SphereGeometry.sphereGeometry, _material);
				
				node2.userData.setProperty('type', 'sphere');
				
				var node3 : Group = new Group(node1, node2);
				
				node3.userData.setProperty('shape', 0);
				node3.userData.setProperty('type', 'container');
				
				
				node2.transform.appendTranslation(0.5, 0, 0);
				node3.transform.appendTranslation((Math.random() - 0.5 ) * 20, (Math.random() - 0.5 ) * 20, (Math.random() - 0.5 ) * 20);
				
				var numGroup : uint = Math.random() * 5;
				
				for (var j : uint = 0; j < numGroup; ++j)
					node3 = new Group(node3);
				
				scene.addChild(node3);
			}
			
			getContent();
		}
		
		private function getContent() : void
		{
			var typedNode : Vector.<ISceneNode> = scene.get("//*[hasProperty(userData.type)]");
			trace("Num typed nodes", typedNode.length);
			
			var cubesNode : Vector.<ISceneNode> = scene.get("//*[userData.type='cube']");
			
			trace("Num cubes", cubesNode.length);
			
			var spheresNode : Vector.<ISceneNode> = scene.get("//*[userData.type='sphere']");
			
			trace("Num sphere", spheresNode.length);
			
			var containers : Vector.<ISceneNode> = scene.get("//*[userData.type='container']");
			
			trace("Num container", containers.length);
		}
	}
}