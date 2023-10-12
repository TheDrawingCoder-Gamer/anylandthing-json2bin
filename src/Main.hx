package;

import bulby.assets.Text;
import bulby.assets.FontParser;
import bulby.assets.Font;
import bulby.assets.mat.Color;
import haxe.io.Bytes;
import bulby.assets.gltf.schema.TGLTF;
import bulby.assets.Image;
import haxe.Json;
import sys.FileSystem;
import thinghandler.ThingHandler;
import sys.io.File;
import Sys.println as println;

using StringTools;

var debug = false;

function main() {
	var args = Sys.args();
	#if debugbubly
	if (args.length == 0)
		args = ["input.json", "output", "-gltf", "-glb", "-debug"];
	#end
	var input = "";
	var output = "";
	var doGltf = false;
	var doGlb = false;
	if (args.length < 2) {
		println("Not enough args.");
		println("Command usage:");
		println("al2gltf [input] [output]");
		println("Where input is input file");
		println("and output is output file (no extension)");
		println("Available flags:");
		println("-gltf: Generate gltf file");
		println("-glb: Generate glb file");
		println("-debug: Output extra files/print more to commandline");
		Sys.exit(1);
	} else {
		input = args.shift();
		output = args.shift();
		for (flag in args) {
			switch (flag) {
				case "-gltf":
					doGltf = true;
				case "-glb":
					doGlb = true;
				case "-debug":
					debug = true;
				default:
					println("Unexpected arg: " + flag);
					Sys.exit(1);
			}
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
		File.saveBytes(output + ".glb", glb);
	if (doGltf)
		File.saveContent(output + ".gltf", Json.stringify(gltf));
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
