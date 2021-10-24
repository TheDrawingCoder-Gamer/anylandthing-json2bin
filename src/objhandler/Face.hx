package objhandler;

using Lambda;
@:structInit
class Face {
    public var vertices:Array<IndexRef> = [];
    public function new(vertices:Array<IndexRef>) {
        this.vertices = vertices;
    }  
}
class DirectFace {
    public var normals:Array<Vector4> = [];
    public var positions:Array<Vector4> = [];
    public var uvs:Array<Vector2> = [];
    public function new(normals:Array<Vector4>, positions:Array<Vector4>, uvs:Array<Vector2>, face:Face) {
        for (vert in face.vertices) {
            this.normals.push(normals[vert.normal]);
            this.positions.push(positions[vert.point]);
            this.uvs.push(uvs[vert.uv]);
        }
    }
    public function toFaceForMesh(mesh:Mesh):Face {
        var face:Face = new Face([]);
        for (i in 0...this.positions.length) {
            face.vertices.push({
                normal :  mesh.normals.indexOf(this.normals[i]),
                point : mesh.positions.indexOf(this.positions[i]),
                uv : mesh.uvs.indexOf(this.uvs[i])
            });
        }
        return face;
            
    }
}