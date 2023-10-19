package area;

import bulby.BulbyMath;

typedef CDNThing = {
	id:String,
	def:String
}

typedef CDNPlacement = {
	Id:String,
	Tid:String,
	// The underlying thing is actually exactly the same
	P:Vector3,
	R:Vector3,
	S:Float,
	// what is A?
	A:Array<Int>
}

typedef CDNArea = {
	thingDefinitions:Array<CDNThing>
}

// There is so much  SHIT i don't fucking care about
typedef CDNAreaData = {
	placements:Array<CDNPlacement>
}
