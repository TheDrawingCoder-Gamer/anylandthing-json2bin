package bulby.assets.gltf.schema;

typedef TImage = {
	@:optional var uri:String;
	var mimeType:String;
	@:optional var bufferView:TGLTFID;
}