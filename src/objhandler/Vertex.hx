package objhandler;



@:structInit
class Vertex {
    public var position:Vector4;
    public var uv:Vector2;
    public var normal:Vector4;
    public function new (position:Vector4, uv:Vector2, normal:Vector4) {
        this.position = position;
        this.uv = uv;
        this.normal = normal;
    }
    public function equals(b:Vertex) {
        return Vector4.nearlyequals(position,b.position) && Vector2.nearlyequals(uv, b.uv) && Vector4.nearlyequals(normal, b.normal);
    }
}
