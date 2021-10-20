package objhandler;

class Node implements INode {
    public var children:Array<INode>;
    public function new(children:Array<INode>) {
        this.children = children;
    }
}

interface INode {
    var children:Array<INode>;
}