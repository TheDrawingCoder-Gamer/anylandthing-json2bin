package;

import area.Area;
import area.CDNArea;
import sys.FileSystem;
import bulby.assets.Text;
import bulby.assets.FontParser;
import haxe.io.Bytes;
import haxe.Json;
import thinghandler.ThingHandler;
import sys.io.File;
import Sys.println as println;
import thinghandler.Thing;

using StringTools;

var debug = false;

function main() {
	var args = Sys.args();
	var input = null;
	var outGlb = null;
	var outGltf = null;
	var doGltf = false;
	var doGlb = false;
	var exportedAreaFolder = null;
	var cdnArea = null;
	var cdnAreaData = null;
	var thingFolder = null;
	var mainID:Null<String> = null;
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
		println("-areaCDN [area]: Import an area dumped from the CDN; use -areaCDNData as well");
		println("-areaCDNData [areadata]: Import an area dumped from the CDN.");
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
				cdnArea = args[i++];
			case "-areaCDNData":
				cdnAreaData = args[i++];
			case "-inFolder":
				thingFolder = args[i++];
			case "-id":
				mainID = args[i++];
		}
	}
	var mesh:bulby.assets.Node = null;
	if (thingFolder != null || input != null) {
		println("Importing Thing...");
		var things = new Map<String, Thing>();
		var name = "this";
		if (thingFolder != null) {
			for (file in FileSystem.readDirectory(thingFolder)) {
				final path = thingFolder + '/' + file;
				if (!FileSystem.isDirectory(path)) {
					things.set(file, ThingHandler.importJson(File.getContent(path)));
				}
			}
			if (mainID == null)
				throw "Main ID is required for thing folders";
			name = mainID;
		} else if (input != null) {
			things.set("this", ThingHandler.importJson(File.getContent(input)));
		}
		println("Done!");
		println("Generating a Mesh...");
		mesh = ThingHandler.generateMeshFromThings(things, name);
		println("Done!");
	}
	if (cdnArea != null && cdnAreaData != null) {
		if (mesh != null) {
			println("Error, expected only 1 mode");
			Sys.exit(1);
		}
		println("Importing Area...");
		final areaCDN:CDNArea = Json.parse(File.getContent(cdnArea));
		final areaDataCDN:CDNAreaData = Json.parse(File.getContent(cdnAreaData));
		final area = Area.fromCDN(areaDataCDN, areaCDN);
		println("Done!");
		println("Generating a Mesh...");
		mesh = area.generateMesh();
		println("Done!");
	}
	if (mesh == null) {
		// Is this an error state?
		println("No mesh was generated. Exiting...");
		Sys.exit(0);
	}
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
