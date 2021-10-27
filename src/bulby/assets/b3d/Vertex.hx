package bulby.assets.b3d;
import bulby.BulbyMath;
@:structInit
class Vertex {
    public var position:Vector3;
    public var uv:Vector2;
    public var normal:Vector3;
    public function new (position:Vector3, uv:Vector2, normal:Vector3) {
        this.position = position;
        this.uv = uv;
        this.normal = normal;
    }
    public function equals(b:Vertex) {
        return Vector3.nearlyequals(position,b.position) && Vector2.nearlyequals(uv, b.uv) && Vector3.nearlyequals(normal, b.normal);
    }
}
