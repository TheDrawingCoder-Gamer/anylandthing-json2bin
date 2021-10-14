(function ($global) { "use strict";
var $estr = function() { return js_Boot.__string_rec(this,''); },$hxEnums = $hxEnums || {},$_;
function $extend(from, fields) {
	var proto = Object.create(from);
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var Lambda = function() { };
Lambda.__name__ = "Lambda";
Lambda.count = function(it,pred) {
	var n = 0;
	if(pred == null) {
		var _ = $getIterator(it);
		while(_.hasNext()) {
			var _1 = _.next();
			++n;
		}
	} else {
		var x = $getIterator(it);
		while(x.hasNext()) {
			var x1 = x.next();
			if(pred(x1)) {
				++n;
			}
		}
	}
	return n;
};
function Main_main() {
	var thing = thinghandler_ThingHandler.importJson(js_node_Fs.readFileSync("input.json",{ encoding : "utf8"}));
	var bytes = thinghandler_ThingHandler.exportBytes(thing);
	var data = bytes.b;
	js_node_Fs.writeFileSync("output.bin",js_node_buffer_Buffer.from(data.buffer,data.byteOffset,bytes.length));
}
Math.__name__ = "Math";
var Reflect = function() { };
Reflect.__name__ = "Reflect";
Reflect.getProperty = function(o,field) {
	var tmp;
	if(o == null) {
		return null;
	} else {
		var tmp1;
		if(o.__properties__) {
			tmp = o.__properties__["get_" + field];
			tmp1 = tmp;
		} else {
			tmp1 = false;
		}
		if(tmp1) {
			return o[tmp]();
		} else {
			return o[field];
		}
	}
};
Reflect.fields = function(o) {
	var a = [];
	if(o != null) {
		var hasOwnProperty = Object.prototype.hasOwnProperty;
		for( var f in o ) {
		if(f != "__id__" && f != "hx__closures__" && hasOwnProperty.call(o,f)) {
			a.push(f);
		}
		}
	}
	return a;
};
var Std = function() { };
Std.__name__ = "Std";
Std.string = function(s) {
	return js_Boot.__string_rec(s,"");
};
var ValueType = $hxEnums["ValueType"] = { __ename__:true,__constructs__:null
	,TNull: {_hx_name:"TNull",_hx_index:0,__enum__:"ValueType",toString:$estr}
	,TInt: {_hx_name:"TInt",_hx_index:1,__enum__:"ValueType",toString:$estr}
	,TFloat: {_hx_name:"TFloat",_hx_index:2,__enum__:"ValueType",toString:$estr}
	,TBool: {_hx_name:"TBool",_hx_index:3,__enum__:"ValueType",toString:$estr}
	,TObject: {_hx_name:"TObject",_hx_index:4,__enum__:"ValueType",toString:$estr}
	,TFunction: {_hx_name:"TFunction",_hx_index:5,__enum__:"ValueType",toString:$estr}
	,TClass: ($_=function(c) { return {_hx_index:6,c:c,__enum__:"ValueType",toString:$estr}; },$_._hx_name="TClass",$_.__params__ = ["c"],$_)
	,TEnum: ($_=function(e) { return {_hx_index:7,e:e,__enum__:"ValueType",toString:$estr}; },$_._hx_name="TEnum",$_.__params__ = ["e"],$_)
	,TUnknown: {_hx_name:"TUnknown",_hx_index:8,__enum__:"ValueType",toString:$estr}
};
ValueType.__constructs__ = [ValueType.TNull,ValueType.TInt,ValueType.TFloat,ValueType.TBool,ValueType.TObject,ValueType.TFunction,ValueType.TClass,ValueType.TEnum,ValueType.TUnknown];
var Type = function() { };
Type.__name__ = "Type";
Type.createInstance = function(cl,args) {
	var ctor = Function.prototype.bind.apply(cl,[null].concat(args));
	return new (ctor);
};
Type.typeof = function(v) {
	switch(typeof(v)) {
	case "boolean":
		return ValueType.TBool;
	case "function":
		if(v.__name__ || v.__ename__) {
			return ValueType.TObject;
		}
		return ValueType.TFunction;
	case "number":
		if(Math.ceil(v) == v % 2147483648.0) {
			return ValueType.TInt;
		}
		return ValueType.TFloat;
	case "object":
		if(v == null) {
			return ValueType.TNull;
		}
		var e = v.__enum__;
		if(e != null) {
			return ValueType.TEnum($hxEnums[e]);
		}
		var c = js_Boot.getClass(v);
		if(c != null) {
			return ValueType.TClass(c);
		}
		return ValueType.TObject;
	case "string":
		return ValueType.TClass(String);
	case "undefined":
		return ValueType.TNull;
	default:
		return ValueType.TUnknown;
	}
};
var cloner_Cloner = function() {
	this.stringMapCloner = new cloner_MapCloner(this,haxe_ds_StringMap);
	this.intMapCloner = new cloner_MapCloner(this,haxe_ds_IntMap);
	this.classHandles = new haxe_ds_StringMap();
	this.classHandles.h["String"] = $bind(this,this.returnString);
	this.classHandles.h["Array"] = $bind(this,this.cloneArray);
	this.classHandles.h["haxe.ds.StringMap"] = ($_=this.stringMapCloner,$bind($_,$_.clone));
	this.classHandles.h["haxe.ds.IntMap"] = ($_=this.intMapCloner,$bind($_,$_.clone));
};
cloner_Cloner.__name__ = "cloner.Cloner";
cloner_Cloner.prototype = {
	returnString: function(v) {
		return v;
	}
	,clone: function(v) {
		this.cache = new haxe_ds_ObjectMap();
		var outcome = this._clone(v);
		this.cache = null;
		return outcome;
	}
	,_clone: function(v) {
		if(typeof(v) == "string") {
			return v;
		}
		if(v.__name__ != null) {
			return v;
		}
		var _g = Type.typeof(v);
		switch(_g._hx_index) {
		case 0:
			return null;
		case 1:
			return v;
		case 2:
			return v;
		case 3:
			return v;
		case 4:
			return this.handleAnonymous(v);
		case 5:
			return null;
		case 6:
			var c = _g.c;
			if(this.cache.h.__keys__[v.__id__] == null) {
				this.cache.set(v,this.handleClass(c,v));
			}
			return this.cache.h[v.__id__];
		case 7:
			var e = _g.e;
			return v;
		case 8:
			return null;
		}
	}
	,handleAnonymous: function(v) {
		var properties = Reflect.fields(v);
		var anonymous = { };
		var _g = 0;
		var _g1 = properties.length;
		while(_g < _g1) {
			var i = _g++;
			var property = properties[i];
			anonymous[property] = this._clone(Reflect.getProperty(v,property));
		}
		return anonymous;
	}
	,handleClass: function(c,inValue) {
		var this1 = this.classHandles;
		var key = c.__name__;
		var handle = this1.h[key];
		if(handle == null) {
			handle = $bind(this,this.cloneClass);
		}
		return handle(inValue);
	}
	,cloneArray: function(inValue) {
		var array = inValue.slice();
		var _g = 0;
		var _g1 = array.length;
		while(_g < _g1) {
			var i = _g++;
			array[i] = this._clone(array[i]);
		}
		return array;
	}
	,cloneClass: function(inValue) {
		var outValue = Object.create(js_Boot.getClass(inValue).prototype);
		var fields = Reflect.fields(inValue);
		var _g = 0;
		var _g1 = fields.length;
		while(_g < _g1) {
			var i = _g++;
			var field = fields[i];
			var property = Reflect.getProperty(inValue,field);
			outValue[field] = this._clone(property);
		}
		return outValue;
	}
	,__class__: cloner_Cloner
};
var cloner_MapCloner = function(cloner,type) {
	this.cloner = cloner;
	this.type = type;
	this.noArgs = [];
};
cloner_MapCloner.__name__ = "cloner.MapCloner";
cloner_MapCloner.prototype = {
	clone: function(inValue) {
		var inMap = inValue;
		var map = Type.createInstance(this.type,this.noArgs);
		var key = inMap.keys();
		while(key.hasNext()) {
			var key1 = key.next();
			map.set(key1,this.cloner._clone(inMap.get(key1)));
		}
		return map;
	}
	,__class__: cloner_MapCloner
};
var haxe_Exception = function(message,previous,native) {
	Error.call(this,message);
	this.message = message;
	this.__previousException = previous;
	this.__nativeException = native != null ? native : this;
};
haxe_Exception.__name__ = "haxe.Exception";
haxe_Exception.caught = function(value) {
	if(((value) instanceof haxe_Exception)) {
		return value;
	} else if(((value) instanceof Error)) {
		return new haxe_Exception(value.message,null,value);
	} else {
		return new haxe_ValueException(value,null,value);
	}
};
haxe_Exception.thrown = function(value) {
	if(((value) instanceof haxe_Exception)) {
		return value.get_native();
	} else if(((value) instanceof Error)) {
		return value;
	} else {
		var e = new haxe_ValueException(value);
		return e;
	}
};
haxe_Exception.__super__ = Error;
haxe_Exception.prototype = $extend(Error.prototype,{
	unwrap: function() {
		return this.__nativeException;
	}
	,get_native: function() {
		return this.__nativeException;
	}
	,__class__: haxe_Exception
	,__properties__: {get_native:"get_native"}
});
var haxe__$Int64__$_$_$Int64 = function(high,low) {
	this.high = high;
	this.low = low;
};
haxe__$Int64__$_$_$Int64.__name__ = "haxe._Int64.___Int64";
haxe__$Int64__$_$_$Int64.prototype = {
	__class__: haxe__$Int64__$_$_$Int64
};
var haxe_ValueException = function(value,previous,native) {
	haxe_Exception.call(this,String(value),previous,native);
	this.value = value;
};
haxe_ValueException.__name__ = "haxe.ValueException";
haxe_ValueException.__super__ = haxe_Exception;
haxe_ValueException.prototype = $extend(haxe_Exception.prototype,{
	unwrap: function() {
		return this.value;
	}
	,__class__: haxe_ValueException
});
var haxe_ds_IntMap = function() {
	this.h = { };
};
haxe_ds_IntMap.__name__ = "haxe.ds.IntMap";
haxe_ds_IntMap.prototype = {
	set: function(key,value) {
		this.h[key] = value;
	}
	,get: function(key) {
		return this.h[key];
	}
	,keys: function() {
		var a = [];
		for( var key in this.h ) if(this.h.hasOwnProperty(key)) a.push(key | 0);
		return new haxe_iterators_ArrayIterator(a);
	}
	,__class__: haxe_ds_IntMap
};
var haxe_ds_ObjectMap = function() {
	this.h = { __keys__ : { }};
};
haxe_ds_ObjectMap.__name__ = "haxe.ds.ObjectMap";
haxe_ds_ObjectMap.prototype = {
	set: function(key,value) {
		var id = key.__id__;
		if(id == null) {
			id = (key.__id__ = $global.$haxeUID++);
		}
		this.h[id] = value;
		this.h.__keys__[id] = key;
	}
	,get: function(key) {
		return this.h[key.__id__];
	}
	,keys: function() {
		var a = [];
		for( var key in this.h.__keys__ ) {
		if(this.h.hasOwnProperty(key)) {
			a.push(this.h.__keys__[key]);
		}
		}
		return new haxe_iterators_ArrayIterator(a);
	}
	,iterator: function() {
		return { ref : this.h, it : this.keys(), hasNext : function() {
			return this.it.hasNext();
		}, next : function() {
			var i = this.it.next();
			return this.ref[i.__id__];
		}};
	}
	,__class__: haxe_ds_ObjectMap
};
var haxe_ds_StringMap = function() {
	this.h = Object.create(null);
};
haxe_ds_StringMap.__name__ = "haxe.ds.StringMap";
haxe_ds_StringMap.prototype = {
	get: function(key) {
		return this.h[key];
	}
	,set: function(key,value) {
		this.h[key] = value;
	}
	,keys: function() {
		return new haxe_ds__$StringMap_StringMapKeyIterator(this.h);
	}
	,iterator: function() {
		return new haxe_ds__$StringMap_StringMapValueIterator(this.h);
	}
	,__class__: haxe_ds_StringMap
};
var haxe_ds__$StringMap_StringMapKeyIterator = function(h) {
	this.h = h;
	this.keys = Object.keys(h);
	this.length = this.keys.length;
	this.current = 0;
};
haxe_ds__$StringMap_StringMapKeyIterator.__name__ = "haxe.ds._StringMap.StringMapKeyIterator";
haxe_ds__$StringMap_StringMapKeyIterator.prototype = {
	hasNext: function() {
		return this.current < this.length;
	}
	,next: function() {
		return this.keys[this.current++];
	}
	,__class__: haxe_ds__$StringMap_StringMapKeyIterator
};
var haxe_ds__$StringMap_StringMapValueIterator = function(h) {
	this.h = h;
	this.keys = Object.keys(h);
	this.length = this.keys.length;
	this.current = 0;
};
haxe_ds__$StringMap_StringMapValueIterator.__name__ = "haxe.ds._StringMap.StringMapValueIterator";
haxe_ds__$StringMap_StringMapValueIterator.prototype = {
	hasNext: function() {
		return this.current < this.length;
	}
	,next: function() {
		return this.h[this.keys[this.current++]];
	}
	,__class__: haxe_ds__$StringMap_StringMapValueIterator
};
var haxe_io_Bytes = function(data) {
	this.length = data.byteLength;
	this.b = new Uint8Array(data);
	this.b.bufferValue = data;
	data.hxBytes = this;
	data.bytes = this.b;
};
haxe_io_Bytes.__name__ = "haxe.io.Bytes";
haxe_io_Bytes.ofString = function(s,encoding) {
	if(encoding == haxe_io_Encoding.RawNative) {
		var buf = new Uint8Array(s.length << 1);
		var _g = 0;
		var _g1 = s.length;
		while(_g < _g1) {
			var i = _g++;
			var c = s.charCodeAt(i);
			buf[i << 1] = c & 255;
			buf[i << 1 | 1] = c >> 8;
		}
		return new haxe_io_Bytes(buf.buffer);
	}
	var a = [];
	var i = 0;
	while(i < s.length) {
		var c = s.charCodeAt(i++);
		if(55296 <= c && c <= 56319) {
			c = c - 55232 << 10 | s.charCodeAt(i++) & 1023;
		}
		if(c <= 127) {
			a.push(c);
		} else if(c <= 2047) {
			a.push(192 | c >> 6);
			a.push(128 | c & 63);
		} else if(c <= 65535) {
			a.push(224 | c >> 12);
			a.push(128 | c >> 6 & 63);
			a.push(128 | c & 63);
		} else {
			a.push(240 | c >> 18);
			a.push(128 | c >> 12 & 63);
			a.push(128 | c >> 6 & 63);
			a.push(128 | c & 63);
		}
	}
	return new haxe_io_Bytes(new Uint8Array(a).buffer);
};
haxe_io_Bytes.prototype = {
	__class__: haxe_io_Bytes
};
var haxe_io_BytesBuffer = function() {
	this.pos = 0;
	this.size = 0;
};
haxe_io_BytesBuffer.__name__ = "haxe.io.BytesBuffer";
haxe_io_BytesBuffer.prototype = {
	addByte: function(byte) {
		if(this.pos == this.size) {
			this.grow(1);
		}
		this.view.setUint8(this.pos++,byte);
	}
	,add: function(src) {
		if(this.pos + src.length > this.size) {
			this.grow(src.length);
		}
		if(this.size == 0) {
			return;
		}
		var sub = new Uint8Array(src.b.buffer,src.b.byteOffset,src.length);
		this.u8.set(sub,this.pos);
		this.pos += src.length;
	}
	,addString: function(v,encoding) {
		this.add(haxe_io_Bytes.ofString(v,encoding));
	}
	,addInt32: function(v) {
		if(this.pos + 4 > this.size) {
			this.grow(4);
		}
		this.view.setInt32(this.pos,v,true);
		this.pos += 4;
	}
	,addInt64: function(v) {
		if(this.pos + 8 > this.size) {
			this.grow(8);
		}
		this.view.setInt32(this.pos,v.low,true);
		this.view.setInt32(this.pos + 4,v.high,true);
		this.pos += 8;
	}
	,addFloat: function(v) {
		if(this.pos + 4 > this.size) {
			this.grow(4);
		}
		this.view.setFloat32(this.pos,v,true);
		this.pos += 4;
	}
	,grow: function(delta) {
		var req = this.pos + delta;
		var nsize = this.size == 0 ? 16 : this.size;
		while(nsize < req) nsize = nsize * 3 >> 1;
		var nbuf = new ArrayBuffer(nsize);
		var nu8 = new Uint8Array(nbuf);
		if(this.size > 0) {
			nu8.set(this.u8);
		}
		this.size = nsize;
		this.buffer = nbuf;
		this.u8 = nu8;
		this.view = new DataView(this.buffer);
	}
	,getBytes: function() {
		if(this.size == 0) {
			return new haxe_io_Bytes(new ArrayBuffer(0));
		}
		var b = new haxe_io_Bytes(this.buffer);
		b.length = this.pos;
		return b;
	}
	,__class__: haxe_io_BytesBuffer
};
var haxe_io_Encoding = $hxEnums["haxe.io.Encoding"] = { __ename__:true,__constructs__:null
	,UTF8: {_hx_name:"UTF8",_hx_index:0,__enum__:"haxe.io.Encoding",toString:$estr}
	,RawNative: {_hx_name:"RawNative",_hx_index:1,__enum__:"haxe.io.Encoding",toString:$estr}
};
haxe_io_Encoding.__constructs__ = [haxe_io_Encoding.UTF8,haxe_io_Encoding.RawNative];
var haxe_io_Eof = function() {
};
haxe_io_Eof.__name__ = "haxe.io.Eof";
haxe_io_Eof.prototype = {
	toString: function() {
		return "Eof";
	}
	,__class__: haxe_io_Eof
};
var haxe_io_Error = $hxEnums["haxe.io.Error"] = { __ename__:true,__constructs__:null
	,Blocked: {_hx_name:"Blocked",_hx_index:0,__enum__:"haxe.io.Error",toString:$estr}
	,Overflow: {_hx_name:"Overflow",_hx_index:1,__enum__:"haxe.io.Error",toString:$estr}
	,OutsideBounds: {_hx_name:"OutsideBounds",_hx_index:2,__enum__:"haxe.io.Error",toString:$estr}
	,Custom: ($_=function(e) { return {_hx_index:3,e:e,__enum__:"haxe.io.Error",toString:$estr}; },$_._hx_name="Custom",$_.__params__ = ["e"],$_)
};
haxe_io_Error.__constructs__ = [haxe_io_Error.Blocked,haxe_io_Error.Overflow,haxe_io_Error.OutsideBounds,haxe_io_Error.Custom];
var haxe_io_Input = function() { };
haxe_io_Input.__name__ = "haxe.io.Input";
var haxe_io_Output = function() { };
haxe_io_Output.__name__ = "haxe.io.Output";
var haxe_iterators_ArrayIterator = function(array) {
	this.current = 0;
	this.array = array;
};
haxe_iterators_ArrayIterator.__name__ = "haxe.iterators.ArrayIterator";
haxe_iterators_ArrayIterator.prototype = {
	hasNext: function() {
		return this.current < this.array.length;
	}
	,next: function() {
		return this.array[this.current++];
	}
	,__class__: haxe_iterators_ArrayIterator
};
var js_Boot = function() { };
js_Boot.__name__ = "js.Boot";
js_Boot.getClass = function(o) {
	if(o == null) {
		return null;
	} else if(((o) instanceof Array)) {
		return Array;
	} else {
		var cl = o.__class__;
		if(cl != null) {
			return cl;
		}
		var name = js_Boot.__nativeClassName(o);
		if(name != null) {
			return js_Boot.__resolveNativeClass(name);
		}
		return null;
	}
};
js_Boot.__string_rec = function(o,s) {
	if(o == null) {
		return "null";
	}
	if(s.length >= 5) {
		return "<...>";
	}
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) {
		t = "object";
	}
	switch(t) {
	case "function":
		return "<function>";
	case "object":
		if(o.__enum__) {
			var e = $hxEnums[o.__enum__];
			var con = e.__constructs__[o._hx_index];
			var n = con._hx_name;
			if(con.__params__) {
				s = s + "\t";
				return n + "(" + ((function($this) {
					var $r;
					var _g = [];
					{
						var _g1 = 0;
						var _g2 = con.__params__;
						while(true) {
							if(!(_g1 < _g2.length)) {
								break;
							}
							var p = _g2[_g1];
							_g1 = _g1 + 1;
							_g.push(js_Boot.__string_rec(o[p],s));
						}
					}
					$r = _g;
					return $r;
				}(this))).join(",") + ")";
			} else {
				return n;
			}
		}
		if(((o) instanceof Array)) {
			var str = "[";
			s += "\t";
			var _g = 0;
			var _g1 = o.length;
			while(_g < _g1) {
				var i = _g++;
				str += (i > 0 ? "," : "") + js_Boot.__string_rec(o[i],s);
			}
			str += "]";
			return str;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( _g ) {
			return "???";
		}
		if(tostr != null && tostr != Object.toString && typeof(tostr) == "function") {
			var s2 = o.toString();
			if(s2 != "[object Object]") {
				return s2;
			}
		}
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		var k = null;
		for( k in o ) {
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) {
			str += ", \n";
		}
		str += s + k + " : " + js_Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "string":
		return o;
	default:
		return String(o);
	}
};
js_Boot.__nativeClassName = function(o) {
	var name = js_Boot.__toStr.call(o).slice(8,-1);
	if(name == "Object" || name == "Function" || name == "Math" || name == "JSON") {
		return null;
	}
	return name;
};
js_Boot.__resolveNativeClass = function(name) {
	return $global[name];
};
var js_node_Fs = require("fs");
var js_node_KeyValue = {};
js_node_KeyValue.__properties__ = {get_value:"get_value",get_key:"get_key"};
js_node_KeyValue.get_key = function(this1) {
	return this1[0];
};
js_node_KeyValue.get_value = function(this1) {
	return this1[1];
};
var js_node_buffer_Buffer = require("buffer").Buffer;
var js_node_stream_WritableNewOptionsAdapter = {};
js_node_stream_WritableNewOptionsAdapter.from = function(options) {
	if(!Object.prototype.hasOwnProperty.call(options,"final")) {
		Object.defineProperty(options,"final",{ get : function() {
			return options.final_;
		}});
	}
	return options;
};
var sys_io_FileInput = function(fd) {
	this.fd = fd;
	this.pos = 0;
};
sys_io_FileInput.__name__ = "sys.io.FileInput";
sys_io_FileInput.__super__ = haxe_io_Input;
sys_io_FileInput.prototype = $extend(haxe_io_Input.prototype,{
	readByte: function() {
		var buf = js_node_buffer_Buffer.alloc(1);
		var bytesRead;
		try {
			bytesRead = js_node_Fs.readSync(this.fd,buf,0,1,this.pos);
		} catch( _g ) {
			var e = haxe_Exception.caught(_g).unwrap();
			if(e.code == "EOF") {
				throw haxe_Exception.thrown(new haxe_io_Eof());
			} else {
				throw haxe_Exception.thrown(haxe_io_Error.Custom(e));
			}
		}
		if(bytesRead == 0) {
			throw haxe_Exception.thrown(new haxe_io_Eof());
		}
		this.pos++;
		return buf[0];
	}
	,readBytes: function(s,pos,len) {
		var data = s.b;
		var buf = js_node_buffer_Buffer.from(data.buffer,data.byteOffset,s.length);
		var bytesRead;
		try {
			bytesRead = js_node_Fs.readSync(this.fd,buf,pos,len,this.pos);
		} catch( _g ) {
			var e = haxe_Exception.caught(_g).unwrap();
			if(e.code == "EOF") {
				throw haxe_Exception.thrown(new haxe_io_Eof());
			} else {
				throw haxe_Exception.thrown(haxe_io_Error.Custom(e));
			}
		}
		if(bytesRead == 0) {
			throw haxe_Exception.thrown(new haxe_io_Eof());
		}
		this.pos += bytesRead;
		return bytesRead;
	}
	,close: function() {
		js_node_Fs.closeSync(this.fd);
	}
	,seek: function(p,pos) {
		switch(pos._hx_index) {
		case 0:
			this.pos = p;
			break;
		case 1:
			this.pos += p;
			break;
		case 2:
			this.pos = js_node_Fs.fstatSync(this.fd).size + p;
			break;
		}
	}
	,tell: function() {
		return this.pos;
	}
	,eof: function() {
		return this.pos >= js_node_Fs.fstatSync(this.fd).size;
	}
	,__class__: sys_io_FileInput
});
var sys_io_FileOutput = function(fd) {
	this.fd = fd;
	this.pos = 0;
};
sys_io_FileOutput.__name__ = "sys.io.FileOutput";
sys_io_FileOutput.__super__ = haxe_io_Output;
sys_io_FileOutput.prototype = $extend(haxe_io_Output.prototype,{
	writeByte: function(b) {
		var buf = js_node_buffer_Buffer.alloc(1);
		buf[0] = b;
		js_node_Fs.writeSync(this.fd,buf,0,1,this.pos);
		this.pos++;
	}
	,writeBytes: function(s,pos,len) {
		var data = s.b;
		var buf = js_node_buffer_Buffer.from(data.buffer,data.byteOffset,s.length);
		var wrote = js_node_Fs.writeSync(this.fd,buf,pos,len,this.pos);
		this.pos += wrote;
		return wrote;
	}
	,close: function() {
		js_node_Fs.closeSync(this.fd);
	}
	,seek: function(p,pos) {
		switch(pos._hx_index) {
		case 0:
			this.pos = p;
			break;
		case 1:
			this.pos += p;
			break;
		case 2:
			this.pos = js_node_Fs.fstatSync(this.fd).size + p;
			break;
		}
	}
	,tell: function() {
		return this.pos;
	}
	,__class__: sys_io_FileOutput
});
var sys_io_FileSeek = $hxEnums["sys.io.FileSeek"] = { __ename__:true,__constructs__:null
	,SeekBegin: {_hx_name:"SeekBegin",_hx_index:0,__enum__:"sys.io.FileSeek",toString:$estr}
	,SeekCur: {_hx_name:"SeekCur",_hx_index:1,__enum__:"sys.io.FileSeek",toString:$estr}
	,SeekEnd: {_hx_name:"SeekEnd",_hx_index:2,__enum__:"sys.io.FileSeek",toString:$estr}
};
sys_io_FileSeek.__constructs__ = [sys_io_FileSeek.SeekBegin,sys_io_FileSeek.SeekCur,sys_io_FileSeek.SeekEnd];
var thinghandler_BytesBufferTools = function() { };
thinghandler_BytesBufferTools.__name__ = "thinghandler.BytesBufferTools";
thinghandler_BytesBufferTools.addFloatTriplet = function(buf,triplet) {
	buf.addFloat(triplet.x);
	buf.addFloat(triplet.y);
	buf.addFloat(triplet.z);
};
thinghandler_BytesBufferTools.addFloatQuadlet = function(buf,quadlet) {
	buf.addFloat(quadlet.x);
	buf.addFloat(quadlet.y);
	buf.addFloat(quadlet.z);
	buf.addFloat(quadlet.w);
};
thinghandler_BytesBufferTools.addStringWLength = function(buf,string,encoding) {
	if(encoding == null) {
		encoding = haxe_io_Encoding.UTF8;
	}
	buf.addInt32(string.length);
	buf.addString(string,haxe_io_Encoding.UTF8);
};
thinghandler_BytesBufferTools.addIntArray = function(buf,arr) {
	buf.addInt32(arr.length);
	var _g = 0;
	while(_g < arr.length) {
		var int = arr[_g];
		++_g;
		buf.addInt32(int);
	}
};
var thinghandler_Color = {};
thinghandler_Color.__properties__ = {get_white:"get_white",set_b:"set_b",get_b:"get_b",set_g:"set_g",get_g:"get_g",set_r:"set_r",get_r:"get_r"};
thinghandler_Color._new = function(r,g,b) {
	var this1 = { x : r, y : g, z : b};
	return this1;
};
thinghandler_Color.get_white = function() {
	return thinghandler_Color._new(1,1,1);
};
thinghandler_Color.get_r = function(this1) {
	return this1.x;
};
thinghandler_Color.set_r = function(this1,v) {
	return this1.x = v;
};
thinghandler_Color.get_g = function(this1) {
	return this1.y;
};
thinghandler_Color.set_g = function(this1,v) {
	return this1.y = v;
};
thinghandler_Color.get_b = function(this1) {
	return this1.z;
};
thinghandler_Color.set_b = function(this1,v) {
	return this1.z = v;
};
var thinghandler_TexturePropertyMap = {};
thinghandler_TexturePropertyMap.__properties__ = {set_param3:"set_param3",get_param3:"get_param3",set_param2:"set_param2",get_param2:"get_param2",set_param1:"set_param1",get_param1:"get_param1",set_glow:"set_glow",get_glow:"get_glow",set_offsetX:"set_offsetX",get_offsetX:"get_offsetX",set_offsetY:"set_offsetY",get_offsetY:"get_offsetY",set_rotation:"set_rotation",get_rotation:"get_rotation",set_strength:"set_strength",get_strength:"get_strength",set_scaleX:"set_scaleX",get_scaleX:"get_scaleX",set_scaleY:"set_scaleY",get_scaleY:"get_scaleY"};
thinghandler_TexturePropertyMap.get_scaleY = function(this1) {
	return this1.h[0];
};
thinghandler_TexturePropertyMap.set_scaleY = function(this1,v) {
	this1.h[0] = v;
	return v;
};
thinghandler_TexturePropertyMap.get_scaleX = function(this1) {
	return this1.h[1];
};
thinghandler_TexturePropertyMap.set_scaleX = function(this1,v) {
	this1.h[1] = v;
	return v;
};
thinghandler_TexturePropertyMap.get_strength = function(this1) {
	return this1.h[2];
};
thinghandler_TexturePropertyMap.set_strength = function(this1,v) {
	this1.h[2] = v;
	return v;
};
thinghandler_TexturePropertyMap.get_rotation = function(this1) {
	return this1.h[3];
};
thinghandler_TexturePropertyMap.set_rotation = function(this1,v) {
	this1.h[3] = v;
	return v;
};
thinghandler_TexturePropertyMap.get_offsetY = function(this1) {
	return this1.h[4];
};
thinghandler_TexturePropertyMap.set_offsetY = function(this1,v) {
	this1.h[4] = v;
	return v;
};
thinghandler_TexturePropertyMap.get_offsetX = function(this1) {
	return this1.h[5];
};
thinghandler_TexturePropertyMap.set_offsetX = function(this1,v) {
	this1.h[5] = v;
	return v;
};
thinghandler_TexturePropertyMap.get_glow = function(this1) {
	return this1.h[6];
};
thinghandler_TexturePropertyMap.set_glow = function(this1,v) {
	this1.h[6] = v;
	return v;
};
thinghandler_TexturePropertyMap.get_param1 = function(this1) {
	return this1.h[7];
};
thinghandler_TexturePropertyMap.set_param1 = function(this1,v) {
	this1.h[7] = v;
	return v;
};
thinghandler_TexturePropertyMap.get_param2 = function(this1) {
	return this1.h[8];
};
thinghandler_TexturePropertyMap.set_param2 = function(this1,v) {
	this1.h[8] = v;
	return v;
};
thinghandler_TexturePropertyMap.get_param3 = function(this1) {
	return this1.h[9];
};
thinghandler_TexturePropertyMap.set_param3 = function(this1,v) {
	this1.h[9] = v;
	return v;
};
var thinghandler_Triplet = {};
thinghandler_Triplet.eq = function(this1,b) {
	if(this1.x == b.x && this1.y == b.y) {
		return this1.z == b.z;
	} else {
		return false;
	}
};
thinghandler_Triplet.asJsonArrayNoBrackets = function(this1) {
	return "" + Std.string(this1.x) + "," + Std.string(this1.y) + "," + Std.string(this1.z);
};
thinghandler_Triplet.asJsonArray = function(this1) {
	return "[" + thinghandler_Triplet.asJsonArrayNoBrackets(this1) + "]";
};
thinghandler_Triplet._new = function(x,y,z) {
	var this1 = { x : x, y : y, z : z};
	return this1;
};
thinghandler_Triplet.fromArray = function(arr) {
	return thinghandler_Triplet._new(arr[0],arr[1],arr[2]);
};
thinghandler_Triplet.asArray = function(this1) {
	return [this1.x,this1.y,this1.z];
};
var thinghandler_Thing = function() {
	this.lockedRot = 0;
	this.lockedPos = 0;
	this.angularDrag = null;
	this.dragMass = null;
	this.physicsMass = null;
	this.personalExperience = false;
	this.invisibleToDesktopCamera = false;
	this.floatsOnLiquid = false;
	this.isNeverClonable = false;
	this.movableByEveryone = false;
	this.uncollidable = false;
	this.invisible = false;
	this.persistWhenThrownOrEmitted = false;
	this.removeOriginalWhenGrabbed = false;
	this.stricterPhysicsSyncing = false;
	this.activeInInventory = false;
	this.reflectDepth = false;
	this.reflectVertical = false;
	this.reflectSideways = false;
	this.keepSizeInInventory = false;
	this.omitAutoHapticFeedback = false;
	this.omitAutoSounds = false;
	this.dontRecieveShadow = false;
	this.dontCastShadow = false;
	this.addBodyWhenWornNonClearing = false;
	this.replaceInstInArea = false;
	this.invisibleWhenWorn = false;
	this.snapAllPartsToGrid = false;
	this.scaleUniformally = false;
	this.finetuneParts = false;
	this.isSittable = false;
	this.mergeParticleSystems = false;
	this.replacesHandsWhenAttached = false;
	this.canGetEventsWhenStateChanging = false;
	this.hasSurrondSound = false;
	this.addBodyWhenWorn = false;
	this.alwaysMergeParts = false;
	this.softSnapAngles = false;
	this.scaleAllParts = false;
	this.showAtDistance = false;
	this.amplifySpeech = false;
	this.doSnapPosition = false;
	this.isSlidey = false;
	this.isSticky = false;
	this.doesShatter = false;
	this.doesFloat = false;
	this.keepPreciseCollider = false;
	this.doShowDirection = false;
	this.isBouncy = false;
	this.doSnapAngles = false;
	this.isUnwalkable = false;
	this.isPassable = false;
	this.isClimbable = false;
	this.remainsHeld = false;
	this.isHoldable = false;
	this.isClonable = false;
	this.bodyAttachments = ["0","0","0","0","0","0","0","0"];
	this.includedThingIds = new haxe_ds_StringMap();
	this.parts = [];
	this.description = null;
	this.id = "1";
	this.givenName = "";
};
thinghandler_Thing.__name__ = "thinghandler.Thing";
thinghandler_Thing.prototype = {
	copy: function() {
		return new cloner_Cloner().clone(this);
	}
	,__class__: thinghandler_Thing
};
var thinghandler_ThingPart = function() {
	this.showDirectionalArrowsWhenEditing = false;
	this.lightOmitsShadow = false;
	this.partInvisbleWhenWorn = false;
	this.personalExperience = false;
	this.isDedicatedCollider = false;
	this.partUncollidable = false;
	this.persistStates = false;
	this.screenFlipsX = false;
	this.reflectPartDepth = false;
	this.reflectPartVertical = false;
	this.reflectPartSideways = false;
	this.subthingFollowDelayed = false;
	this.stretchSkydomeSeam = false;
	this.useTextureAsSky = false;
	this.videoScreenIsDirectlyOnMesh = false;
	this.videoScreenLoops = false;
	this.allowBlackImageBackgrounds = false;
	this.isImagePasteScreen = false;
	this.avoidRecieveShadow = false;
	this.isLocked = false;
	this.isPositionLocker = false;
	this.isAngleLocker = false;
	this.textAlignRight = false;
	this.textAlignCenter = false;
	this.looselyCoupledParticles = false;
	this.avoidCastShadow = false;
	this.textureScalesUniformally = false;
	this.doTextureSnapAngles = false;
	this.omitAutoSoundsPart = false;
	this.isCenter = false;
	this.partInvisible = false;
	this.useUnsoftenedAnim = false;
	this.isFisheyeCamera = false;
	this.isCameraButton = false;
	this.isCamera = false;
	this.isSlideshowButton = false;
	this.offersSlideshow = false;
	this.isLiquid = false;
	this.screenSurrondSound = false;
	this.scalesUniformally = false;
	this.isVideoButton = false;
	this.offersScreen = false;
	this.placedSubThings = null;
	this.includedSubThings = null;
	this.text = null;
	this.states = [];
	this.convex = null;
	this.smoothingAngle = null;
	this.imageType = 0;
	this.changedVerticies = new haxe_ds_IntMap();
	this.textureTypes = [0,0].slice(0);
	this.particleSystem = 0;
	this.imageUrl = null;
	this.textLineHeight = 1;
	this.isText = false;
	this.givenName = null;
	this.guid = null;
	this.materialType = 0;
	this.baseType = 1;
};
thinghandler_ThingPart.__name__ = "thinghandler.ThingPart";
thinghandler_ThingPart.prototype = {
	copy: function() {
		return new cloner_Cloner().clone(this);
	}
	,__class__: thinghandler_ThingPart
};
var thinghandler_ThingPartState = function() {
	this.color = thinghandler_Color.get_white();
	this.textureColors = [thinghandler_Color._new(0,0,0),thinghandler_Color._new(0,0,0)].slice(0);
	this.particleSystemColor = thinghandler_Color._new(0,0,0);
	this.particleSystemProperty = new haxe_ds_IntMap();
	this.textureProperties = [new haxe_ds_IntMap(),new haxe_ds_IntMap()].slice(0);
	this.scriptLines = [];
	this.scale = { x : 0, y : 0, z : 0};
	this.rotation = { x : 0, y : 0, z : 0};
	this.position = { x : 0, y : 0, z : 0};
};
thinghandler_ThingPartState.__name__ = "thinghandler.ThingPartState";
thinghandler_ThingPartState.prototype = {
	copy: function() {
		return new cloner_Cloner().clone(this);
	}
	,__class__: thinghandler_ThingPartState
};
var thinghandler_SubThingInfo = function(placedSubThing) {
	this.placedSubThing = false;
	this.nameOverride = null;
	this.invertUncollidable = false;
	this.invertInvisible = false;
	this.invertIsHoldable = false;
	this.rot = { x : 0, y : 0, z : 0};
	this.pos = { x : 0, y : 0, z : 0};
	this.thingId = "";
	this.placedSubThing = placedSubThing;
};
thinghandler_SubThingInfo.__name__ = "thinghandler.SubThingInfo";
thinghandler_SubThingInfo.prototype = {
	__class__: thinghandler_SubThingInfo
};
var thinghandler_ChangedVerticies = {};
thinghandler_ChangedVerticies.__properties__ = {set_indexes:"set_indexes",get_indexes:"get_indexes",set_z:"set_z",get_z:"get_z",set_y:"set_y",get_y:"get_y",set_x:"set_x",get_x:"get_x"};
thinghandler_ChangedVerticies.get_x = function(this1) {
	return this1[0];
};
thinghandler_ChangedVerticies.set_x = function(this1,f) {
	return this1[0] = f;
};
thinghandler_ChangedVerticies.get_y = function(this1) {
	return this1[1];
};
thinghandler_ChangedVerticies.set_y = function(this1,f) {
	return this1[1] = f;
};
thinghandler_ChangedVerticies.get_z = function(this1) {
	return this1[2];
};
thinghandler_ChangedVerticies.set_z = function(this1,f) {
	return this1[2] = f;
};
thinghandler_ChangedVerticies.get_indexes = function(this1) {
	return this1.slice(3);
};
thinghandler_ChangedVerticies.set_indexes = function(this1,arr) {
	this1.length = 3;
	this1.concat(arr);
	return this1;
};
thinghandler_ChangedVerticies.toTripletFloat = function(this1) {
	return thinghandler_Triplet._new(thinghandler_ChangedVerticies.get_x(this1),thinghandler_ChangedVerticies.get_y(this1),thinghandler_ChangedVerticies.get_z(this1));
};
var thinghandler_ThingHandler = function() { };
thinghandler_ThingHandler.__name__ = "thinghandler.ThingHandler";
thinghandler_ThingHandler.importJson = function(json,keepPartsSeperate,isForPlacement) {
	if(isForPlacement == null) {
		isForPlacement = false;
	}
	if(keepPartsSeperate == null) {
		keepPartsSeperate = false;
	}
	var data = JSON.parse(json);
	var thing = new thinghandler_Thing();
	thing.givenName = data.n != null ? data.n : thinghandler_Thing.defaultName;
	thing.version = data.v != null ? data.v : 1;
	thing.description = data.d;
	thinghandler_ThingHandler.expandThingAttributeFromJson(thing,data.a);
	thinghandler_ThingHandler.expandThingIncludedNameIdsFromJson(thing,data.inc);
	if(data.tp_m != null) {
		thing.physicsMass = data.tp_m;
	}
	if(data.tp_d != null) {
		thing.dragMass = data.tp_d;
	}
	if(data.tp_ad != null) {
		thing.angularDrag = data.tp_ad;
	}
	if(data.tp_lp != null) {
		thing.lockedPos = thinghandler_ThingHandler.getBoolAxies(data.tp_lp);
	}
	if(data.tp_lr != null) {
		thing.lockedRot = thinghandler_ThingHandler.getBoolAxies(data.tp_lr);
	}
	var _g = 0;
	var _g1 = data.p;
	while(_g < _g1.length) {
		var jsonpart = _g1[_g];
		++_g;
		var thingpart = new thinghandler_ThingPart();
		thinghandler_ThingHandler.expandPartAttributeFromJson(thingpart,jsonpart.a);
		if(jsonpart.n != null) {
			thingpart.givenName = jsonpart.n;
		}
		if(jsonpart.ac != null) {
			thingpart.autoContinuation = new thinghandler_ThingPartAutocomplete();
			thingpart.autoContinuation.fromJson(jsonpart.ac);
		}
		if(thingpart.isText && jsonpart.e != null) {
			thingpart.text = jsonpart.e;
			if(jsonpart.lh != null) {
				thingpart.textLineHeight = jsonpart.lh;
			}
		}
		if(jsonpart.t != null) {
			thingpart.materialType = jsonpart.t;
			if(thingpart.materialType == 8) {
				thingpart.materialType = 0;
				thingpart.partInvisible = true;
			}
		} else if(thingpart.isText && thing.version <= 3) {
			thingpart.materialType = 2;
		}
		thinghandler_ThingHandler.applyVertexChangesAndSmoothingAngles(thingpart,jsonpart,data.p);
		if(jsonpart.i != null) {
			thingpart.includedSubThings = [];
			var _g2 = 0;
			var _g3 = jsonpart.i;
			while(_g2 < _g3.length) {
				var subThingNode = _g3[_g2];
				++_g2;
				var includedSubthing = new thinghandler_SubThingInfo(false);
				includedSubthing.thingId = subThingNode.t;
				includedSubthing.pos = subThingNode.p;
				includedSubthing.rot = subThingNode.r;
				if(subThingNode.n != null) {
					includedSubthing.nameOverride = subThingNode.n;
				}
				thinghandler_ThingHandler.expandIncludedSubthingInvertAttribute(includedSubthing,subThingNode.a);
				thingpart.includedSubThings.push(includedSubthing);
			}
		}
		if(jsonpart.su != null && jsonpart.su.length >= 1) {
			var _g4 = 0;
			var _g5 = jsonpart.su;
			while(_g4 < _g5.length) {
				var pSNode = _g5[_g4];
				++_g4;
				if(pSNode.i != null) {
					var placedSubthing = new thinghandler_SubThingInfo(true);
					placedSubthing.thingId = pSNode.t;
					placedSubthing.pos = pSNode.p;
					placedSubthing.rot = pSNode.r;
				}
			}
		}
		if(jsonpart.im != null) {
			thingpart.imageUrl = jsonpart.im;
			if(jsonpart.imt != null) {
				thingpart.imageType = jsonpart.imt;
			}
		}
		var shiftTexture2Left = jsonpart.t1 == null && jsonpart.t2 != null;
		if(jsonpart.t1 != null) {
			thingpart.textureTypes[0] = jsonpart.t1;
		}
		if(jsonpart.t2 != null) {
			thingpart.textureTypes[shiftTexture2Left ? 0 : 1] = jsonpart.t2;
		}
		if(jsonpart.pr != null) {
			thingpart.particleSystem = jsonpart.pr;
		}
		var partContainsScript = false;
		var maxStates = jsonpart.s.length;
		var _g6 = 0;
		var _g7 = maxStates;
		while(_g6 < _g7) {
			var statesI = _g6++;
			thingpart.states[statesI] = new thinghandler_ThingPartState();
			var state = jsonpart.s[statesI];
			thingpart.states[statesI].position = state.p;
			thingpart.states[statesI].rotation = state.r;
			thingpart.states[statesI].scale = state.s;
			thingpart.states[statesI].color = state.c;
			if(state.b != null) {
				partContainsScript = true;
				var _g8 = 0;
				var _g9 = state.b;
				while(_g8 < _g9.length) {
					var line = _g9[_g8];
					++_g8;
					thingpart.states[statesI].scriptLines.push(line);
				}
			}
		}
	}
	return thing;
};
thinghandler_ThingHandler.expandIncludedSubthingInvertAttribute = function(incSubthing,attrs) {
	if(attrs != null) {
		var _g = 0;
		while(_g < attrs.length) {
			var attr = attrs[_g];
			++_g;
			switch(attr) {
			case 2:
				incSubthing.invertIsHoldable = true;
				break;
			case 48:
				incSubthing.invertInvisible = true;
				break;
			case 49:
				incSubthing.invertUncollidable = true;
				break;
			default:
			}
		}
	}
};
thinghandler_ThingHandler.applyVertexChangesAndSmoothingAngles = function(part,partNode,thingNode) {
	if(partNode.c != null || partNode.v != null || partNode.sa != null) {
		if(partNode.v != null) {
			var indexRef = partNode.v;
			partNode.c = thingNode[indexRef].c;
			if(thingNode[indexRef].sa != null) {
				partNode.sa = thingNode[indexRef].sa;
			}
			if(thingNode[indexRef].cx != null) {
				partNode.cx = thingNode[indexRef].cx;
			}
		}
		if(partNode.c != null) {
			part.changedVerticies = new haxe_ds_IntMap();
			var _g = 0;
			var _g1 = partNode.c;
			while(_g < _g1.length) {
				var item = _g1[_g];
				++_g;
				var vector = thinghandler_ChangedVerticies.toTripletFloat(item);
				var previousVertexIndex = 0;
				var _g2 = 0;
				var _g3 = thinghandler_ChangedVerticies.get_indexes(item);
				while(_g2 < _g3.length) {
					var relVertexIndex = _g3[_g2];
					++_g2;
					var vertexIndex = previousVertexIndex + relVertexIndex;
					if(vertexIndex < thinghandler_ChangedVerticies.get_indexes(item).length) {
						previousVertexIndex = vertexIndex;
						part.changedVerticies.h[vertexIndex] = vector;
					}
				}
			}
		}
		if(partNode.sa != null) {
			part.smoothingAngle = partNode.sa;
		}
		if(partNode.cx != null) {
			part.convex = partNode.cx == 1;
		}
	}
};
thinghandler_ThingHandler.getBoolAxies = function(axies) {
	var boolAxises = 0;
	if(axies[0] == 1) {
		boolAxises |= 1;
	}
	if(axies[1] == 1) {
		boolAxises |= 2;
	}
	if(axies[2] == 1) {
		boolAxises |= 4;
	}
	return boolAxises;
};
thinghandler_ThingHandler.expandThingIncludedNameIdsFromJson = function(thing,jsonNameIds) {
	if(jsonNameIds != null) {
		var _g = 0;
		while(_g < jsonNameIds.length) {
			var nameId = jsonNameIds[_g];
			++_g;
			thing.includedThingIds.h[nameId[0]] = nameId[1];
		}
	}
};
thinghandler_ThingHandler.expandThingAttributeFromJson = function(thing,attributes) {
	if(attributes != null) {
		var _g = 0;
		while(_g < attributes.length) {
			var attr = attributes[_g];
			++_g;
			switch(attr) {
			case 1:
				thing.isClonable = true;
				break;
			case 2:
				thing.isHoldable = true;
				break;
			case 3:
				thing.remainsHeld = true;
				break;
			case 4:
				thing.isClimbable = true;
				break;
			case 5:
				thing.isUnwalkable = true;
				break;
			case 6:
				thing.isPassable = true;
				break;
			case 7:
				thing.doSnapAngles = true;
				break;
			case 9:
				thing.isBouncy = true;
				break;
			case 12:
				thing.doShowDirection = true;
				break;
			case 13:
				thing.keepPreciseCollider = true;
				break;
			case 14:
				thing.doesFloat = true;
				break;
			case 15:
				thing.doesShatter = true;
				break;
			case 16:
				thing.isSticky = true;
				break;
			case 17:
				thing.isSlidey = true;
				break;
			case 18:
				thing.doSnapPosition = true;
				break;
			case 19:
				thing.amplifySpeech = true;
				break;
			case 20:
				thing.showAtDistance = true;
				break;
			case 21:
				thing.scaleAllParts = true;
				break;
			case 22:
				thing.softSnapAngles = true;
				break;
			case 23:
				thing.alwaysMergeParts = true;
				break;
			case 24:
				thing.addBodyWhenWorn = true;
				break;
			case 25:
				thing.hasSurrondSound = true;
				break;
			case 26:
				thing.canGetEventsWhenStateChanging = true;
				break;
			case 27:
				thing.replacesHandsWhenAttached = true;
				break;
			case 28:
				thing.mergeParticleSystems = true;
				break;
			case 29:
				thing.isSittable = true;
				break;
			case 30:
				thing.finetuneParts = true;
				break;
			case 31:
				thing.scaleUniformally = true;
				break;
			case 32:
				thing.snapAllPartsToGrid = true;
				break;
			case 33:
				thing.invisibleWhenWorn = true;
				break;
			case 34:
				thing.replaceInstInArea = true;
				break;
			case 35:
				thing.addBodyWhenWornNonClearing = true;
				break;
			case 36:
				thing.dontCastShadow = true;
				break;
			case 37:
				thing.dontRecieveShadow = true;
				break;
			case 38:
				thing.omitAutoSounds = true;
				break;
			case 39:
				thing.omitAutoHapticFeedback = true;
				break;
			case 40:
				thing.keepSizeInInventory = true;
				break;
			case 41:
				thing.reflectSideways = true;
				break;
			case 42:
				thing.reflectVertical = true;
				break;
			case 43:
				thing.reflectDepth = true;
				break;
			case 44:
				thing.activeInInventory = true;
				break;
			case 45:
				thing.stricterPhysicsSyncing = true;
				break;
			case 46:
				thing.removeOriginalWhenGrabbed = true;
				break;
			case 47:
				thing.persistWhenThrownOrEmitted = true;
				break;
			case 48:
				thing.invisible = true;
				break;
			case 49:
				thing.uncollidable = true;
				break;
			case 50:
				thing.movableByEveryone = true;
				break;
			case 51:
				thing.isNeverClonable = true;
				break;
			case 52:
				thing.floatsOnLiquid = true;
				break;
			case 53:
				thing.invisibleToDesktopCamera = true;
				break;
			default:
			}
		}
	}
};
thinghandler_ThingHandler.expandPartAttributeFromJson = function(part,attributes) {
	if(attributes != null) {
		var _g = 0;
		while(_g < attributes.length) {
			var attr = attributes[_g];
			++_g;
			switch(attr) {
			case 1:
				part.offersScreen = true;
				break;
			case 2:
				part.isVideoButton = true;
				break;
			case 3:
				part.scalesUniformally = true;
				break;
			case 4:
				part.screenSurrondSound = true;
				break;
			case 5:
				part.isLiquid = true;
				break;
			case 6:
				part.offersSlideshow = true;
				break;
			case 7:
				part.isSlideshowButton = true;
				break;
			case 8:
				part.isCamera = true;
				break;
			case 9:
				part.isCameraButton = true;
				break;
			case 10:
				part.isFisheyeCamera = true;
				break;
			case 11:
				part.useUnsoftenedAnim = true;
				break;
			case 12:
				part.partInvisible = true;
				break;
			case 13:
				part.isCenter = true;
				break;
			case 14:
				part.omitAutoSoundsPart = true;
				break;
			case 15:
				part.doTextureSnapAngles = true;
				break;
			case 16:
				part.textureScalesUniformally = true;
				break;
			case 17:
				part.avoidCastShadow = true;
				break;
			case 18:
				part.looselyCoupledParticles = true;
				break;
			case 19:
				part.textAlignCenter = true;
				break;
			case 20:
				part.textAlignRight = true;
				break;
			case 21:
				part.isAngleLocker = true;
				break;
			case 22:
				part.isPositionLocker = true;
				break;
			case 23:
				part.isLocked = true;
				break;
			case 24:
				part.avoidRecieveShadow = true;
				break;
			case 25:
				part.isImagePasteScreen = true;
				break;
			case 26:
				part.allowBlackImageBackgrounds = true;
				break;
			case 27:
				part.videoScreenLoops = true;
				break;
			case 28:
				part.videoScreenIsDirectlyOnMesh = true;
				break;
			case 29:
				part.useTextureAsSky = true;
				break;
			case 30:
				part.stretchSkydomeSeam = true;
				break;
			case 31:
				part.subthingFollowDelayed = true;
				break;
			case 32:
				part.reflectPartSideways = true;
				break;
			case 33:
				part.reflectPartVertical = true;
				break;
			case 34:
				part.reflectPartDepth = true;
				break;
			case 35:
				part.screenFlipsX = true;
				break;
			case 36:
				part.persistStates = true;
				break;
			case 37:
				part.partUncollidable = true;
				break;
			case 38:
				part.isDedicatedCollider = true;
				break;
			case 39:
				part.personalExperience = true;
				break;
			case 40:
				part.partInvisbleWhenWorn = true;
				break;
			case 41:
				part.lightOmitsShadow = true;
				break;
			case 42:
				part.showDirectionalArrowsWhenEditing = true;
				break;
			}
		}
	}
};
thinghandler_ThingHandler.expandIncludedSubThingInvertAttributes = function(subThing,attributes) {
	if(attributes != null) {
		var _g = 0;
		while(_g < attributes.length) {
			var attr = attributes[_g];
			++_g;
			switch(attr) {
			case 2:
				subThing.invertIsHoldable = true;
				break;
			case 48:
				subThing.invertInvisible = true;
				break;
			case 49:
				subThing.invertUncollidable = true;
				break;
			default:
			}
		}
	}
};
thinghandler_ThingHandler.exportBytes = function(thing) {
	var buf = new haxe_io_BytesBuffer();
	var changedVertsIndex = new haxe_ds_StringMap();
	var read = thing.copy();
	if(read.version > thinghandler_Thing.currentVersion) {
		read.version = thinghandler_Thing.currentVersion;
	}
	buf.addByte(read.version);
	if(read.givenName == null || read.givenName == "") {
		read.givenName = thinghandler_Thing.defaultName;
	}
	thinghandler_ThingHandler.writeStringWLength(buf,read.givenName);
	if(read.description == null) {
		read.description = "";
	}
	thinghandler_ThingHandler.writeStringWLength(buf,read.description);
	buf.addInt64(thinghandler_ThingHandler.getAttributes(thing));
	thinghandler_ThingHandler.writeStringMap(buf,thing.includedThingIds);
	if(thing.addBodyWhenWorn || thing.addBodyWhenWornNonClearing) {
		thinghandler_ThingHandler.writeStringArray(buf,thing.bodyAttachments);
	}
	buf.addInt32(thing.parts.length);
	var iInThing = 0;
	var _g = 0;
	var _g1 = thing.parts;
	while(_g < _g1.length) {
		var part = _g1[_g];
		++_g;
		buf.addInt64(thinghandler_ThingHandler.getPartAttributes(part));
		buf.addByte(part.baseType);
		buf.addByte(part.materialType);
		buf.addByte(part.particleSystem);
		buf.addByte(part.textureTypes[0]);
		buf.addByte(part.textureTypes[1]);
		thinghandler_ThingHandler.writeStringWLength(buf,part.guid);
		thinghandler_ThingHandler.writeStringWLength(buf,part.givenName);
		if(part.isText) {
			buf.addFloat(part.textLineHeight);
			thinghandler_ThingHandler.writeStringWLength(buf,part.text);
		}
		thinghandler_ThingHandler.writeIncludedSubthings(buf,thing,part);
		thinghandler_ThingHandler.writePlacedSubthings(buf,part);
		if(part.imageUrl == null || part.imageUrl.length == 0) {
			buf.addInt32(0);
		} else {
			thinghandler_BytesBufferTools.addStringWLength(buf,part.imageUrl);
			buf.addByte(part.imageType);
		}
		if(part.autoContinuation == null) {
			buf.addInt32(0);
		} else {
			part.autoContinuation.writeBytes(buf);
		}
		thinghandler_ThingHandler.writeChangedVertices(buf,part,changedVertsIndex,iInThing);
		if(part.smoothingAngle != null) {
			buf.addInt32(part.smoothingAngle);
		} else {
			buf.addInt32(361);
		}
		buf.addByte(part.convex != null ? part.convex ? 1 : 0 : 2);
		thinghandler_ThingHandler.writeStateBytes(buf,part);
		++iInThing;
	}
	return buf.getBytes();
};
thinghandler_ThingHandler.writeIncludedSubthings = function(buf,thing,part) {
	if(part.includedSubThings == null) {
		buf.addInt32(0);
		return;
	}
	buf.addInt32(part.includedSubThings.length);
	var _g = 0;
	var _g1 = part.includedSubThings;
	while(_g < _g1.length) {
		var iSubThing = _g1[_g];
		++_g;
		thinghandler_ThingHandler.writeStringWLength(buf,iSubThing.thingId);
		thinghandler_BytesBufferTools.addFloatTriplet(buf,iSubThing.pos);
		thinghandler_BytesBufferTools.addFloatTriplet(buf,iSubThing.rot);
		thinghandler_ThingHandler.writeStringWLength(buf,iSubThing.nameOverride != null ? iSubThing.nameOverride : thing.givenName);
		buf.addByte(thinghandler_ThingHandler.getSubthingAttr(iSubThing));
	}
};
thinghandler_ThingHandler.writePlacedSubthings = function(buf,part) {
	if(part.placedSubThings == null) {
		buf.addInt32(0);
		return;
	}
	buf.addInt32(Lambda.count(part.placedSubThings));
	var h = part.placedSubThings.h;
	var _g_h = h;
	var _g_keys = Object.keys(h);
	var _g_length = _g_keys.length;
	var _g_current = 0;
	while(_g_current < _g_length) {
		var key = _g_keys[_g_current++];
		var _g1_key = key;
		var _g1_value = _g_h[key];
		var placementId = _g1_key;
		var pSubThing = _g1_value;
		thinghandler_BytesBufferTools.addStringWLength(buf,placementId);
		thinghandler_BytesBufferTools.addStringWLength(buf,pSubThing.thingId);
		thinghandler_BytesBufferTools.addFloatTriplet(buf,pSubThing.pos);
		thinghandler_BytesBufferTools.addFloatTriplet(buf,pSubThing.rot);
	}
};
thinghandler_ThingHandler.getSubthingAttr = function(subthing) {
	var bits = 0;
	if(subthing.invertUncollidable) {
		bits = bits | 4;
	}
	if(subthing.invertInvisible) {
		bits = bits | 2;
	}
	if(subthing.invertIsHoldable) {
		bits = bits | 1;
	}
	return bits;
};
thinghandler_ThingHandler.removeUnusedPartGuids = function(thing) {
	var _g = 0;
	var _g1 = thing.parts;
	while(_g < _g1.length) {
		var part = _g1[_g];
		++_g;
		if(part.guid != null && part.guid != "" && !thinghandler_ThingHandler.isPartGuidUsed(thing,part.guid,part)) {
			part.guid = null;
		}
	}
};
thinghandler_ThingHandler.isPartGuidUsed = function(thing,guid,ignorePart) {
	var _g = 0;
	var _g1 = thing.parts;
	while(_g < _g1.length) {
		var part = _g1[_g];
		++_g;
		if(part != ignorePart && part.autoContinuation != null && part.autoContinuation.fromPart.guid == guid) {
			return true;
		}
	}
	return false;
};
thinghandler_ThingHandler.writeStringMap = function(buf,map) {
	buf.addInt32(Lambda.count(map));
	var h = map.h;
	var _g_h = h;
	var _g_keys = Object.keys(h);
	var _g_length = _g_keys.length;
	var _g_current = 0;
	while(_g_current < _g_length) {
		var key = _g_keys[_g_current++];
		var _g1_key = key;
		var _g1_value = _g_h[key];
		var key1 = _g1_key;
		var value = _g1_value;
		thinghandler_ThingHandler.writeStringWLength(buf,key1);
		thinghandler_ThingHandler.writeStringWLength(buf,value);
	}
};
thinghandler_ThingHandler.writeStringArray = function(buf,array) {
	buf.addInt32(array.length);
	var _g = 0;
	while(_g < array.length) {
		var value = array[_g];
		++_g;
		thinghandler_ThingHandler.writeStringWLength(buf,value);
	}
};
thinghandler_ThingHandler.writeStringWLength = function(buf,string) {
	if(string != null) {
		buf.addInt32(string.length);
		buf.addString(string,haxe_io_Encoding.UTF8);
	} else {
		buf.addInt32(0);
	}
};
thinghandler_ThingHandler.writeChangedVertices = function(buf,part,changedVertsIndexRef,indexWithinThing) {
	var indicesByPosition = new haxe_ds_ObjectMap();
	var addedThings = [];
	var map = part.changedVerticies;
	var _g_map = map;
	var _g_keys = map.keys();
	while(_g_keys.hasNext()) {
		var key = _g_keys.next();
		var _g1_value = _g_map.get(key);
		var _g1_key = key;
		var index = _g1_key;
		var pos = _g1_value;
		if(addedThings.indexOf(Std.string(pos)) == -1) {
			var indices = [];
			var prevInnerIndex = 0;
			var map = part.changedVerticies;
			var _g2_map = map;
			var _g2_keys = map.keys();
			while(_g2_keys.hasNext()) {
				var key1 = _g2_keys.next();
				var _g3_value = _g2_map.get(key1);
				var _g3_key = key1;
				var innerIndex = _g3_key;
				var innerPos = _g3_value;
				if(thinghandler_Triplet.eq(innerPos,pos)) {
					var relIndex = innerIndex - prevInnerIndex;
					indices.push(relIndex);
					prevInnerIndex = innerIndex;
				}
			}
			indicesByPosition.set(pos,indices);
			addedThings.push(Std.string(pos));
		}
	}
	var indLength = Lambda.count(indicesByPosition);
	buf.addInt32(indLength);
	var s = "";
	var map = indicesByPosition;
	var _g_map = map;
	var _g_keys = map.keys();
	while(_g_keys.hasNext()) {
		var key = _g_keys.next();
		var _g = { value : _g_map.get(key), key : key};
		var key1 = _g.key;
		var value = _g.value;
		thinghandler_BytesBufferTools.addFloatTriplet(buf,key1);
		thinghandler_BytesBufferTools.addIntArray(buf,value);
		if(s != "") {
			s += ",";
		}
		s += "[" + thinghandler_Triplet.asJsonArrayNoBrackets(key1) + "," + Std.string(value) + "]";
	}
	if(indLength > 0) {
		s = "\"c\":[" + s + "]";
		if(part.smoothingAngle != null) {
			s += part.smoothingAngle == null ? "null" : "" + part.smoothingAngle;
		}
		s += "_";
		if(part.convex != null) {
			s += part.convex == true ? "1" : "0";
		}
		if(Object.prototype.hasOwnProperty.call(changedVertsIndexRef.h,s)) {
			var exIndex = changedVertsIndexRef.h[s];
			buf.addInt32(exIndex);
			part.smoothingAngle = null;
			part.convex = null;
		} else {
			changedVertsIndexRef.h[s] = indexWithinThing;
		}
	}
};
thinghandler_ThingHandler.writeStateBytes = function(buf,part) {
	buf.addByte(part.states.length);
	var _g = 0;
	var _g1 = part.states;
	while(_g < _g1.length) {
		var state = _g1[_g];
		++_g;
		thinghandler_BytesBufferTools.addFloatTriplet(buf,state.position);
		thinghandler_BytesBufferTools.addFloatTriplet(buf,state.rotation);
		thinghandler_BytesBufferTools.addFloatTriplet(buf,state.scale);
		thinghandler_BytesBufferTools.addFloatTriplet(buf,state.color);
		thinghandler_ThingHandler.writeStringArray(buf,state.scriptLines);
		if(part.textureTypes[0] != 0) {
			thinghandler_ThingHandler.writeStateTextureBytes(buf,part,state,0);
		}
		if(part.textureTypes[1] != 0) {
			thinghandler_ThingHandler.writeStateTextureBytes(buf,part,state,1);
		}
		if(part.particleSystem != 0) {
			thinghandler_ThingHandler.writeStateParticleBytes(buf,part,state);
		}
	}
};
thinghandler_ThingHandler.writeStateTextureBytes = function(buf,part,state,index) {
	thinghandler_BytesBufferTools.addFloatTriplet(buf,state.textureColors[index]);
	var withOnlyAlphaSetting = thinghandler_ThingHandler.textureTypeWithOnlyAlphaSetting.indexOf(part.textureTypes[index]) != -1;
	if(withOnlyAlphaSetting) {
		buf.addByte(1);
		buf.addByte(2);
		buf.addFloat(state.textureProperties[index].h[2]);
	} else {
		buf.addByte(10);
		buf.addByte(0);
		buf.addFloat(state.textureProperties[index].h[0]);
		buf.addByte(1);
		buf.addFloat(state.textureProperties[index].h[1]);
		buf.addByte(2);
		buf.addFloat(state.textureProperties[index].h[2]);
		buf.addByte(3);
		buf.addFloat(state.textureProperties[index].h[3]);
		buf.addByte(4);
		buf.addFloat(state.textureProperties[index].h[4]);
		buf.addByte(5);
		buf.addFloat(state.textureProperties[index].h[5]);
		buf.addByte(6);
		buf.addFloat(state.textureProperties[index].h[6]);
		buf.addByte(7);
		buf.addFloat(state.textureProperties[index].h[7]);
		buf.addByte(8);
		buf.addFloat(state.textureProperties[index].h[8]);
		buf.addByte(9);
		buf.addFloat(state.textureProperties[index].h[9]);
	}
};
thinghandler_ThingHandler.writeStateParticleBytes = function(buf,part,state) {
	thinghandler_BytesBufferTools.addFloatTriplet(buf,state.particleSystemColor);
	var withOnlyAlphaSetting = thinghandler_ThingHandler.particleSystemWithOnlyAlphaSetting.indexOf(part.particleSystem) != -1;
	if(withOnlyAlphaSetting) {
		buf.addByte(1);
		buf.addByte(1);
		buf.addFloat(state.particleSystemProperty.h[1]);
	} else {
		buf.addByte(6);
		buf.addByte(0);
		buf.addFloat(state.particleSystemProperty.h[0]);
		buf.addByte(1);
		buf.addFloat(state.particleSystemProperty.h[1]);
		buf.addByte(2);
		buf.addFloat(state.particleSystemProperty.h[2]);
		buf.addByte(3);
		buf.addFloat(state.particleSystemProperty.h[3]);
		buf.addByte(4);
		buf.addFloat(state.particleSystemProperty.h[4]);
		buf.addByte(5);
		buf.addFloat(state.particleSystemProperty.h[5]);
	}
};
thinghandler_ThingHandler.getAttributes = function(thing) {
	var lowerBits = 0;
	var higherBits = 0;
	if(thing.isClonable) {
		lowerBits |= 1;
	}
	if(thing.isHoldable) {
		lowerBits |= 2;
	}
	if(thing.remainsHeld) {
		lowerBits |= 4;
	}
	if(thing.isClimbable) {
		lowerBits |= 8;
	}
	if(thing.isPassable) {
		lowerBits |= 16;
	}
	if(thing.isUnwalkable) {
		lowerBits |= 32;
	}
	if(thing.doSnapAngles) {
		lowerBits |= 64;
	}
	if(thing.isBouncy) {
		lowerBits |= 256;
	}
	if(thing.doShowDirection) {
		lowerBits |= 1024;
	}
	if(thing.keepPreciseCollider) {
		lowerBits |= 2048;
	}
	if(thing.doesFloat) {
		lowerBits |= 4096;
	}
	if(thing.doesShatter) {
		lowerBits |= 8192;
	}
	if(thing.isSticky) {
		lowerBits |= 16384;
	}
	if(thing.isSlidey) {
		lowerBits |= 32768;
	}
	if(thing.doSnapPosition) {
		lowerBits |= 65536;
	}
	if(thing.amplifySpeech) {
		lowerBits |= 131072;
	}
	if(thing.showAtDistance) {
		lowerBits |= 262144;
	}
	if(thing.scaleAllParts) {
		lowerBits |= 524288;
	}
	if(thing.softSnapAngles) {
		lowerBits |= 1048576;
	}
	if(thing.alwaysMergeParts) {
		lowerBits |= 2097152;
	}
	if(thing.addBodyWhenWorn) {
		lowerBits |= 4194304;
	}
	if(thing.hasSurrondSound) {
		lowerBits |= 8388608;
	}
	if(thing.canGetEventsWhenStateChanging) {
		lowerBits |= 16777216;
	}
	if(thing.replacesHandsWhenAttached) {
		lowerBits |= 33554432;
	}
	if(thing.mergeParticleSystems) {
		lowerBits |= 67108864;
	}
	if(thing.isSittable) {
		lowerBits |= 134217728;
	}
	if(thing.finetuneParts) {
		lowerBits |= 268435456;
	}
	if(thing.scaleUniformally) {
		lowerBits |= 536870912;
	}
	if(thing.snapAllPartsToGrid) {
		lowerBits |= 1073741824;
	}
	if(thing.invisibleWhenWorn) {
		lowerBits |= -2147483648;
	}
	if(thing.replaceInstInArea) {
		higherBits |= 1;
	}
	if(thing.addBodyWhenWornNonClearing) {
		higherBits |= 2;
	}
	if(thing.dontCastShadow) {
		higherBits |= 4;
	}
	if(thing.dontRecieveShadow) {
		higherBits |= 8;
	}
	if(thing.omitAutoSounds) {
		higherBits |= 16;
	}
	if(thing.omitAutoHapticFeedback) {
		higherBits |= 32;
	}
	if(thing.keepSizeInInventory) {
		higherBits |= 64;
	}
	if(thing.reflectSideways) {
		higherBits |= 128;
	}
	if(thing.reflectVertical) {
		higherBits |= 256;
	}
	if(thing.reflectDepth) {
		higherBits |= 512;
	}
	if(thing.activeInInventory) {
		higherBits |= 1024;
	}
	if(thing.stricterPhysicsSyncing) {
		higherBits |= 2048;
	}
	if(thing.removeOriginalWhenGrabbed) {
		higherBits |= 4096;
	}
	if(thing.persistWhenThrownOrEmitted) {
		higherBits |= 8192;
	}
	if(thing.invisible) {
		higherBits |= 16384;
	}
	if(thing.uncollidable) {
		higherBits |= 32768;
	}
	if(thing.movableByEveryone) {
		higherBits |= 65536;
	}
	if(thing.isNeverClonable) {
		higherBits |= 131072;
	}
	if(thing.floatsOnLiquid) {
		higherBits |= 262144;
	}
	if(thing.invisibleToDesktopCamera) {
		higherBits |= 524288;
	}
	if(thing.personalExperience) {
		higherBits |= 1048576;
	}
	var this1 = new haxe__$Int64__$_$_$Int64(higherBits,lowerBits);
	return this1;
};
thinghandler_ThingHandler.getPartAttributes = function(part) {
	var higherBits = 0;
	var lowerBits = 0;
	if(part.offersScreen) {
		lowerBits |= 1;
	}
	if(part.isVideoButton) {
		lowerBits |= 2;
	}
	if(part.scalesUniformally) {
		lowerBits |= 4;
	}
	if(part.screenSurrondSound) {
		lowerBits |= 8;
	}
	if(part.isLiquid) {
		lowerBits |= 16;
	}
	if(part.offersSlideshow) {
		lowerBits |= 32;
	}
	if(part.isSlideshowButton) {
		lowerBits |= 64;
	}
	if(part.isCamera) {
		lowerBits |= 128;
	}
	if(part.isCameraButton) {
		lowerBits |= 256;
	}
	if(part.isFisheyeCamera) {
		lowerBits |= 512;
	}
	if(part.useUnsoftenedAnim) {
		lowerBits |= 1024;
	}
	if(part.partInvisible) {
		lowerBits |= 2048;
	}
	if(part.isCenter) {
		lowerBits |= 4096;
	}
	if(part.omitAutoSoundsPart) {
		lowerBits |= 8192;
	}
	if(part.doTextureSnapAngles) {
		lowerBits |= 16384;
	}
	if(part.textureScalesUniformally) {
		lowerBits |= 32768;
	}
	if(part.textAlignCenter) {
		lowerBits |= 262144;
	}
	if(part.textAlignRight) {
		lowerBits |= 524288;
	}
	if(part.isAngleLocker) {
		lowerBits |= 1048576;
	}
	if(part.isPositionLocker) {
		lowerBits |= 2097152;
	}
	if(part.isLocked) {
		lowerBits |= 4194304;
	}
	if(part.avoidRecieveShadow) {
		lowerBits |= 8388608;
	}
	if(part.isImagePasteScreen) {
		lowerBits |= 16777216;
	}
	if(part.allowBlackImageBackgrounds) {
		lowerBits |= 33554432;
	}
	if(part.videoScreenLoops) {
		lowerBits |= 67108864;
	}
	if(part.videoScreenIsDirectlyOnMesh) {
		lowerBits |= 134217728;
	}
	if(part.useTextureAsSky) {
		lowerBits |= 268435456;
	}
	if(part.stretchSkydomeSeam) {
		lowerBits |= 536870912;
	}
	if(part.subthingFollowDelayed) {
		lowerBits |= 1073741824;
	}
	if(part.reflectPartSideways) {
		lowerBits |= -2147483648;
	}
	if(part.reflectPartDepth) {
		higherBits |= 2;
	}
	if(part.reflectPartVertical) {
		higherBits |= 1;
	}
	if(part.screenFlipsX) {
		higherBits |= 4;
	}
	if(part.persistStates) {
		higherBits |= 8;
	}
	if(part.partUncollidable) {
		higherBits |= 16;
	}
	if(part.isDedicatedCollider) {
		higherBits |= 32;
	}
	if(part.personalExperience) {
		higherBits |= 64;
	}
	if(part.partInvisbleWhenWorn) {
		higherBits |= 128;
	}
	if(part.lightOmitsShadow) {
		higherBits |= 256;
	}
	if(part.showDirectionalArrowsWhenEditing) {
		higherBits |= 512;
	}
	if(part.isText) {
		higherBits |= 1024;
	}
	var this1 = new haxe__$Int64__$_$_$Int64(higherBits,lowerBits);
	return this1;
};
var thinghandler_ThingPartAutocomplete = function() {
	this.scaleRandom = { x : 0, y : 0, z : 0};
	this.rotRandom = { x : 0, y : 0, z : 0};
	this.posRandom = { x : 0, y : 0, z : 0};
	this.waves = 0;
	this.count = 0;
};
thinghandler_ThingPartAutocomplete.__name__ = "thinghandler.ThingPartAutocomplete";
thinghandler_ThingPartAutocomplete.prototype = {
	writeBytes: function(buf) {
		if(this.fromPart == null || this.count > 0 || this.fromPart.guid == null || this.fromPart.guid == "") {
			buf.addInt32(0);
			return;
		}
		buf.addInt32(this.fromPart.guid.length);
		buf.addString(this.fromPart.guid);
		buf.addByte(this.count);
		buf.addByte(this.waves);
		buf.addFloat(this.posRandom.x);
		buf.addFloat(this.posRandom.y);
		buf.addFloat(this.posRandom.z);
		buf.addFloat(this.rotRandom.x);
		buf.addFloat(this.rotRandom.y);
		buf.addFloat(this.rotRandom.z);
		buf.addFloat(this.scaleRandom.x);
		buf.addFloat(this.scaleRandom.y);
		buf.addFloat(this.scaleRandom.z);
	}
	,fromJson: function(data) {
		this.fromPart = new thinghandler_ThingPart();
		this.fromPart.guid = data.id;
		this.waves = data.w != null ? data.w : 0;
		this.count = data.c;
		this.posRandom = data.rp;
		this.rotRandom = data.rr;
		this.scaleRandom = data.rs;
	}
	,__class__: thinghandler_ThingPartAutocomplete
};
function $getIterator(o) { if( o instanceof Array ) return new haxe_iterators_ArrayIterator(o); else return o.iterator(); }
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $global.$haxeUID++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = m.bind(o); o.hx__closures__[m.__id__] = f; } return f; }
$global.$haxeUID |= 0;
String.prototype.__class__ = String;
String.__name__ = "String";
Array.__name__ = "Array";
haxe_ds_ObjectMap.count = 0;
js_Boot.__toStr = ({ }).toString;
thinghandler_Thing.defaultName = "thing";
thinghandler_Thing.currentVersion = 5;
thinghandler_ThingPart.smoothingAngles = (function($this) {
	var $r;
	var _g = new haxe_ds_IntMap();
	_g.h[74] = 80;
	_g.h[75] = 80;
	_g.h[76] = 80;
	_g.h[77] = 80;
	_g.h[78] = 80;
	_g.h[79] = 80;
	_g.h[86] = 140;
	_g.h[80] = 50;
	_g.h[84] = 80;
	_g.h[82] = 80;
	_g.h[72] = 10;
	_g.h[88] = 140;
	_g.h[83] = 80;
	_g.h[64] = 80;
	_g.h[70] = 10;
	_g.h[71] = 10;
	_g.h[81] = 50;
	_g.h[85] = 80;
	_g.h[89] = 140;
	_g.h[65] = 80;
	_g.h[26] = 80;
	_g.h[27] = 80;
	_g.h[28] = 80;
	_g.h[29] = 80;
	_g.h[30] = 80;
	_g.h[31] = 80;
	_g.h[66] = 60;
	_g.h[54] = 180;
	_g.h[55] = 180;
	_g.h[56] = 180;
	_g.h[57] = 180;
	_g.h[58] = 180;
	_g.h[59] = 180;
	_g.h[67] = 80;
	_g.h[32] = 180;
	_g.h[33] = 180;
	_g.h[34] = 180;
	_g.h[35] = 180;
	_g.h[36] = 180;
	_g.h[37] = 180;
	_g.h[46] = 180;
	_g.h[47] = 180;
	_g.h[48] = 180;
	_g.h[49] = 180;
	_g.h[50] = 180;
	_g.h[51] = 180;
	_g.h[87] = 80;
	_g.h[166] = 120;
	_g.h[180] = 140;
	_g.h[163] = 120;
	_g.h[164] = 120;
	_g.h[165] = 60;
	_g.h[16] = 60;
	_g.h[159] = 120;
	_g.h[155] = 120;
	_g.h[150] = 120;
	_g.h[157] = 90;
	_g.h[151] = 120;
	_g.h[153] = 120;
	_g.h[200] = 80;
	_g.h[201] = 80;
	_g.h[202] = 80;
	_g.h[144] = 20;
	_g.h[145] = 20;
	_g.h[146] = 15;
	_g.h[147] = 60;
	_g.h[167] = 120;
	_g.h[168] = 60;
	_g.h[169] = 10;
	_g.h[176] = 25;
	_g.h[178] = 30;
	_g.h[173] = 15;
	_g.h[174] = 90;
	_g.h[175] = 160;
	_g.h[170] = 15;
	_g.h[171] = 30;
	_g.h[172] = 120;
	_g.h[181] = 60;
	_g.h[182] = 80;
	_g.h[183] = 80;
	_g.h[195] = 35;
	_g.h[196] = 80;
	_g.h[197] = 80;
	_g.h[189] = 80;
	_g.h[193] = 80;
	_g.h[194] = 80;
	_g.h[191] = 80;
	_g.h[184] = 80;
	_g.h[185] = 80;
	_g.h[186] = 80;
	_g.h[190] = 80;
	_g.h[198] = 80;
	_g.h[203] = 60;
	_g.h[204] = 60;
	_g.h[3] = 60;
	$r = _g;
	return $r;
}(this));
thinghandler_ThingHandler.textureTypeWithOnlyAlphaSetting = [10,167,168];
thinghandler_ThingHandler.particleSystemWithOnlyAlphaSetting = [13,8,7,30,16,26,27,32,36,46,50,51,53,55];
Main_main();
})(typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this);
