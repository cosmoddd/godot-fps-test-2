extends Area


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Respawn_body_entered(body):
	print("ya fell!")
	body.transform = $"Respawn Node".transform
	pass # Replace with function body.
