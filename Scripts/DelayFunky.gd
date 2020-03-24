extends MeshInstance

export var rotationSpeed = .025
var spinning = false

func _ready():
	get_tree().get_nodes_in_group("raycast")[0].connect("clicked", self,"_onClicked")
	get_tree().get_nodes_in_group("raycast")[0].connect("hoveringOverSomething", self,"_doASpin")
	get_tree().get_nodes_in_group("raycast")[0].connect("notHovering", self,"_stopSpinning")
	pass # Replace with function body.

func _doASpin(thing):
	spinning = true;
	print_debug("this is a " + thing.name)

func _stopSpinning():
	spinning = false;
	print_debug("stop spinning!")

func _process(delta):
	if (spinning == true):
		rotate(Vector3(0,1,0), 1 * rotationSpeed * delta)

func _onClicked():
	print_debug("Start this...")
	yield(get_tree().create_timer(3),"timeout")
	print_debug("and NOW NOW NOW")
