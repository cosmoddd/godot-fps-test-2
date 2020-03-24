extends RayCast

signal hoveringOverSomething(thing)
signal notHovering(thing)

var isHovering

# Called when the node enters the scene tree for the first time.
func _ready():
	isHovering = false
	pass # Replace with function body.

func _physics_process(delta):
	if !is_colliding() and isHovering:
			isHovering = false
			print_debug("You are no longer hovering w something")
			emit_signal("notHovering")
			pass
	if is_colliding() and !isHovering:
			emit_signal("hoveringOverSomething", get_collider().get_parent())
			isHovering = true
	if isHovering:
			pass


func _input(event):
	if event.is_action_pressed("mouseClick") && isHovering:
		print_debug("I CLIKCD ON U SUCKA")
		if (get_collider().get_parent().has_method("_onClicked")):
			get_collider().get_parent()._onClicked()
			pass
	if event.is_action_released("mouseClick") && isHovering:
		if (get_collider().get_parent().has_method("_onClicked")):
			pass	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
