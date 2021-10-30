package;

import bulby.assets.Image;
import haxe.Json;
import sys.FileSystem;
import thinghandler.ThingHandler;
import sys.io.File;
using StringTools;

function main() {
    var args = Sys.args();
    var input = "";
    var output = "";
	if (args.length < 2) {
    #if debugbubly
        input = "input.json";
        output = "output.gltf";
    #else
        throw "Expected input as arg one";
    #end
    }
    else 
        input = args[0];
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