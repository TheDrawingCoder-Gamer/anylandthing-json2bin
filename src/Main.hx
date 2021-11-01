package;

import bulby.assets.Image;
import haxe.Json;
import sys.FileSystem;
import thinghandler.ThingHandler;
import sys.io.File;
import Sys.println as println;
using StringTools;

function main() {
    var args = Sys.args();
    var input = "";
    var output = "";
	if (args.length < 2) {
    #if debugbubly
        input = "input.json";
        output = "output";
    #else
        throw "Expected input as arg one";
    #end
    }
    else {
        input = args[0];
        output = args[1];
    }
    println("Importing Thing...");
	var thing = ThingHandler.importJson(File.getContent(input));
    println("Done!");
    // File.saveBytes("output.bin", ThingHandler.exportBytes(thing));
    println("Generating a Mesh...");
    var mesh = ThingHandler.generateMeshFromThing(thing);
    println("Done!");
	// var export = mesh.toObj();

    // imagine using obj file when you can just use gltf
    //File.saveContent("output.obj", export.obj);
    //File.saveContent("output.mtl", export.mtl);
    println("Generating GLTF Json...");
    var gltf = mesh.toGltf();
    println("Done!");
    println("Generating GLB...");
    var glb = mesh.toGLB();
    println("Done!");
    println("Saving files...");
    File.saveBytes(output + ".glb", glb);
    File.saveContent(output + ".gltf", Json.stringify(gltf));
    println("Done!");
}