package bulby.assets.gltf.schema;

@:enum abstract TMinFilter(Int) {
	var NEAREST = 9728;
	var LINEAR = 9729;
	var NEAREST_MIPMAP_NEAREST = 9984;
	var LINEAR_MIPMAP_NEAREST = 9985;
	var NEAREST_MIPMAP_LINEAR = 9986;
	var LINEAR_MIPMAP_LINEAR = 9987;
}
