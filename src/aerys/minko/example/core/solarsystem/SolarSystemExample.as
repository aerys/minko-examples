package aerys.minko.example.core.solarsystem
{
	import aerys.minko.render.geometry.primitive.SphereGeometry;
	import aerys.minko.render.material.basic.BasicMaterial;
	import aerys.minko.scene.node.Group;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.type.math.Vector4;
	
	import flash.events.Event;

	public class SolarSystemExample extends AbstractExampleApplication
	{
		private var _sun		: Mesh;
		private var _mercury	: Mesh;
		private var _venus		: Mesh;
		private var _earth		: Mesh;
		private var _mars		: Mesh;
		private var _neptune	: Mesh;
		private var _jupiter	: Mesh;
		private var _uranus		: Mesh;
		
		override protected function initializeScene() : void
		{
			super.initializeScene();
			
			cameraController.distance = 60;
			cameraController.pitch = 1.3;
			
			viewport.backgroundColor = 0;
			
			var sphere : SphereGeometry = new SphereGeometry(30);
			
			_sun = new Mesh(sphere, new BasicMaterial({diffuseColor:0xffff00ff}));
			_sun.transform.appendUniformScale(10);
			
			_mercury = new Mesh(sphere, new BasicMaterial({diffuseColor:0x7f7f7fff}));
			_mercury.transform
				.lock()
				.appendUniformScale(.5)
				.appendTranslation(7)
				.unlock();
			
			_venus = new Mesh(sphere, new BasicMaterial({diffuseColor:0x7f7f7fff}));
			_venus.transform
				.lock()
				.appendUniformScale(.7)
				.appendTranslation(9)
				.unlock();
			
			_earth = new Mesh(sphere, new BasicMaterial({diffuseColor:0x0000ffff}));
			_earth.transform
				.lock()
				.appendUniformScale(1)
				.appendTranslation(11)
				.unlock();
			
			_mars = new Mesh(sphere, new BasicMaterial({diffuseColor:0xff7f00ff}));
			_mars.transform
				.lock()
				.appendUniformScale(0.6)
				.appendTranslation(14)
				.unlock();
			
			_neptune = new Mesh(sphere, new BasicMaterial({diffuseColor:0x7F7F7Fff}));
			_neptune.transform.appendTranslation(20);
			
			_jupiter = new Mesh(sphere, new BasicMaterial({diffuseColor:0x7fffffff}));
			_jupiter.transform
				.lock()
				.appendUniformScale(3.2)
				.appendTranslation(-23)
				.unlock();
			
			_uranus = new Mesh(sphere, new BasicMaterial({diffuseColor:0xddffffff}));
			_uranus.transform
				.lock()
				.appendUniformScale(2.2)
				.appendTranslation(29)
				.unlock();
			
			scene
				.addChild(_sun).addChild(_mercury).addChild(_venus)
				.addChild(_earth).addChild(_mars)
				.addChild(_neptune).addChild(_jupiter).addChild(_uranus);
		}
		
		override protected function enterFrameHandler(event:Event):void
		{
			_mercury.transform.appendRotation(.025, Vector4.Y_AXIS);
			_venus.transform.appendRotation(.015, Vector4.Y_AXIS);
			_earth.transform.appendRotation(.02, Vector4.Y_AXIS);
			_mars.transform.appendRotation(.0125, Vector4.Y_AXIS);
			_neptune.transform.appendRotation(0.005, Vector4.Y_AXIS);
			_jupiter.transform.appendRotation(0.003, Vector4.Y_AXIS);
			_uranus.transform.appendRotation(0.002, Vector4.Y_AXIS);
			
			super.enterFrameHandler(event);
		}
	}
}