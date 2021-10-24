package objhandler;

import bulby.cloner.Cloner;

class Node implements INode {
    public var children:Array<Mesh>;
    public function new(children:Array<Mesh>) {
        this.children = children;
    }
    /**
     * Returns a mesh that is a merge of all children. Note scaling does NOT reset and is taken into account.
     */
    
    public function mergeAllChildren() {
        var mesh = new Mesh([], [], [], [], false);
        var totalP = 0;
        var totalU = 0;
        var totalN = 0;
        for (child in children) {
            var cChild = Cloner.clone(child);
            

            for (face in cChild.faces) {
                for (vert in face.vertices) {
                    vert.normal += totalN;
                    vert.point += totalP;
                    vert.uv += totalU;
                }
            }
			totalP += cChild.positions.length;
			totalU += cChild.uvs.length;
			totalN += cChild.normals.length;
            mesh.faces = mesh.faces.concat(cChild.faces);
            mesh.displayNormals = mesh.normals.concat(cChild.displayNormals);
            mesh.displayPositions = mesh.positions.concat(cChild.displayPositions);
            mesh.uvs = mesh.uvs.concat(cChild.uvs);
        }
        mesh.normals = mesh.displayNormals;
        mesh.positions = mesh.displayPositions;
        mesh.optimize();
        return mesh;
    }
    
	public static function filteri<A>(it:Array<A>, f:(item:A, index:Int) -> Bool) {
        return [for (i in 0...Lambda.count(it, (_) -> true )) if (f(it[i], i)) it[i]];
    }
}

interface INode {
    var children:Array<Mesh>;
}