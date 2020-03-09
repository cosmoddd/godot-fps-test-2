extends Spatial


export(NodePath) var nodeA
export(NodePath) var nodeB
export(float) var speed = 2
var a
var b
var targetWaypoint

# Called when the node enters the scene tree for the first time.
func _ready():
	a = get_node(nodeA)
	b = get_node(nodeB)
	targetWaypoint = a
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = ((translation - targetWaypoint.translation).normalized())
	translation = (translation - direction * delta * speed)
	
	if (translation.distance_to(b.translation) < .25):
		targetWaypoint = a
		
	if (translation.distance_to(a.translation) < .25):
		targetWaypoint = b
