package objhandler;
@:structInit
class Face {
    public var vertices:Array<IndexRef> = [];
    public function new(vertices:Array<IndexRef>) {
        this.vertices = vertices;
    }  
}