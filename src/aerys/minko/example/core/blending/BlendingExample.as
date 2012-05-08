package aerys.minko.example.core.blending
{
	import aerys.minko.scene.node.mesh.Mesh;
	import aerys.minko.scene.node.mesh.geometry.primitive.CubeGeometry;
	import aerys.minko.type.data.DataProvider;
	import aerys.minko.type.enum.Blending;
	
	import com.bit101.utils.MinimalConfigurator;
	
	import flash.events.MouseEvent;

	/**
	 * This example demonstrate how to work with blending in order to create
	 * transparent objects.
	 * 
	 * @author Jean-Marc Le Roux
	 * 
	 */
	public class BlendingExample extends MinkoExampleApplication
	{
		private var _sharedProperties	: DataProvider	= new DataProvider({
			blending	: Blending.NORMAL
		});
		
		override protected function initializeScene():void
		{
			super.initializeScene();
			
			var red	: Mesh	= new Mesh(
				CubeGeometry.cubeGeometry,
				{ diffuseColor : 0xff000077 }
			);
			
			red.bindings.add(_sharedProperties);
			red.transform.appendTranslation(-1, 0, -1);
			
			var blue : Mesh = new Mesh(
				CubeGeometry.cubeGeometry,
				{ diffuseColor : 0x00ff0077 }
			);
			
			blue.bindings.add(_sharedProperties);
			blue.transform.appendTranslation(1, 0, -1);
			
			var green : Mesh = new Mesh(
				CubeGeometry.cubeGeometry,
				{ diffuseColor : 0x0000ff77 }
			);
			
			green.bindings.add(_sharedProperties);
			green.transform.appendTranslation(0, 0, 1);
			
			scene.addChild(red).addChild(blue).addChild(green);
		}
		
		override protected function initializeUI():void
		{
			super.initializeUI();
			
			var cfg : MinimalConfigurator = new MinimalConfigurator(this);
			
			cfg.parseXML(
				<comps>
					<Panel x="10" y="110">
						<VBox x="10" y="10">
							<Label text="Blending:"/>
							<RadioButton label="Normal" selected="true"
										 event="click:blendingChangedHandler"/>
							<RadioButton label="Alpha"
										 event="click:blendingChangedHandler"/>
							<RadioButton label="Additive"
										 event="click:blendingChangedHandler"/>
						</VBox>
					</Panel>
				</comps>
			);
		}
		
		public function blendingChangedHandler(event : MouseEvent) : void
		{
			switch (event.target.label)
			{
				case 'Normal' :
					_sharedProperties.blending = Blending.NORMAL;
					break ;
				case 'Alpha' :
					_sharedProperties.blending = Blending.ALPHA;
					break ;
				case 'Additive' :
					_sharedProperties.blending = Blending.ADDITIVE;
					break ;
			}
		}
	}
}