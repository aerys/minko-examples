package aerys.minko.example.core.stencil 
{
	import aerys.minko.render.effect.basic.BasicShader;
	import aerys.minko.render.effect.Effect;
	import aerys.minko.render.resource.texture.TextureResource;
	import aerys.minko.scene.node.Group;
	import aerys.minko.scene.node.mesh.geometry.Geometry;
	import aerys.minko.scene.node.mesh.geometry.primitive.QuadGeometry;
	import aerys.minko.scene.node.mesh.Mesh;
	import aerys.minko.type.enum.DepthTest;
	import aerys.minko.type.enum.StencilActions;
	import aerys.minko.type.math.Vector4;
	import aerys.minko.type.stream.IVertexStream;
	import aerys.minko.type.stream.StreamUsage;
	import aerys.minko.type.stream.VertexStream;
	import flash.display.Bitmap;
	
	/**
	 * This example shows how to use stencil operations with Minko 3D 2.0b
	 * @author Palinkas, Adam
	 */
	public class StencilExample extends MinkoExampleApplication
	{		
		[Embed("../../../../../../assets/wall.png")] public static const TEXTURES:Class;
		
		override protected function initializeScene():void
		{			
			viewport.backgroundColor = 0x222222ff;
			
			// create the mask
			// its just the missing top of the hole cube geometry, acts like a window 
			// (portals drawn with almost the same concept but with a lot more passes
			var mask:Mesh = new Mesh(
				QuadGeometry.quadGeometry,
				{ 
					depthWriteEnabled : false, // disable depth write so objects behind can be displayed
					diffuseColor : 0x00FF00FF, // not really important, for debug purposes only
					stencilCompareMode: DepthTest.EQUAL,
					stencilActionOnBothPass: StencilActions.INCREMENT_SATURATE, // this is important! stencil buffer gets incremented
					stencilReferenceValue: 0 // original value
				},
				new Effect(
					new BasicShader(null, 2) // order of passes are important this is the first pass
				)
			);			
			// position the mask like if it were the top of the hole
			mask.transform.appendTranslation( 0, 0.5, 0.0 ); 
			mask.transform.rotationX = Math.PI / 180 * 90;	
			
			// create the hole with a cube like geometry:
			// inverted faces, and no top, uvs are also modified according to the structrue
			var xyz 	: Vector.<Number> = new <Number>[
				0.5, -0.5, -0.5, 0.5, -0.5, 0.5, -0.5, -0.5, -0.5,
				-0.5, -0.5, -0.5, 0.5, -0.5, 0.5, -0.5, -0.5, 0.5,
				0.5, 0.5, 0.5, -0.5, 0.5, 0.5, 0.5, -0.5, 0.5,
				-0.5, -0.5, 0.5, 0.5, -0.5, 0.5, -0.5, 0.5, 0.5,
				0.5, 0.5, -0.5, -0.5, -0.5, -0.5, -0.5, 0.5, -0.5,
				0.5, 0.5, -0.5, 0.5, -0.5, -0.5, -0.5, -0.5, -0.5,
				-0.5, -0.5, 0.5, -0.5, 0.5, 0.5, -0.5, -0.5, -0.5,
				-0.5, 0.5, -0.5, -0.5, -0.5, -0.5, -0.5, 0.5, 0.5,
				0.5, 0.5, -0.5, 0.5, 0.5, 0.5, 0.5, -0.5, 0.5,
				0.5, -0.5, 0.5, 0.5, -0.5, -0.5, 0.5, 0.5, -0.5,
			];
			var uv : Vector.<Number>	= new <Number>[
				0., 1., 1., 1., 0., 0.,
				0., 0., 1., 1., 1., 0.,				
				1., 1., 0., 1., 1., 0.,
				0., 0., 1., 0., 0., 1.,
				1., 0., 0., 1., 0., 0.,
				1., 0., 1., 1., 0., 1.,
				0., 1., 0., 0., 1., 1.,
				1., 0., 1., 1., 0., 0.,
				1., 1., 1., 0., 0., 0.,
				0., 0., 0., 1., 1., 1.
			];
			var vstream:Vector.<IVertexStream> = new <IVertexStream>[VertexStream.fromPositionsAndUVs(xyz, uv, StreamUsage.DYNAMIC)];				
			var texture:TextureResource = new TextureResource( 512, 512 );
			var bmp:Bitmap = new TEXTURES();
			texture.setContentFromBitmapData( bmp.bitmapData, true );			
			var hole:Mesh = new Mesh( 
				new Geometry( vstream, null ),
				{					
					diffuseMap : texture,
					stencilCompareMode: DepthTest.EQUAL,
					stencilActionOnBothPass: StencilActions.KEEP, // we don't want the stencil buffer get affected by this object
					stencilReferenceValue: 1 // this object only get drawn where stencil incremented by
				},
				new Effect(
					new BasicShader(null, 1) // order of passes are important this is the second pass
				)
			);
			
			var group:Group = new Group();
			group.addChild( mask ).addChild( hole );			
			scene.addChild( group );	
			group.transform.appendRotation( Math.PI / 180 * -90, Vector4.X_AXIS );			
		}
	}
}