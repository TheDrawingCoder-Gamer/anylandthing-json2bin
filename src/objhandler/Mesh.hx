package objhandler;

import objhandler.Node.INode;
import objhandler.Martix;
import bulby.cloner.Cloner;

class Mesh implements INode {
    public function new(points:Array<Vertex>, faces:Array<Face>, ?idx:Array<Int>, ?children:Array<Mesh>) {
        _originalPoints = points;
        this.points = points;
        this.children = children == null ? [] : children;
        this.idx = idx != null ? idx : [for (i in 0...points.length) i];
        this.faces = faces;
    }
    public function applyTransformations() {
        var pointsToEdit = Cloner.clone(_originalPoints);
        for (point in pointsToEdit) {
            point.position = translation * rotation * scale * point.position;
            point.normal = translation * rotation * scale * point.normal;
        }
        points = pointsToEdit;
    }
    public function getOriginalVert(i:Int) {
        return _originalPoints[idx[i]];
    }
    public function getVert(i:Int) {
        return points[idx[i]];
    }
    public function setOGVertAndRescale(i:Int, vert:Vertex) {
        _originalPoints[idx[i]] = vert;
        applyTransformations();

    }
    public function set_scale(v:Matrix4) {
        scale = v;
        trace("set scale to " + v);
        return v;
    }
    public var _originalPoints:Array<Vertex>;
    public var scale(default, set):Matrix4 = Matrix4.identity();
    public var translation:Matrix4 = Matrix4.identity();
    public var rotation:Matrix4 = Matrix4.identity();
    public var points:Array<Vertex>;
    public var idx:Array<Int>;
    public var children:Array<Mesh>;
    public var faces:Array<Face>;
}