package bulby.assets;

import bulby.assets.b3d.Tri;
import bulby.assets.b3d.VertRef;
import bulby.cloner.Cloner;
import bulby.assets.mat.Material;
import bulby.BulbyMath;
using objhandler.ArrayTools;
class Mesh {
    public function new(positions:Array<Vector4>, normals:Array<Vector4>, uvs:Array<Vector2>,faces:Array<Tri>, dooptimize:Bool = true, ?material:Material) {
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
        var optimizedPos = [for (pos in positions) new Vector4(pos.x, pos.y, pos.z, pos.w)];
        var optimizedNormals = [for (normal in normals) new Vector4(normal.x, normal.y, normal.z, normal.w)];
        var optimizedUvs = [for (uv in uvs) new Vector2(uv.x, uv.y)];
        var newFaces = [for (tri in this.faces) DirectTri.fromTriAndMesh(tri, this)];

        optimizedPos = [for (index => item in optimizedPos) if (item != null && optimizedPos.indexOfVector4(item) == index) item];
        optimizedNormals = [for (index => item in optimizedNormals) if (optimizedNormals.indexOfVector4(item) == index) item];
        optimizedUvs = [for (index => item in optimizedUvs) if (optimizedUvs.indexOfVector2(item) == index) item];
		this.positions = optimizedPos;
		this.uvs = optimizedUvs;
		this.normals = optimizedNormals;
        faces = [for (tri in newFaces) tri.toTriForMesh(this)];
        
    }
    public function applyTransformations() {
        var positionsToEdit = [for (pos in positions) new Vector4(pos.x, pos.y, pos.z, pos.w)];
        var normalsToEdit = [for (normal in normals) new Vector4(normal.x, normal.y, normal.z, normal.w)];
        for (i in 0...positionsToEdit.length) {
            positionsToEdit[i] = translation * rotation * scale * positionsToEdit[i];
           
        }
        for (i in 0...normalsToEdit.length) {
            normalsToEdit[i] = translation * rotation * scale * normalsToEdit[i];
        }
        displayNormals = normalsToEdit;
        displayPositions = positionsToEdit;
    }
    public var scale:Matrix4 = Matrix4.identity();
    public var translation:Matrix4 = Matrix4.identity();
    public var rotation:Matrix4 = Matrix4.identity();
    public var normals:Array<Vector4>;
    public var displayNormals:Array<Vector4>;
    public var positions:Array<Vector4>;
    public var displayPositions:Array<Vector4>;
    public var uvs:Array<Vector2>;
    public var faces:Array<Tri>;
    public var material:Material;

    public static function fromObj(src:String, optimized:Bool = true) {
		final position:EReg = ~/^v\s+([\d\.\+\-eE]+)\s+([\d\.\+\-eE]+)\s+([\d\.\+\-eE]+)/;
		final normal:EReg = ~/^vn\s+([\d\.\+\-eE]+)\s+([\d\.\+\-eE]+)\s+([\d\.\+\-eE]+)/;
		final uv:EReg = ~/^vt\s+([\d\.\+\-eE]+)\s+([\d\.\+\-eE]+)/;
		final face:EReg = ~/^f\s+(-?\d+)\/(-?\d+)\/(-?\d+)\s+(-?\d+)\/(-?\d+)\/(-?\d+)\s+(-?\d+)\/(-?\d+)\/(-?\d+)(?:\s+(-?\d+)\/(-?\d+)\/(-?\d+))?/;
		var lines = src.split('\n');
		var positions:Array<Vector4> = [];
		var uvs:Array<Vector2> = [];
		var normals:Array<Vector4> = [];
		var faces:Array<Tri> = [];
		var allIndexRef:Array<VertRef> = [];
		for (line in lines) {
			if (position.match(line)) {
				positions.push(new Vector4(Std.parseFloat(position.matched(1)), Std.parseFloat(position.matched(2)), Std.parseFloat(position.matched(3)), 1));
			} else if (normal.match(line)) {
				normals.push(new Vector4(Std.parseFloat(normal.matched(1)), Std.parseFloat(normal.matched(2)), Std.parseFloat(normal.matched(3)), 0).normalize());
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
		return new Mesh(positions, normals, uvs, faces, optimized); 
    }
}