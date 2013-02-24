package aerys.minko.example.core.stencil 
{
	import aerys.minko.render.geometry.primitive.CubeGeometry;
	import aerys.minko.render.geometry.primitive.QuadGeometry;
	import aerys.minko.render.material.basic.BasicMaterial;
	import aerys.minko.scene.node.Group;
	import aerys.minko.scene.node.Mesh;
	import aerys.minko.type.enum.DepthTest;
	import aerys.minko.type.enum.StencilAction;
	import aerys.minko.type.enum.TriangleCulling;
	import aerys.minko.type.loader.TextureLoader;
	import aerys.minko.type.math.Vector4;
	
	/**
	 * This example shows how to use stencil operations with Minko 3D 2.0b
	 * @author Palinkas, Adam
	 */
	public class StencilExample extends AbstractExampleApplication
	{		
		[Embed("../assets/wall.png")]
		private static const TEXTURE	: Class;
		
		override protected function initializeScene():void
		{
			super.initializeScene();
			
			// create the mask
			// its just the missing top of the hole cube geometry, acts like a window 
			// (portals drawn with almost the same concept but with a lot more passes
			var mask : Mesh = new Mesh(
				QuadGeometry.quadGeometry,
				new BasicMaterial({ 
					// disable depth write so objects behind can be displayed
					depthWriteEnabled 		: false, 
					stencilCompareMode		: DepthTest.EQUAL,
					// this is important! stencil buffer gets incremented
					stencilActionOnBothPass	: StencilAction.INCREMENT_SATURATE,
					// stencil reference value
					stencilReferenceValue	: 0,
					// not really important, for debug purposes only
					diffuseColor 			: 0x00FF00FF
				})
			);
			// position the mask like if it was the top of the hole
			mask.transform.appendTranslation(0, 0.5, 0.0); 
			mask.transform.rotationX = Math.PI / 180 * 90;	
			
			var hole : Mesh = new Mesh(
				CubeGeometry.cubeGeometry,
				new BasicMaterial({
					triangleCulling			: TriangleCulling.FRONT,
					diffuseMap 				: TextureLoader.loadClass(TEXTURE),
					stencilCompareMode		: DepthTest.EQUAL,
					// we don't want the stencil buffer get affected by this object
					stencilActionOnBothPass	: StencilAction.KEEP,
					// this object only get drawn where stencil incremented by
					stencilReferenceValue	: 1
				})
			);
			
			var group : Group = new Group(mask, hole);
			
			group.transform.appendRotation(Math.PI / 180 * -90, Vector4.X_AXIS);
			scene.addChild(group);
		}
	}
}