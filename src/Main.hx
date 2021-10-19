package;

import thinghandler.ThingHandler;
import sys.io.File;
import haxe.Json;
import thinghandler.Thing;

function main() {
	var thing = ThingHandler.importJson(File.getContent("input.json"));

    File.saveBytes("output.bin", ThingHandler.exportBytes(thing));
    trace(ThingHandler.generateMeshFromThing(thing));
}