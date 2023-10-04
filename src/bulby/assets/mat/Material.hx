package bulby.assets.mat;

enum Extensions {
	Clearcoat(?clearcoatFactor:Float, ?clearcoatTexture:Image, ?clearcoatRoughnessFactor:Float, ?clearcoatRoughnessTexture:Image,
		?clearcoatNormalTexture:Image);
	Ior(?ior:Float);
	Sheen(?sheenColorFactor:Color, ?sheenColorTexture:Image, ?sheenRoughnessFactor:Float, ?sheenRoughnessTexture:Image);
	Specular(?specularFactor:Float, ?specularTexture:Image, ?specularColorFactor:Color, ?specularColorTexture:Image);
	Transmission(?transmissionFactor:Float, ?transmissionTexture:Image);
	Unlit;
	Volume(?thicknessFactor:Float, ?thicknessTexture:Image, ?attenuationDistance:Float, ?attenuationColor:Color);
}

class Material {
	public var name:String;
	public var diffuse:Color = Color.fromFloat(0.8, 0.8, 0.8);
	public var metalness:Float = 0.0;
	public var roughness:Float = 0;
	public var isUnshaded = false;
	public var texture:Null<Image> = null;
	public var normalTexture:Null<Image> = null;
	public var extensions:Array<Extensions> = [];

	public function new(name:String, ?diffuse:Color, metalness:Float = 0, roughness:Float = 0, ?texture:Null<Image>, ?normalTexture:Null<Image>,
			?extensions:Array<Extensions>):Void {
		this.name = name;
		this.diffuse = diffuse != null ? diffuse : Color.fromFloat(0.8, 0.8, 0.8);
		this.metalness = metalness;
		this.roughness = roughness;
		this.texture = texture;
		this.normalTexture = normalTexture;
		extensions = extensions != null ? extensions : [];
	}

	public function copy():Material {
		var newDiffuse = new Color(diffuse.r, diffuse.g, diffuse.b);
		var newImage = texture != null ? texture.copy() : null;
		var newNormalImage = normalTexture != null ? normalTexture.copy() : null;
		return new Material(name, newDiffuse, metalness, roughness, newImage, newNormalImage, extensions.copy());
	}
	/*
		public function toMtl():String {
			return 'newmtl ${this.name}\n' +
				'Ka ${this.ambient.r} ${this.ambient.g} ${this.ambient.b}\n' +
				'Kd ${this.diffuse.r} ${this.diffuse.g} ${this.diffuse.b}\n' +
				'Ks ${this.specular.r} ${this.specular.g} ${this.specular.b}\n' +
				'Ns ${this.shinyness}\n' +
				'd ${this.alpha}\n' +
				'illum ${this.illum}\n';
		}
	 */
}
