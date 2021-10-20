package objhandler;


using Lambda;
import Std.parseFloat as pFloat;
var position:EReg = ~/^v\s+([\d\.\+\-eE]+)\s+([\d\.\+\-eE]+)\s+([\d\.\+\-eE]+)/;
var normal:EReg = ~/^vn\s+([\d\.\+\-eE]+)\s+([\d\.\+\-eE]+)\s+([\d\.\+\-eE]+)/;
var uv:EReg = ~/^vt\s+([\d\.\+\-eE]+)\s+([\d\.\+\-eE]+)/;
var face:EReg = ~/^f\s+(-?\d+)\/(-?\d+)\/(-?\d+)\s+(-?\d+)\/(-?\d+)\/(-?\d+)\s+(-?\d+)\/(-?\d+)\/(-?\d+)(?:\s+(-?\d+)\/(-?\d+)\/(-?\d+))?/;

function objParser(src:String) {
    var lines = src.split('\n');
    var positions:Array<Vector4> = [];
    var uvs:Array<Vector2> = [];
    var normals:Array<Vector4> = [];
    var faces:Array<Face> = [];
	var verticies:Array<Vertex> = [];
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
                var ref:IndexRef = {point: p0 - 1, uv: p1 - 1};
                
                
                indexRef.push(ref);
                // If there is no point in all indexes 
                
				allIndexRef.push(ref);
                i += 3;
            }
            faces.push(new Face(indexRef));
        }

    }
    for (i in 0...positions.length) {
        verticies.push(new Vertex(positions[i], uvs[i]));
    }
    return new Mesh(verticies, faces);
}