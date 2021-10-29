package bulby.macro;

import haxe.display.Display.Package;
import haxe.macro.Expr;
import haxe.Constraints.Constructible;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Expr.TypePath;

class Macro {
	#if macro
	public static function buildForwardFields() {
		var fields = haxe.macro.Context.getBuildFields();
		var i = 0;
		for (f in fields.copy()) {
			if (f.meta == null)
				continue;
			var bindTo:Null<Expr> = null;
			for (metadata in f.meta) {
				if (metadata.name == ":forwardfield") {
					if (metadata.params == null || metadata.params.length != 1) {
						haxe.macro.Context.error("No params provided or more than 1 was provided", metadata.pos);
					}
					bindTo = metadata.params[0];
					break;
				}
			}
			if (bindTo == null)
				continue;
			switch (f.kind) {
				case FVar(ct, _):
					f.kind = FProp('get', 'set', ct);
				default:
					continue;
			}

			var ident = switch (bindTo) {
				case macro $i{id} : id;
				case _: null;
			}
			if (ident == null)
				Context.error("Expected string", Context.currentPos());

			var get = "get_" + f.name;
			var set = "set_" + f.name;

			var typeDef = macro class Dummy {
				public inline function $get() return this.$ident;

				public inline function $set(v) return this.$ident = v;
			}
			for (field in typeDef.fields)
				fields.push(field);
		}
		return fields;
	}

	public static function buildProduceNewInstFromVar() {
		var fields = haxe.macro.Context.getBuildFields();
		var i = 0;
		for (f in fields.copy()) {
			if (f.meta == null)
				continue;
			var className:Null<Expr> = null;
			var classArgs:Null<Array<Expr>> = null;
			for (metadata in f.meta) {
				if (metadata.name == ":createinstonread") {
					if (metadata.params == null) {
						haxe.macro.Context.error("No params provided", metadata.pos);
					}
					switch (metadata.params[0]) {
						case {pos: _,}:
					}
					className = metadata.params[0];
					classArgs = metadata.params.slice(1);
					break;
				}
			}
			if (classArgs == null)
				continue;
			switch (f.kind) {
				case FVar(ct, _):
					f.kind = FProp('get', 'never', ct);
				default:
					continue;
			}

			var get = "get_" + f.name;
			var classPath = getTypePath(className);
			var typeDef = macro class Dummy {
				public static function $get() return new $classPath($a{classArgs});
			}
			for (field in typeDef.fields)
				fields.push(field);
		}
		return fields;
	}
    /**
     * Implicity makes fields public. 
     * Useful for classes that make most everything public.
     * Simply use "private" metadata to make it private.
     */
	public static function publish() {
		var calledOn = Context.getLocalType();
		switch (calledOn) {
			case TInst(type, _):
				switch (type.get().kind) {
					case KAbstractImpl(_.get() => abstr):
						if (!abstr.meta.has(":publish")) return null;
					case _:
						if (!type.get().meta.has(":publish")) return null;
				}
				var fields = haxe.macro.Context.getBuildFields();
				var i = 0;
				for (f in fields) {
					if (f.access != null && f.access.contains(APrivate))
						continue;
					if (f.access == null)
						f.access = [APublic];
					else if (!f.access.contains(APublic))
						f.access.push(APublic);
				}
				return fields;
			case _:
				return null;
		}
	}
	public static function staticClass() {
		var t = Context.getLocalType();
		switch (t) {
			case TInst(type, _): 
				switch (type.get().kind) {
					case KAbstractImpl(_.get() => abstr):
						if (!abstr.meta.has(":static")) return null;
					case _:
						if (!type.get().meta.has(":static")) return null;
				}
				var fields = haxe.macro.Context.getBuildFields();
				for (f in fields) {
					// no "member" identifier
					if (f.access != null && !f.access.contains(AStatic))
						f.access.push(AStatic);
					else if (f.access == null)
						f.access = [AStatic];

				}
				return fields;
			case _: 
				return null;
		}
	}
	static function getTypePath(e:Expr):TypePath {
		final parts = [];
		while (true) {
			switch e {
				case macro $e_.$field:
					parts.unshift(field);
					e = e_;
				case macro $i{ident} :
					parts.unshift(ident);
					break;
				case _:
					break;
			}
		}
		return {pack: parts, name: parts.pop()};
	}

	public static function buildMap() {
		var fields = haxe.macro.Context.getBuildFields();
		var i = 0;
		for (f in fields.copy()) {
			if (f.meta == null)
				continue;
			var coolKey:Null<Expr> = null;
			for (metadata in f.meta) {
				if (metadata.name == ":key") {
					if (metadata.params == null || metadata.params.length != 1)
						haxe.macro.Context.error("No params provided or more than 1 was provided", metadata.pos);
					coolKey = metadata.params[0];
					break;
				}
			}
			if (coolKey == null) {
				continue;
			}
			switch (f.kind) {
				case FVar(ct, _):
					f.kind = FProp('get', 'set', ct);
				default:
					continue;
			}
			var get = "get_" + f.name;
			var set = "set_" + f.name;
			var typeDef = macro class Dummy {
				public inline function $get() return this.get($e{coolKey});

				public inline function $set(v) {
					this.set($e{coolKey}, v);
					return v;
				}
			}
			for (field in typeDef.fields)
				fields.push(field);
		}
		return fields;
	}
	#end
}