package objhandler;


import objhandler.Node.INode;
using Lambda;
import Std.parseFloat as pFloat;
var position:EReg = ~/^v\s+([\d\.\+\-eE]+)\s+([\d\.\+\-eE]+)\s+([\d\.\+\-eE]+)/;
var normal:EReg = ~/^vn\s+([\d\.\+\-eE]+)\s+([\d\.\+\-eE]+)\s+([\d\.\+\-eE]+)/;
var uv:EReg = ~/^vt\s+([\d\.\+\-eE]+)\s+([\d\.\+\-eE]+)/;
var face:EReg = ~/^f\s+(-?\d+)\/(-?\d+)\/(-?\d+)\s+(-?\d+)\/(-?\d+)\/(-?\d+)\s+(-?\d+)\/(-?\d+)\/(-?\d+)(?:\s+(-?\d+)\/(-?\d+)\/(-?\d+))?/;

function objParser(src:String, optimized:Bool = true) {
    var lines = src.split('\n');
    var positions:Array<Vector4> = [];
    var uvs:Array<Vector2> = [];
    var normals:Array<Vector4> = [];
    var faces:Array<Face> = [];
    var allIndexRef:Array<IndexRef> = [];
    for (line in lines) {
        if (position.match(line)) {
            positions.push(new Vector4(pFloat(position.matched(1)), pFloat(position.matched(2)), pFloat(position.matched(3)), 1));
        } else if (normal.match(line)) {
            normals.push(new Vector4(pFloat(normal.matched(1)), pFloat(normal.matched(2)), pFloat(normal.matched(3)), 0));
        } else if (uv.match(line)) {
            uvs.push(new Vector2(pFloat(uv.matched(1)), pFloat(uv.matched(2))));
        } else if (face.match(line)) {
            var indexRef:Array<IndexRef> = [];
            var i = 1;
            while (i < 10) {
                var p0 = Std.parseInt(face.matched(i));
                var p1 = Std.parseInt(face.matched(i + 1));
                var p2 = Std.parseInt(face.matched(i + 2));
                var ref:IndexRef = {point: p0 - 1, uv: p1 - 1, normal: p2 - 1};
                
                
                indexRef.push(ref);
                // If there is no point in all indexes 
                
				allIndexRef.push(ref);
                i += 3;
            }
            faces.push(new Face(indexRef));
        }

    }
    return new Mesh(positions, normals, uvs, faces, optimized);
}

function objExporter(node:Node) {
    // We stitch together all the meshes here because it saves on painfulness of scaling things
    var file = "# Export of Bulby's Anyland converter \nmtllib export.mtl\ng ALThing\n";
    for (mesh in node.children) {
        for (pos in mesh.displayPositions) {
            file += 'v ${roundf(pos.x, 7)} ${roundf(pos.y, 7)} ${roundf(pos.z, 7)}\n';
        }
    }
    for (mesh in node.children) {
        for (normal in mesh.displayNormals) {
            file += 'vn ${roundf(normal.x, 7)} ${roundf(normal.y, 7)} ${roundf(normal.z, 7)}\n';
        }
    }
    for (mesh in node.children) {
        for (uv in mesh.uvs) {
            file += 'vt ${roundf(uv.x, 7)} ${roundf(uv.y, 7)}\n';
        }
    }
    file += "usemtl None\n";
    var totalP = 0;
    var totalU = 0;
    var totalN = 0;
    for (mesh in node.children) {
        for (face in mesh.faces) {
            final v1 = face.vertices[0];
            final v2 = face.vertices[1];
            final v3 = face.vertices[2];
            file += 'f ${v1.point + 1 + totalP}/${v1.uv + 1 + totalU}/${v1.normal + 1 + totalN} ${v2.point + 1 + totalP}/${v2.uv + 1 + totalU}/${v2.normal + 1 + totalN} ${v3.point + 1 + totalP}/${v3.uv + 1 + totalU}/${v3.normal + 1 + totalN}\n';
            
        }
		totalP += mesh.positions.length;
        totalU += mesh.uvs.length;
        totalN += mesh.normals.length;
    }
    return file;
}

function roundf(f:Float, to:Int) {
    return Math.round(f * (Math.pow(10, to))) / Math.pow(10, to);
}