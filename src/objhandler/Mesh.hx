package objhandler;

import objhandler.Node.INode;
import objhandler.Martix;
import bulby.cloner.Cloner;
import thinghandler.Thing.Triplet;
typedef Vector3 = Triplet<Float>;
class Mesh implements INode {
    public function new(points:Array<Vertex>, faces:Array<Face>, ?idx:Array<Int>, ?children:Array<Mesh>) {
        _originalPoints = points;
        this.points = points;
        this.children = children == null ? [] : children;
        this.idx = idx != null ? idx : [for (i in 0...points.length) i];
        this.faces = faces;
    }
    function applyTransformations() {
        var pointsToEdit = Cloner.clone(_originalPoints);
        for (point in pointsToEdit) {
            point.position = scale * point.position;
            point.position = rotation * point.position;
            point.position = translation * point.position;
        }
        points = pointsToEdit;
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
    var _originalPoints:Array<Vertex>;
    public var scale(default, set):Matrix4 = Matrix4.identity();
    public var translation(default, set):Matrix4 = Matrix4.identity();
    public var rotation(default, set):Matrix4 = Matrix4.identity();
    public var points:Array<Vertex>;
    public var idx:Array<Int>;
    public var children:Array<Mesh>;
    public var faces:Array<Face>;
}