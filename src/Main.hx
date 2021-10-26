package;

import haxe.Json;
import objhandler.GlTFExporter;
import sys.FileSystem;
import thinghandler.ThingHandler;
import sys.io.File;
using StringTools;

function main() {
	var thing = ThingHandler.importJson(File.getContent("input.json"));

    File.saveBytes("output.bin", ThingHandler.exportBytes(thing));
    var mesh = ThingHandler.generateMeshFromThing(thing);
	var export = mesh.toObj();

    File.saveContent("output.obj", export.obj);
    File.saveContent("output.mtl", export.mtl);

    var gltf = GlTFExporter.exportMesh(mesh);
    File.saveContent("output.gltf", Json.stringify(gltf));
}