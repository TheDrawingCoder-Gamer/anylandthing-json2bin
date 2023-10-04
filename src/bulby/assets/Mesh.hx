package bulby.assets;

import bulby.assets.b3d.Tri;
import bulby.assets.b3d.VertRef;
import bulby.cloner.Cloner;
import bulby.assets.mat.Material;
import bulby.BulbyMath;
using objhandler.ArrayTools;
class Mesh {
    public function new(positions:Array<Vector3>, normals:Array<Vector3>, uvs:Array<Vector2>,faces:Array<Tri>, dooptimize:Bool = true, ?material:Material) {
        this.positions = positions;
        this.normals = normals;
        this.uvs = uvs;
        this.displayNormals = normals;
        this.displayPositions = positions;
        this.faces = faces;
        this.material = material != null ? material : new Material("default");
        if (dooptimize)
            optimize();
    }
    public function optimize() {
        var optimizedPos = [for (pos in positions) new Vector3(pos.x, pos.y, pos.z)];
        var optimizedNormals = [for (normal in normals) new Vector3(normal.x, normal.y, normal.z)];
        var optimizedUvs = [for (uv in uvs) new Vector2(uv.x, uv.y)];
        var newFaces = [for (tri in this.faces) DirectTri.fromTriAndMesh(tri, this)];

		this.positions = [for (index => item in optimizedPos) if (item != null && optimizedPos.indexOfVector3(item) == index) item];
        this.normals = [for (index => item in optimizedNormals) if (optimizedNormals.indexOfVector3(item) == index) item];
        this.uvs = [for (index => item in optimizedUvs) if (optimizedUvs.indexOfVector2(item) == index) item];
        applyTransformations();
        faces = [for (tri in newFaces) tri.toTriForMesh(this)];
    }
    public function copy() {
        var newPos = [for (pos in positions) new Vector3(pos.x, pos.y, pos.z)];
        var newNormals = [for (normal in normals) new Vector3(normal.x, normal.y, normal.z)];
        var newUvs = [for (uv in uvs) new Vector2(uv.x, uv.y)];
        var newFaces = [for (tri in faces) tri.copy()];
        var newMaterial = material.copy();
        return new Mesh(newPos, newNormals, newUvs, newFaces, false, newMaterial);
    }
    public function applyTransformations() {
        var positionsToEdit = [for (pos in positions) new Vector3(pos.x, pos.y, pos.z)];
        var normalsToEdit = [for (normal in normals) new Vector3(normal.x, normal.y, normal.z)];
        var mRot = this.rotation;
        var mTrans = Matrix4.translation(this.translation.x, this.translation.y, this.translation.z);
        var mScale = Matrix4.scale(this.scale.x, this.scale.y, this.scale.z);
        for (i in 0...positionsToEdit.length) {
            var convertedPos = new Vector4(positionsToEdit[i].x, positionsToEdit[i].y, positionsToEdit[i].z, 1);
            convertedPos = mTrans * (mRot * (mScale * convertedPos));
            positionsToEdit[i] = new Vector3(convertedPos.x, convertedPos.y, convertedPos.z);
           
        }
        for (i in 0...normalsToEdit.length) {
			var convertedNorm = new Vector4(normalsToEdit[i].x, normalsToEdit[i].y, normalsToEdit[i].z, 0);
			convertedNorm = mTrans * (mRot * (mScale * convertedNorm));
			normalsToEdit[i] = new Vector3(convertedNorm.x, convertedNorm.y, convertedNorm.z);
        }
        displayNormals = normalsToEdit;
        displayPositions = positionsToEdit;
    }
    public var scale:Vector3 = new Vector3(1, 1, 1);
    public var translation:Vector3 = Vector3.empty();
    public var rotation:Quaternion = Quaternion.identity();
    public var normals:Array<Vector3>;
    public var displayNormals:Array<Vector3>;
    public var positions:Array<Vector3>;
    public var displayPositions:Array<Vector3>;
    public var uvs:Array<Vector2>;
    public var faces:Array<Tri>;
    public var material:Material;

    public static function fromObj(src:String, optimized:Bool = true) {
		final position:EReg = ~/^v\s+([\d\.\+\-eE]+)\s+([\d\.\+\-eE]+)\s+([\d\.\+\-eE]+)/;
		final normal:EReg = ~/^vn\s+([\d\.\+\-eE]+)\s+([\d\.\+\-eE]+)\s+([\d\.\+\-eE]+)/;
		final uv:EReg = ~/^vt\s+([\d\.\+\-eE]+)\s+([\d\.\+\-eE]+)/;
		final face:EReg = ~/^f\s+(-?\d+)\/(-?\d+)\/(-?\d+)\s+(-?\d+)\/(-?\d+)\/(-?\d+)\s+(-?\d+)\/(-?\d+)\/(-?\d+)(?:\s+(-?\d+)\/(-?\d+)\/(-?\d+))?/;
		var lines = src.split('\n');
		var positions:Array<Vector3> = [];
		var uvs:Array<Vector2> = [];
		var normals:Array<Vector3> = [];
		var faces:Array<Tri> = [];
		var allIndexRef:Array<VertRef> = [];
		for (line in lines) {
			if (position.match(line)) {
				positions.push(new Vector3(Std.parseFloat(position.matched(1)), Std.parseFloat(position.matched(2)), Std.parseFloat(position.matched(3))));
			} else if (normal.match(line)) {
				normals.push(new Vector3(Std.parseFloat(normal.matched(1)), Std.parseFloat(normal.matched(2)), Std.parseFloat(normal.matched(3))).normalize());
			} else if (uv.match(line)) {
				uvs.push(new Vector2(Std.parseFloat(uv.matched(1)), Std.parseFloat(uv.matched(2))));
			} else if (face.match(line)) {
				var indexRef:Array<VertRef> = [];
				var i = 1;
				while (i < 10) {
					var p0 = Std.parseInt(face.matched(i));
					var p1 = Std.parseInt(face.matched(i + 1));
					var p2 = Std.parseInt(face.matched(i + 2));
					var ref:VertRef = new VertRef(p0 -1, p2 -1, p1 - 1);

					indexRef.push(ref);
					// If there is no point in all indexes

					allIndexRef.push(ref);
					i += 3;
				}
				faces.push(new Tri(indexRef[0], indexRef[1], indexRef[2]));
			}
		}
        // Obj files allow for negative indices, but we don't support them
        for (face in faces) {
            for (vert in face) {
                if (vert.uv < 0)
                    vert.uv = uvs.length + vert.uv;
                if (vert.normal < 0)
                    vert.normal = normals.length + vert.normal;
                if (vert.position < 0)
                    vert.position = positions.length + vert.position;
            }
        }
		return new Mesh(positions, normals, uvs, faces, optimized); 
    }
}
