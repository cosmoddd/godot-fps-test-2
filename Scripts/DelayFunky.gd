extends MeshInstance


func _ready():
	get_tree().get_nodes_in_group("raycast")[0].connect("clicked", self,"_onClicked")
	pass # Replace with function body.

func _onClicked():
	print_debug("Start this...")
	yield(get_tree().create_timer(3),"timeout")
	print_debug("and NOW NOW NOW")
