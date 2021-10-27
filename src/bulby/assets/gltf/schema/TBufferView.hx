package bulby.assets.gltf.schema;

typedef TBufferView = {
	var buffer:TGLTFID;
	@:optional var byteOffset:Int;
	var byteLength:Int;
	@:optional var byteStride:Int;
	@:optional var target:TBufferTarget;
}