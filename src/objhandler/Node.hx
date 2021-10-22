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
        var mesh = new Mesh([], [], []);
        var totalIdx = 0;
        for (child in children) {
            var cChild = Cloner.clone(child);
            for (i in 0...cChild.idx.length) {
                cChild.idx[i] += totalIdx;
            }
            for (face in cChild.faces) {
                for (vert in face.vertices) {
                    vert.normal += totalIdx;
                    vert.point += totalIdx;
                    vert.uv += totalIdx;
                }
            }
            mesh.faces = mesh.faces.concat(cChild.faces);
            mesh.points = mesh.points.concat(cChild.points);
            mesh.idx = mesh.idx.concat(cChild.idx);
        }
		var concerningPoints = filteri(mesh.points, (item, index) -> Lambda.findIndex(mesh.points, (itm) -> item.equals(itm)) == index);
        for (face in mesh.faces) {
            for (vert in face.vertices) {
                // If they aren't the same (literally, taking into account objects w/ the same values for fields are still not the same)
                if (mesh.getVert(vert.point) != concerningPoints[mesh.idx[vert.point]]) 
                    vert.point = Lambda.findIndex(concerningPoints, (item) -> item.equals(mesh.getVert(vert.point)));
                if (mesh.getVert(vert.normal) != concerningPoints[mesh.idx[vert.normal]])
					vert.normal = Lambda.findIndex(concerningPoints, (item) -> item.equals(mesh.getVert(vert.normal)));
				if (mesh.getVert(vert.uv) != concerningPoints[mesh.idx[vert.uv]])
					vert.uv = Lambda.findIndex(concerningPoints, (item) -> item.equals(mesh.getVert(vert.uv)));
            }
        }
        mesh.points = concerningPoints;
        mesh._originalPoints = mesh.points;
        mesh.idx.resize(mesh.points.length);
        return mesh;
    }
	private function filteri<A>(it:Iterable<A>, f:(item:A, index:Int) -> Bool) {
        return [for (i in 0...Lambda.count(it, (_) -> true )) if (f(Lambda.array(it)[i], i)) Lambda.array(it)[i]];
    }
}

interface INode {
    var children:Array<Mesh>;
}