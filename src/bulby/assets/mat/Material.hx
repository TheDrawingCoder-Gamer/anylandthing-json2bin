package bulby.assets.mat;




class Material {
    public var name:String;
    public var diffuse:Color = Color.fromFloat(0.8, 0.8, 0.8);
    public var ambient:Color = Color.fromFloat(0.2, 0.2, 0.2);
    public var specular:Color = Color.fromFloat(1, 1, 1);
    public var alpha:Float = 1;
    public var shinyness:Float = 0;
    public var illum:Int = 2;
    public var isUnshaded = false;
    public var texture:Null<Image> = null;
    public function new(name:String, ?diffuse:Color, ?ambient:Color, ?specular:Color, alpha:Float = 1, shinyness:Float = 0, illum:Int = 2, ?texture:Null<Image>) {
        this.name = name;
        this.diffuse = diffuse != null ? diffuse : Color.fromFloat(0.8, 0.8, 0.8);
        this.ambient = ambient != null ? ambient : Color.fromFloat(0.2, 0.2, 0.2);
        this.specular = specular != null ? specular : Color.fromFloat(1, 1, 1);
        this.alpha = alpha;
        this.shinyness = shinyness;
        this.illum = illum;
        this.texture = texture;
    }
    public function copy():Material {
        var newDiffuse = new Color(diffuse.r, diffuse.g, diffuse.b);
        var newAmbient = new Color(ambient.r, ambient.g, ambient.b);
        var newSpecular = new Color(specular.r, specular.g, specular.b);
        var newImage = texture != null ? texture.copy() : null;
        return new Material(name, newDiffuse, newAmbient, newSpecular, alpha, shinyness, illum, newImage);
    }
    public function toMtl():String {
        return 'newmtl ${this.name}\n' +
            'Ka ${this.ambient.r} ${this.ambient.g} ${this.ambient.b}\n' +
            'Kd ${this.diffuse.r} ${this.diffuse.g} ${this.diffuse.b}\n' +
            'Ks ${this.specular.r} ${this.specular.g} ${this.specular.b}\n' +
            'Ns ${this.shinyness}\n' +
            'd ${this.alpha}\n' +
            'illum ${this.illum}\n';
    }
}