package;

import haxe.Json;
import sys.FileSystem;
import thinghandler.ThingHandler;
import sys.io.File;
using StringTools;

function main() {
	var thing = ThingHandler.importJson(File.getContent("input.json"));

    // File.saveBytes("output.bin", ThingHandler.exportBytes(thing));
    var mesh = ThingHandler.generateMeshFromThing(thing);
	// var export = mesh.toObj();

    // imagine using obj file when you can just use gltf
    //File.saveContent("output.obj", export.obj);
    //File.saveContent("output.mtl", export.mtl);

    var gltf = mesh.toGltf();
    File.saveContent("output.gltf", Json.stringify(gltf));
}