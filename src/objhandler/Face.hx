package objhandler;
@:structInit
class Face {
    public var vertices:Array<Vertex> = [];
    public function new(vertices:Array<Vertex>) {
        this.vertices = vertices;
    }  
}