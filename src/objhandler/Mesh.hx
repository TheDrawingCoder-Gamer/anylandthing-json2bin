package objhandler;

import objhandler.Face.DirectFace;
import objhandler.Node.INode;
import objhandler.Martix;
import bulby.cloner.Cloner;
using objhandler.ArrayTools;
class Mesh implements INode {
    public function new(positions:Array<Vector4>, normals:Array<Vector4>, uvs:Array<Vector2>,faces:Array<Face>, dooptimize:Bool = true, ?children:Array<Mesh>) {
        this.positions = positions;
        this.normals = normals;
        this.uvs = uvs;
        this.displayNormals = normals;
        this.displayPositions = positions;
        this.children = children == null ? [] : children;
        this.faces = faces;
        if (dooptimize)
            optimize();
    }
    public function optimize() {
        var optimizedPos = Cloner.clone(this.positions);
        var optimizedNormals = Cloner.clone(this.normals);
        var optimizedUvs = Cloner.clone(this.uvs);
        var newFaces = [for (face in this.faces) new DirectFace(this.normals, this.positions, this.uvs, face)];

        optimizedPos = [for (index => item in optimizedPos) if (item != null && optimizedPos.indexOfVector4(item) == index) item];
        optimizedNormals = [for (index => item in optimizedNormals) if (optimizedNormals.indexOfVector4(item) == index) item];
        optimizedUvs = [for (index => item in optimizedUvs) if (optimizedUvs.indexOfVector2(item) == index) item];
		this.positions = optimizedPos;
		this.uvs = optimizedUvs;
		this.normals = optimizedNormals;
        faces = [for (face in newFaces) face.toFaceForMesh(this)];
        
    }
    public function applyTransformations() {
        var positionsToEdit = Cloner.clone(positions);
        var normalsToEdit = Cloner.clone(normals);
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
    public var children:Array<Mesh>;
    public var faces:Array<Face>;
}