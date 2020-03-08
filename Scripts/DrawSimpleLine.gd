tool
extends ImmediateGeometry

export (float)var distance
export (Color) var thisColor

func _process(delta):
	self.clear()
	self.begin(PrimitiveMesh.PRIMITIVE_LINES)
	self.set_color(thisColor)
	self.add_vertex(self.transform.origin) 
	self.add_vertex(self.transform.origin + Vector3(0,0,distance))	
	self.end()
