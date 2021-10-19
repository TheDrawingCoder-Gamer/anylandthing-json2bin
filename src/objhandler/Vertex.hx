package objhandler;

import objhandler.Mesh.Vector3;

@:structInit
class Vertex {
    public var position:Vector4;
    public var uv:Vector2;

    public function new (position:Vector4, uv:Vector2) {
        this.position = position;
        this.uv = uv;
    }
}
