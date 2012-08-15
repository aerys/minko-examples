package aerys.minko.example.lighting.point
{
	import aerys.minko.example.lighting.AbstractLightExampleApplication;
	import aerys.minko.render.geometry.primitive.SphereGeometry;
	import aerys.minko.render.material.basic.BasicMaterial;
	import aerys.minko.scene.controller.AnimationController;
	import aerys.minko.scene.node.Group;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.scene.node.light.AmbientLight;
	import aerys.minko.scene.node.light.PointLight;
	import aerys.minko.type.animation.timeline.ITimeline;
	import aerys.minko.type.animation.timeline.MatrixRegularTimeline;
	import aerys.minko.type.enum.ShadowMappingType;
	import aerys.minko.type.math.Matrix4x4;

	public class PointLightExample extends AbstractLightExampleApplication
	{
		private var _done : Boolean = false;
		
		override protected function initializeLights() : void
		{
			cameraController.maxDistance = 100;
			cameraController.distance = 75;
			
			var pointLight : PointLight		= new PointLight();
			var lightGroup : Group			= new Group(
				pointLight,
				new Mesh(SphereGeometry.sphereGeometry, new BasicMaterial({diffuseColor:0xffffffff}))
			);
			
			pointLight.shadowCastingType	= ShadowMappingType.CUBE;
			pointLight.shadowMapSize		= 256;
			
			lightGroup.addController(new AnimationController(new <ITimeline>[new MatrixRegularTimeline(
				'transform',
				5000,
				new <Matrix4x4>[
					new Matrix4x4(),
					new Matrix4x4().appendTranslation(0, 25),
					new Matrix4x4().appendTranslation(0, -25),
					new Matrix4x4()
				]
			)]));
			
			scene.addChild(new AmbientLight(0xffffffff, .2)).addChild(lightGroup);
		}
	}
}
