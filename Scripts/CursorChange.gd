extends TextureRect

export (Texture) var firstTexture
export (Texture) var pushTexture
export (Texture) var handStrageTexture

func _ready():
	get_tree().get_nodes_in_group("raycast")[0].connect("hoveringOverSomething", self,"_hovering")
	get_tree().get_nodes_in_group("raycast")[0].connect("notHovering", self,"_notHovering")
	pass # Replace with function body.

func _hovering(thing):
#		print_debug("we must decide what to do with "+thing.name)
		if thing.is_in_group("pushable"):
			$".".texture = pushTexture
			if thing.has_method("gorki"):
				thing.gorki()
		if thing.is_in_group("handable"):
			$".".texture = handStrageTexture
		
func _notHovering():
		$".".texture = firstTexture

