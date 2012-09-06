package aerys.minko.example.ai.fsm
{
	import aerys.minko.ai.fsm.AbstractEdge;
	import aerys.minko.ai.fsm.FinalStateMachine;
	import aerys.minko.ai.msa.environment.Environment;
	import aerys.minko.scene.node.ISceneNode;
	import aerys.minko.scene.node.mesh.Mesh;
	import aerys.minko.scene.node.mesh.geometry.primitive.CubeGeometry;
	import aerys.minko.type.math.Vector4;

	public class FsmExample extends MinkoExampleApplication
	{	
		private const NB_CUBE : uint = 100;
		
		override protected function initializeScene():void
		{
			var env : Environment 		= new Environment();
			var fsm : FinalStateMachine = new FinalStateMachine();
			
			var state1 : SearchKeyPoint = new SearchKeyPoint(env, new Vector4(5, 0, -5));
			var state2 : SearchKeyPoint = new SearchKeyPoint(env, new Vector4(5, 0, 5));
			var state3 : SearchKeyPoint = new SearchKeyPoint(env, new Vector4(-5, 0, 5));
			var state4 : SearchKeyPoint = new SearchKeyPoint(env, new Vector4(-5, 0, -5));
			
			fsm.registerState(state1)
				.registerState(state2)
				.registerState(state3)
				.registerState(state4);
			
			fsm.addEdge(
				new AbstractEdge(
					state1, 
					state2, 
					1, 
					function (node : ISceneNode) : Boolean
					{
						return Vector4.distance(node.transform.getTranslation(), new Vector4(5, 0, -5)) < 0.15;
					}
				)
			);
			
			fsm.addEdge(
				new AbstractEdge(
					state2, 
					state3, 
					1, 
					function (node : ISceneNode) : Boolean
					{
						return Vector4.distance(node.transform.getTranslation(), new Vector4(5, 0, 5)) < 0.15;
					}
				)
			);
			
			fsm.addEdge(
				new AbstractEdge(
					state3, 
					state4, 
					1, 
					function (node : ISceneNode) : Boolean
					{
						return Vector4.distance(node.transform.getTranslation(), new Vector4(-5, 0, 5)) < 0.15;
					}
				)
			);
			
			fsm.addEdge(
				new AbstractEdge(
					state4, 
					state1, 
					1, 
					function (node : ISceneNode) : Boolean
					{
						return Vector4.distance(node.transform.getTranslation(), new Vector4(-5, 0, -5)) < 0.15;
					}
				)
			);
			
			fsm.defineStartState(state1);
			
			for (var i :  uint = 0; i < NB_CUBE; ++i)
			{
				var cube : Mesh = new Mesh(CubeGeometry.cubeGeometry, {diffuseColor : Math.random() * 0xFFFFFFFF});
				
				cube.transform.translationX = Math.random() * 500 - 250;
				cube.transform.translationZ = Math.random() * 500 - 250;
				
				cube.addController(fsm);
				
				scene.addChild(cube);
			}
		}
	}
}