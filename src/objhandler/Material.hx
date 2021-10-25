package objhandler;

import thinghandler.Color;

class Material {
    public var name:String;
    public var diffuse:Color = new Color(0.8, 0.8, 0.8);
    public var ambient:Color = new Color(0.2, 0.2, 0.2);
    public var specular:Color = new Color(1, 1, 1);
    public var alpha:Float = 1;
    public var shinyness:Float = 0;
    public var illum:Int = 2;
    public function new(name:String, ?diffuse:Color, ?ambient:Color, ?specular:Color, alpha:Float = 1, shinyness:Float = 0, illum:Int = 2) {
        this.name = name;
        this.diffuse = diffuse != null ? diffuse : new Color(0.8, 0.8, 0.8);
        this.ambient = ambient != null ? ambient : new Color(0.2, 0.2, 0.2);
        this.specular = specular != null ? specular : new Color(1, 1, 1);
        this.alpha = alpha;
        this.shinyness = shinyness;
        this.illum = illum;
    }
}