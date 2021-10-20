package objhandler;

class Node implements INode {
    public var children:Array<Mesh>;
    public function new(children:Array<Mesh>) {
        this.children = children;
    }
}

interface INode {
    var children:Array<Mesh>;
}