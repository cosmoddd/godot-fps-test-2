extends Camera

const ray_length = 100

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		var camera = self
		print(camera.name)
		var from = camera.project_ray_origin(event.position)
		var to = from + camera.project_ray_normal(event.position) * ray_length
		get_tree().call_group("units", "_dorkestra")
		var space_state = get_world().direct_space_state
		var result = space_state.intersect_ray(from,to,[self])             
		print(from)
		print(to)
		if (result):
			print("let's do this!")
			print(result.position)
			get_tree().call_group("units", "move_to", result.position)
			
		
