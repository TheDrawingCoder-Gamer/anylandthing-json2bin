package bulby.assets.b3d;

typedef VertRefRaw = {
    var position:Int;
    var normal:Int;
    var uv:Int;
}
@:forward
abstract VertRef(VertRefRaw) {
    public function new(position:Int, normal:Int, uv:Int) {
        this = {position: position, normal: normal, uv: uv};
    }
}