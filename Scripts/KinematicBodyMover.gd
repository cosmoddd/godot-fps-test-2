extends KinematicBody

var path = []
var path_ind = 0
export var move_speed = 5

onready var nav = get_parent()

func _ready():
		add_to_group("units")


func _physics_process(delta):
	if path_ind < path.size():
		var move_vec =  (path[path_ind] - global_transform.origin)
		if move_vec.length() < 0.1:
			path_ind += 1
		else:
				move_and_slide(move_vec.normalized() * move_speed, Vector3(0,1,0))

func move_to(target_pos):
	path = nav.get_simple_path(global_transform.origin, target_pos)
	path_ind = 0
	
func _dorkestra():
	print("The "+ self.name + " is in the dorkestra.")
