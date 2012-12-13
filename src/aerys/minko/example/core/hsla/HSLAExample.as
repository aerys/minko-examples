package aerys.minko.example.core.hsla
{
    import aerys.minko.example.core.directionallight.DirectionalLightExample;
    import aerys.minko.example.core.spotlight.SpotLightExample;
    import aerys.minko.scene.node.Mesh;
    import aerys.minko.type.enum.Blending;
    import aerys.minko.type.math.HSLAMatrix4x4;
    
    import com.bit101.utils.MinimalConfigurator;
    
    import flash.events.Event;
    import flash.events.MouseEvent;
    
    public class HSLAExample extends SpotLightExample
    {
        private var _colorTransform : HSLAMatrix4x4;
        
        override protected function initializeScene() : void
        {
            super.initializeScene();
            
            _colorTransform = new HSLAMatrix4x4();
            
            for each (var mesh : Mesh in scene.get("//mesh[name='teapot']"))
            {
                mesh.material.diffuseTransform = _colorTransform;
                mesh.material.blending = Blending.ALPHA;
            }
        }
        
        override protected function initializeUI() : void
        {
            var cfg : MinimalConfigurator = new MinimalConfigurator(this);
            
            cfg.parseXML(
                <comps>
                    <Panel width="200" x="10" y="10">
                        <HBox x="10" y="10">
                            <HSlider name="hue"
                                     event="change:sliderChangedHandler"
                                     minimum="0" maximum="1" value="0"/>
                            <Label text="Hue"/>
                        </HBox>
                        <HBox x="10" y="30">
                            <HSlider name="saturation"
                                     event="change:sliderChangedHandler"
                                     minimum="0" maximum="1" value="1"/>
                            <Label text="Saturation"/>
                        </HBox>
                        <HBox x="10" y="50">
                            <HSlider name="luminance"
                                     event="change:sliderChangedHandler"
                                     minimum="0" maximum="1" value="1"/>
                            <Label text="Luminance"/>
                        </HBox>
                        <HBox x="10" y="70">
                            <HSlider name="alpha"
                                     event="change:sliderChangedHandler"
                                     minimum="0" maximum="1" value="1"/>
                            <Label text="Alpha"/>
                        </HBox>
                    </Panel>
                </comps>
            );
        }
        
        public function sliderChangedHandler(event : Event) : void
        {
            switch (event.target.name)
            {
                case 'hue':
                    _colorTransform.hue = event.target.value;
                    break;
                case 'luminance':
                    _colorTransform.luminance = event.target.value;
                    break;
                case 'saturation':
                    _colorTransform.saturation = event.target.value;
                    break;
                case 'alpha':
                    _colorTransform.alpha = event.target.value;
                    break;
            }
        }
    }
}