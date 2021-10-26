package bulby.assets;

import bulby.cloner.Cloner;
import bulby.assets.Mesh;
import bulby.BulbyMath.roundf;
class Node {
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
                for (vert in face) {
                    vert.normal += totalN;
                    vert.position += totalP;
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
    public function toObj() {
		var file = "# Export of Bulby's Anyland converter \nmtllib output.mtl\ng ALThing\n";
		for (mesh in this.children) {
			for (pos in mesh.displayPositions) {
				file += 'v ${roundf(pos.x, 7)} ${roundf(pos.y, 7)} ${roundf(pos.z, 7)}\n';
			}
		}
		for (mesh in this.children) {
			for (normal in mesh.displayNormals) {
				file += 'vn ${roundf(normal.x, 7)} ${roundf(normal.y, 7)} ${roundf(normal.z, 7)}\n';
			}
		}
		for (mesh in this.children) {
			for (uv in mesh.uvs) {
				file += 'vt ${roundf(uv.x, 7)} ${roundf(uv.y, 7)}\n';
			}
		}
		var totalP = 0;
		var totalU = 0;
		var totalN = 0;
		for (mesh in this.children) {
			file += 'usemtl ${mesh.material.name}\n';
			for (face in mesh.faces) {
				final v1 = face.v1;
				final v2 = face.v2;
				final v3 = face.v3;
				file += 'f ${v1.position + 1 + totalP}/${v1.uv + 1 + totalU}/${v1.normal + 1 + totalN} ${v2.position + 1 + totalP}/${v2.uv + 1 + totalU}/${v2.normal + 1 + totalN} ${v3.position + 1 + totalP}/${v3.uv + 1 + totalU}/${v3.normal + 1 + totalN}\n';
			}
			totalP += mesh.positions.length;
			totalU += mesh.uvs.length;
			totalN += mesh.normals.length;
		}
		var mtl = "";
		for (mesh in this.children) {
			var result = mesh.material.toMtl();
			if (mtl.indexOf(result) == -1) {
				mtl += result;
			}
		}
		return {obj: file, mtl: mtl};
    }
	public static function filteri<A>(it:Array<A>, f:(item:A, index:Int) -> Bool) {
        return [for (i in 0...Lambda.count(it, (_) -> true )) if (f(it[i], i)) it[i]];
    }
}