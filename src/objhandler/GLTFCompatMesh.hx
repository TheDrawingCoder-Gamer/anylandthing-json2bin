package objhandler;

class GLTFCompatMesh {
    public var material:Material;
    public var verticies:Array<Vertex>;
    public var faces:Array<Array<Int>>;
    public function new(material:Material, verticies:Array<Vertex>, faces:Array<Array<Int>>):Void {
        this.material = material;
        this.verticies = verticies;
        this.faces = faces;
    }
    public static function fromMesh(mesh:Mesh) {
        var verts:Array<Vertex> = [];
        var faces:Array<Array<Int>> = [];
        var i = 0;
        for (face in mesh.faces) {
            var faceVerts = [];
            for (vert in face.vertices) {
                // don't check for normal : )
                // Ignore uv outright if no texture (probably causes some wonky results)
                var foundIndex = Lambda.findIndex(verts, (v) -> v.position == mesh.displayPositions[vert.point] && (v.uv == mesh.uvs[vert.uv] || mesh.material.texture == "") );
                if (foundIndex != -1) {
                    faceVerts.push(foundIndex);
                    // Me when I average the normals
                    verts[foundIndex].normal = (verts[foundIndex].normal + mesh.displayNormals[vert.normal]) / 2;
                } else {
					verts.push(new Vertex(mesh.displayPositions[vert.point], mesh.uvs[vert.uv], mesh.displayNormals[vert.normal]));
                    faceVerts.push(i++);
                }
                    
                
            }
            faces.push(faceVerts);
        }
        return new GLTFCompatMesh(mesh.material, verts, faces);
    }
}