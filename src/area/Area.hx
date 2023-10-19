package area;
import bulby.assets.Node;
import thinghandler.ThingHandler;
import area.CDNArea;
import bulby.BulbyMath;
import thinghandler.Thing;
class Placement {
	public final id: String;
	public final tid: String;
	public final pos: Vector3;
	public final rot: Quaternion;
	public final scale: Float;
	public function new(id: String, tid: String, pos: Vector3, rot: Quaternion, scale: Float) {
		this.id = id;
		this.tid = tid;
		this.pos = pos;
		this.rot = rot;
		this.scale = scale;
	}
	static public function fromCDN(plc: CDNPlacement): Placement {
		return new Placement(plc.Id, plc.Tid, Vector3.fromUnity(plc.P), Quaternion.fromUnityEuler(plc.R), plc.S);
	}
}
class Area {
	public final things: Map<String, Thing>;
	public final placements: Array<Placement>;

	public function new(things: Map<String, Thing>, placements: Array<Placement>) {
		this.things = things;
		this.placements = placements;
	}

	static public function fromCDN(data: CDNAreaData, area: CDNArea): Area {
		final placements = [];
		for (plc in data.placements) {
			placements.push(Placement.fromCDN(plc));
		}
		final things = new Map<String, Thing>();
		for (thd in area.thingDefinitions) {
			final thing = ThingHandler.importJson(thd.def);
			things.set(thd.id, thing);
		}
		return new Area(things, placements);
	}
	
	public function generateMesh(): Node {
		final node = new Node([]);
		for (plc in placements) {
			final mesh = ThingHandler.generateMeshFromThings(things, plc.tid);
			mesh.translation += plc.pos;
			mesh.scale += new Vector3(plc.scale, plc.scale, plc.scale);
			mesh.rotation = plc.rot * mesh.rotation;
			node.children.push(ANode(mesh));
		}
		return node;
	}
}
