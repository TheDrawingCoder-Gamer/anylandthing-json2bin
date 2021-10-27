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
abstract Tri(TriRaw) from TriRaw {
    public function new(v1:VertRef, v2:VertRef, v3:VertRef) {
        this = {v1: v1, v2: v2, v3: v3};
    }
    public function iterator():Iterator<VertRef> {
        return [this.v1, this.v2, this.v3].iterator();
    }
}

@:forward 
abstract DirectTri(DirectTriRaw) from DirectTriRaw {
    public function new(v1:Vertex, v2:Vertex, v3:Vertex) {
        this = {v1: v1, v2: v2, v3: v3};
    }
    public static function fromTriAndMesh(tri:Tri, mesh:Mesh) {
        return new DirectTri(new Vertex(mesh.displayPositions[tri.v1.position], mesh.uvs[tri.v1.uv], mesh.displayNormals[tri.v1.normal]),
                             new Vertex(mesh.displayPositions[tri.v2.position], mesh.uvs[tri.v2.uv], mesh.displayNormals[tri.v2.normal]),
                             new Vertex(mesh.displayPositions[tri.v3.position], mesh.uvs[tri.v3.uv], mesh.displayNormals[tri.v3.normal]));
    }
    public function toTriForMesh(mesh:Mesh) {
        return new Tri(new VertRef(mesh.displayPositions.indexOfVector3(this.v1.position), mesh.uvs.indexOfVector2(this.v1.uv), mesh.displayNormals.indexOfVector3(this.v1.normal)),
                       new VertRef(mesh.displayPositions.indexOfVector3(this.v2.position), mesh.uvs.indexOfVector2(this.v2.uv), mesh.displayNormals.indexOfVector3(this.v2.normal)),
                       new VertRef(mesh.displayPositions.indexOfVector3(this.v3.position), mesh.uvs.indexOfVector2(this.v3.uv), mesh.displayNormals.indexOfVector3(this.v3.normal)));
    }
    public function iterator():Iterator<Vertex> {
        return [this.v1, this.v2, this.v3].iterator();
    }
}