package objhandler;

import objhandler.Node.INode;
import objhandler.Martix;
import bulby.cloner.Cloner;
import thinghandler.Thing.Triplet;
typedef Vector3 = Triplet<Float>;
class Mesh implements INode {
    public function new(faces:Array<Face>, ?children:Array<INode>) {
        _originalFaces = faces;
        this.faces = faces;
        this.children = children == null ? [] : children;
    }
    function applyTransformations() {
        var facesToEdit = Cloner.clone(_originalFaces);
        for (face in facesToEdit) {
            for (vert in face.vertices) {
                vert.position = scale * vert.position;
                vert.position = rotation * vert.position;
                vert.position = translation * vert.position;
            }
        }
        faces = facesToEdit;
    }
    public function set_scale(newScale:Matrix4) {
		scale = newScale;
        applyTransformations();
        return scale;
    }
	public function set_translation(newTranslation:Matrix4) {
		translation = newTranslation;
		applyTransformations();
		return translation;
	}
	public function set_rotation(newRotation:Matrix4) {
		rotation = newRotation;
		applyTransformations();
		return rotation;
	}
    public static function mergeMeshes(a:Mesh, b:Mesh) {
        // Deep Copy Meshes
        var mesh = Cloner.clone(a);
        var mesh2 = Cloner.clone(b);
        var retMesh = new Mesh(mesh.faces.concat(mesh2.faces));
        return retMesh;
    }
    public function merge(b:Mesh) {
        return Mesh.mergeMeshes(this, b);
    }
    var _originalFaces:Array<Face>;
    public var scale(default, set):Matrix4 = Matrix4.identity();
    public var translation(default, set):Matrix4 = Matrix4.identity();
    public var rotation(default, set):Matrix4 = Matrix4.identity();
    public var faces:Array<Face>;
    public var children:Array<INode>;
}