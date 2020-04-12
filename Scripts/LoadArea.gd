extends Area

#export (String)var sceneLocation
export(Resource) var sceneThang

var scene
var sceneNode
# Called when the node enters the scene tree for the first time.
func _ready():
	scene = load(sceneThang.get_path())
	pass # Replace with function body.


func _on_Area_body_entered(body):
	if (body.is_in_group("player")):
		print("Entered the scene with..." + body.name)
		sceneNode = scene.instance()
		add_child(sceneNode)
		pass # Replace with function body.


func _on_Area_body_exited(body):
	if (body.is_in_group("player")):
		sceneNode.queue_free()
		print("Exited the scene with..." + body.name)
		pass # Replace with function body.
	
