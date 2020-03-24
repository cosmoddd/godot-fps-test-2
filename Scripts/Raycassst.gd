extends MeshInstance

export (NodePath) var rayCast
var ray
export (float, 0, .3) var rotationSpeed
# Called when the node enters the scene tree for the first time.
func _ready():
	ray = get_node(rayCast)
#	yummy = RayCast.new()
#	add_child(yummy)
#	yummy.translation = Vector3.ZERO
#	yummy.set_cast_to(Vector3(0,-3,0))
#	yummy.enabled = true;
#	print(yummy.translation)
#	get_tree().get_root().Get
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if (ray.is_colliding()):		
		rotate_object_local(Vector3(0,1,0), 1 * rotationSpeed * delta)
#		print("Casting away...")
#		trans
	pass
