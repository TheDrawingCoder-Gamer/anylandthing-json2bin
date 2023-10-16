package;

import bulby.assets.Text;
import bulby.assets.FontParser;
import haxe.io.Bytes;
import haxe.Json;
import thinghandler.ThingHandler;
import sys.io.File;
import Sys.println as println;

using StringTools;

var debug = false;

function main() {
	var args = Sys.args();
	var input = "";
	var outGlb = null;
	var outGltf = null;
	var doGltf = false;
	var doGlb = false;
	var exportedAreaFolder = null;
	var cdnAreaFolder = null;
	var thingFolder = null;
	var mainID: Null<String> = null;
	var i = 0;
	if (args.length < 2) {
		println("Not enough args.");
		println("Command usage:");
		println("al2gltf -in [input] -glb [output]");
		println("Where input is input file");
		println("and output is output file");
		println("Available flags:");
		println("-gltf [file]: Generate gltf file");
		println("-glb [file]: Generate glb file");
		println("-areaExported [folder]: Import an area exported from anyland");
		println("-areaCDN [folder]: Import an area dumped from the CDN");
		println("-inFolder [folder]: Import a thing that contains subthings");
		println("-id [name]: Required with inFolder. The main thing to be rendered.");
		println("-debug: Output extra files/print more to commandline");
		Sys.exit(1);
	} 

	while (i < args.length) {
		final c = i++;
		switch (args[c]) {
			case "-in":
				input = args[i++];
			case "-glb":
				outGlb = args[i++];
				doGlb = true;
			case "-gltf":
				outGltf = args[i++];
				doGltf = true;
			case "-debug":
				debug = true;
			case "-areaExported":
				exportedAreaFolder = args[i++];
				throw "Exported areas aren't implemented yet";
			case "-areaCDN":
				cdnAreaFolder = args[i++];
				throw "CDN Areas aren't implemented yet";
			case "-inFolder":
				thingFolder = args[i++];
				throw "Things with subthings aren't implemented yet";
			case "-id":
				mainID = args[i++];
				throw "Things with subthings aren't implemented yet";
		}
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
	// File.saveContent("output.obj", export.obj);
	// File.saveContent("output.mtl", export.mtl);
	var gltf:Dynamic = {};
	var glb:Bytes = Bytes.alloc(0);
	if (doGltf) {
		println("Generating GLTF Json...");
		gltf = mesh.toGltf();
		println("Done!");
	}
	if (doGlb) {
		println("Generating GLB...");
		glb = mesh.toGLB();
		println("Done!");
	}

	println("Saving files...");
	if (doGlb)
		File.saveBytes(outGlb, glb);
	if (doGltf)
		File.saveContent(outGltf, Json.stringify(gltf));
	println("Done!");
	/*
	if (debug) {
		println("Combining two png images...");
		var bottom = Image.fromPng("./bottom_layer_test.png");
		var top = Image.fromPng("./top_layer_test.png");
		var combined = bottom.blend(top);
		combined.writePng(output + "_combined.png");
		println("Done!");
	}
	*/
	if (debug) {
		println("Writing text...");
		final font = FontParser.parseFont("18");
		font.resizeTo(32);
		final res = Text.write("Hi guys", Align.Center, font, 0);
		res.img.writePng("fontimage.png");
		// final res = font.getChar('A'.code);
		// res.t.extract().writePng("fontimage.png");
		println("Done!");
	}
}
