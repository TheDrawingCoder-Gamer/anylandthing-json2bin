package;

import sys.FileSystem;
import objhandler.ObjImporter.objExporter;
import thinghandler.ThingHandler;
import sys.io.File;
using StringTools;

function main() {
	var thing = ThingHandler.importJson(File.getContent("input.json"));

    File.saveBytes("output.bin", ThingHandler.exportBytes(thing));
    var mesh = ThingHandler.generateMeshFromThing(thing);
    File.saveContent("output.obj", objExporter(mesh));
}