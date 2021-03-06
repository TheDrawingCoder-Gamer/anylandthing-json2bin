package bulby.assets.b3d;

using objhandler.ArrayTools;
private typedef TriRaw = {
    var v1:VertRef;
    var v2:VertRef;
    var v3:VertRef;
}
private typedef DirectTriRaw = {
    var v1:Vertex;
    var v2:Vertex;
    var v3:Vertex;
}
@:forward
abstract Tri(TriRaw) {
    public function new(v1:VertRef, v2:VertRef, v3:VertRef) {
        this = {v1: v1, v2: v2, v3: v3};
    }
    public function iterator():Iterator<VertRef> {
        return [this.v1, this.v2, this.v3].iterator();
    }
    public function copy():Tri {
        return new Tri(new VertRef(this.v1.position, this.v1.normal, this.v1.uv),
                       new VertRef(this.v2.position, this.v2.normal, this.v2.uv),
                       new VertRef(this.v3.position, this.v3.normal, this.v3.uv));
    }
    public function toString() {
        return 'Tri {${this.v1} ${this.v2} ${this.v3}}';
    }
 }

@:forward 
abstract DirectTri(DirectTriRaw) {
    public function new(v1:Vertex, v2:Vertex, v3:Vertex) {
        this = {v1: v1, v2: v2, v3: v3};
    }
    public static function fromTriAndMesh(tri:Tri, mesh:Mesh) {
        return new DirectTri(new Vertex(mesh.positions[tri.v1.position], mesh.uvs[tri.v1.uv], mesh.normals[tri.v1.normal]),
                             new Vertex(mesh.positions[tri.v2.position], mesh.uvs[tri.v2.uv], mesh.normals[tri.v2.normal]),
                             new Vertex(mesh.positions[tri.v3.position], mesh.uvs[tri.v3.uv], mesh.normals[tri.v3.normal]));
    }
    public function toTriForMesh(mesh:Mesh) {
		return new Tri(new VertRef(mesh.positions.indexOfVector3(this.v1.position), mesh.normals.indexOfVector3(this.v1.normal),  mesh.uvs.indexOfVector2(this.v1.uv)),
			new VertRef(mesh.positions.indexOfVector3(this.v2.position), mesh.normals.indexOfVector3(this.v2.normal), mesh.uvs.indexOfVector2(this.v2.uv)),
			new VertRef(mesh.positions.indexOfVector3(this.v3.position), mesh.normals.indexOfVector3(this.v3.normal), mesh.uvs.indexOfVector2(this.v3.uv)));
    }
    public function iterator():Iterator<Vertex> {
        return [this.v1, this.v2, this.v3].iterator();
    }
}