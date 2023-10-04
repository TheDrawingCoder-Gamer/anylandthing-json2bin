package bulby.cloner;

import haxe.ds.IntMap;
import haxe.ds.StringMap;
import bulby.cloner.MapCloner;
import haxe.ds.ObjectMap;

class Cloner {
	var cache:ObjectMap<Dynamic, Dynamic>;
	var classHandles:Map<String, Dynamic->Dynamic>;
	var stringMapCloner:MapCloner<String>;
	var intMapCloner:MapCloner<Int>;

	public function new() {
		stringMapCloner = new MapCloner(this, StringMap);
		intMapCloner = new MapCloner(this, IntMap);
		classHandles = new Map<String, Dynamic->Dynamic>();
		classHandles.set('String', (v:String) -> {
			return v;
		});
		classHandles.set('Array', cloneArray);
		classHandles.set('haxe.ds.StringMap', stringMapCloner.clone);
		classHandles.set('haxe.ds.IntMap', intMapCloner.clone);
	}

	public static function clone<T>(v:T) {
		return new Cloner().beginClone(v);
	}

	public function beginClone<T>(v:T) {
		cache = new ObjectMap<Dynamic, Dynamic>();
		var outcome = _clone(v);
		cache = null;
		return outcome;
	}

	public function _clone<T>(v:T):T {
		#if js
		if (Std.is(v, String))
			return v;
		#end
		try {
			if (Type.getClassName(cast v) != null)
				return v;
		} catch (e:Dynamic) {}
		switch (Type.typeof(v)) {
			case TNull:
				return null;
			case TInt | TFloat | TBool:
				return v;
			case TObject:
				return handleAnonymous(v);
			case TFunction:
				return null;
			case TClass(c):
				if (!cache.exists(v))
					cache.set(v, handleClass(c, v));
				return cache.get(v);
			case TEnum(e):
				return v;
			case TUnknown:
				return null;
		}
	}

	function cloneArray<T>(inValue:Array<T>):Array<T> {
		var array:Array<T> = inValue.copy();
		for (i in 0...array.length)
			array[i] = _clone(array[i]);
		return array;
	}

	function handleClass<T>(c:Class<T>, v:T):T {
		var handle:Null<T->T> = classHandles.get(Type.getClassName(c));
		if (handle == null) {
			handle = cloneClass;
		}
		return handle(v);
	}

	function cloneClass<T>(v:T):T {
		if (Type.getInstanceFields(Type.getClass(v)).contains("clonerCopy")) {
			return cast(Reflect.getProperty(v, "clonerCopy") : Void->T)();
		}
		var outValue = Type.createEmptyInstance(Type.getClass(v));
		var fields = Reflect.fields(v);
		for (field in fields) {
			var property = Reflect.getProperty(v, field);
			Reflect.setProperty(outValue, field, property);
		}
		return outValue;
	}

	function handleAnonymous(v:Dynamic):Dynamic {
		var properties:Array<String> = Reflect.fields(v);
		var anonymous:Dynamic = {};
		for (i in 0...properties.length) {
			var property:String = properties[i];
			Reflect.setField(anonymous, property, _clone(Reflect.getProperty(v, property)));
		}
		return anonymous;
	}
}
