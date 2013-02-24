package aerys.minko.example.core.variance
{
	import aerys.minko.render.geometry.primitive.SphereGeometry;
	import aerys.minko.render.material.basic.BasicMaterial;
	import aerys.minko.render.shader.part.phong.attenuation.LightBleedingInterpolation;
	import aerys.minko.scene.controller.AnimationController;
	import aerys.minko.scene.node.Group;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.scene.node.light.PointLight;
	import aerys.minko.type.animation.timeline.ITimeline;
	import aerys.minko.type.animation.timeline.MatrixTimeline;
	import aerys.minko.type.enum.ShadowMappingType;
	import aerys.minko.type.math.Matrix4x4;

	public class VariancePointLightExample extends AbstractLightExampleApplication
	{
		private var _done : Boolean = false;
		
		override protected function initializeLights() : void
		{
            super.initializeLights();
            
			cameraController.maxDistance = 100;
			cameraController.distance = 75;
			
			var pointLight : PointLight		= new PointLight();
			var lightGroup : Group			= new Group(
				pointLight,
				new Mesh(SphereGeometry.sphereGeometry, new BasicMaterial({diffuseColor:0xffffffff}))
			);
			
			pointLight.shadowCastingType			= ShadowMappingType.VARIANCE;
            pointLight.shadowZNear          		= 0.1;
            pointLight.shadowZFar           		= 200.;
			pointLight.shadowMapSize				= 1024;
            pointLight.attenuationDistance  		= 80;
			pointLight.lightBleedingBias			= 0.1;
			pointLight.lightBleedingInterpolation	= LightBleedingInterpolation.SMOOTHSTEP;
			
			lightGroup.addController(new AnimationController(new <ITimeline>[new MatrixTimeline(
				'transform',
				new <uint>[
                    0,
                    5000,
                    10000
                ],
				new <Matrix4x4>[
					new Matrix4x4().appendTranslation(0, 25),
					new Matrix4x4().appendTranslation(0, -25),
                    new Matrix4x4().appendTranslation(0, 25)
				],
				true
			)]));
            
			scene.addChild(lightGroup);
		}
	}
}
