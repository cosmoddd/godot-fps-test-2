extends KinematicBody

###################-VARIABLES-####################

# Camera
export var mouse_sensitivity := 10.0
export var head_path: NodePath
export var cam_path: NodePath
export var FOV := 80.0
var mouse_axis := Vector2()
onready var head: Spatial = get_node(head_path)
onready var cam: Camera = get_node(cam_path)
# Move
var velocity := Vector3()
var direction := Vector3()
var move_axis := Vector2()
var can_sprint := true
var sprinting := false
# Walk
const FLOOR_NORMAL := Vector3(0, 1, 0)
export var gravity := 30.0
export var walk_speed := 10
export var sprint_speed := 16
export var acceleration := 8
export var deacceleration := 10
export(float, 0.0, 1.0, 0.05) var air_control := 0.3
export var jump_height := 10
# Fly
export var fly_speed := 10
export var fly_accel := 4
var flying := false
# Slopes
export var floor_max_angle := 45.0
export(float) var currentFloorAngle
export(NodePath) var tweenerPath
var tweener
export(NodePath) var rayShapePath
var rayShape
# Platforms
var root
var onPlatform = false
var jumping = false
var platformName
var platformTranslation
var pTransPrev
var _snap_init:= Vector3(0,-1,0)
var _snap := Vector3(0,-1,0)
##################################################

# Called when the node enters the scene tree
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	cam.fov = FOV
	tweener = get_node(tweenerPath)
	rayShape = get_node(rayShapePath)
	root = get_owner()
	
# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(_delta: float) -> void:
	move_axis.x = Input.get_action_strength("movement_forward") - Input.get_action_strength("movement_backward")
	move_axis.y = Input.get_action_strength("movement_right") - Input.get_action_strength("movement_left")
		
	if (move_axis.x != 0 or move_axis.y != 0):
		$RayShapePrime.shape.set("slips_on_slope", true)
		$RayShape0.shape.set("slips_on_slope", true)
		$RayShape2.shape.set("slips_on_slope", true)
		$RayShape3.shape.set("slips_on_slope", true)
		$RayShape4.shape.set("slips_on_slope", true)
		
	if (!Input.is_action_pressed("movement_forward") and
		!Input.is_action_pressed("movement_backward") and
		!Input.is_action_pressed("movement_left") and
		!Input.is_action_pressed("movement_right")):
		
		$RayShapePrime.shape.set("slips_on_slope", false)
		$RayShape0.shape.set("slips_on_slope", false)
		$RayShape2.shape.set("slips_on_slope", false)
		$RayShape3.shape.set("slips_on_slope", false)
		$RayShape4.shape.set("slips_on_slope", false)
	_camera_rotation()


# Called every physics tick. 'delta' is constant
func _physics_process(delta: float) -> void:
	if flying:
		_fly(delta)
	else:
		_walk(delta)


# Called when there is an input event
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_axis = event.relative
	
	#	ESCAPE THE GAME
		
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _walk(delta: float) -> void:
	# Input
	direction = Vector3()
	var aim: Basis = get_global_transform().basis
	if move_axis.x >= 0.5:
		direction -= aim.z
	if move_axis.x <= -0.5:
		direction += aim.z
	if move_axis.y <= -0.5:
		direction -= aim.x
	if move_axis.y >= 0.5:
		direction += aim.x
	direction.y = 0
	direction = direction.normalized()
	
	# Jump

	if(is_on_floor()):
		_snap = Vector3(0,-1,0)
		if Input.is_action_just_pressed("movement_jumpin"):
			velocity.y = jump_height
			print("JUMP!")
			_snap = Vector3(0, 0, 0)
			
	
	if (!is_on_floor()):
#		print("IN THE AIR")
		jumping = true
		# velocity.y -= gravity * delta
	else:
		jumping = false
		# _snap = Vector3(0, -1, 0)
	
	
	# Apply Gravity
	# if (not is_on_floor()):
	velocity.y -= gravity * delta
	
	# Deal w Platform Physics
	_platform_physics()

	# Sprint
	var _speed: int
	if (Input.is_action_pressed("move_sprint") and can_sprint and move_axis.x == 1):
		_speed = sprint_speed
		cam.set_fov(lerp(cam.fov, FOV * 1.05, delta * 8))
		sprinting = true
	else:
		_speed = walk_speed
		cam.set_fov(lerp(cam.fov, FOV, delta * 8))
		sprinting = false
	
	# Acceleration and Deacceleration
	# where would the player go
	var _temp_vel: Vector3 = velocity
	_temp_vel.y = 0
	var _target = direction * _speed
	var _temp_accel: float
	if direction.dot(_temp_vel) > 0:
		_temp_accel = acceleration
	else:
		_temp_accel = deacceleration
	if not is_on_floor():
		_temp_accel *= air_control
	# interpolation
	_temp_vel = _temp_vel.linear_interpolate(_target, _temp_accel * delta)
	velocity.x = _temp_vel.x
	velocity.z = _temp_vel.z
	# clamping (to stop on slopes)
	if direction.dot(velocity) == 0:
		var _vel_clamp := 0.25
		if velocity.x < _vel_clamp and velocity.x > -_vel_clamp:
			velocity.x = 0
		if velocity.z < _vel_clamp and velocity.z > -_vel_clamp:
			velocity.z = 0
	
	_slope_helper()
		
	# Move
	velocity.y = move_and_slide_with_snap(velocity, _snap, FLOOR_NORMAL, 
	true, 4, deg2rad(floor_max_angle)).y
			
	pass

#maybe this will work one day
func _slope_helper():
	# # get floor angle
	print(rayShape.shape.length)
	var n = $playerfeet.get_collision_normal()
	currentFloorAngle = rad2deg(acos(n.dot(Vector3(0,1,0))))

	if (velocity.length()-.5 > 1) && (currentFloorAngle > 1):
		# print("On a slope and moving!!")
		# rayShape.get
		# tweener.interpolate_property(rayShape, "length", 1.6,2, .5, Tween.EASE_IN, Tween.EASE_OUT)
		tweener.start()
		pass
	if (currentFloorAngle <= 1):
		# tweener.interpolate_property(collision, "scale", Vector3(1,1,collision.scale.z),Vector3(1,1,1), .5, Tween.EASE_IN, Tween.EASE_OUT)
		tweener.start();
	pass

## DON'T USE FLY... WHY OH WHY?
func _fly(delta: float) -> void:
	# Input
	direction = Vector3()
	var aim = head.get_global_transform().basis
	if move_axis.x == 1:
		direction -= aim.z
	if move_axis.x == -1:
		direction += aim.z
	if move_axis.y == -1:
		direction -= aim.x
	if move_axis.y == 1:
		direction += aim.x
	direction = direction.normalized()
	
	# Acceleration and Deacceleration
	var target: Vector3 = direction * fly_speed
	velocity = velocity.linear_interpolate(target, fly_accel * delta)
	
	# Move
	velocity = move_and_slide(velocity)
##


func _camera_rotation() -> void:
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		return
	if mouse_axis.length() > 0:
		var _smoothness := 80
		# Get mouse delta
		var horizontal: float = -(mouse_axis.x * mouse_sensitivity) / _smoothness
		var vertical: float = -(mouse_axis.y * mouse_sensitivity) / _smoothness
		
		mouse_axis = Vector2()
		
		rotate_y(deg2rad(horizontal))
		head.rotate_x(deg2rad(vertical))
		
		# Clamp mouse rotation
		var temp_rot: Vector3 = head.rotation_degrees
		temp_rot.x = clamp(temp_rot.x, -90, 90)
		head.rotation_degrees = temp_rot

func _platform_physics():
	## PLATFORM PHYSICS
#	if (platformTranslation != null):
#		print(platformTranslation.name)
	
	if ($playerfeet.get_collider() == null):
		print("returning nothing")
		return
	
	## FALLING ON TO PLATFORM
	if ($playerfeet.get_collider().get_parent().is_in_group("platform")) \
			and !onPlatform and velocity.y <-.1:
		platformName = $playerfeet.get_collider().get_parent().name
		print("Landed on "+ platformName)
		jumping = false
		platformTranslation = $playerfeet.get_collider().get_parent().get_parent()
		get_parent().remove_child(self)
		$playerfeet.get_collider().get_parent().get_parent().add_child(self)
		translation = translation - platformTranslation.translation
		onPlatform = true

	## MOVING FROM PLATFORM TO PLATFORM
	if ($playerfeet.get_collider().get_parent().is_in_group("platform")) \
			and !jumping \
			and platformName != $playerfeet.get_collider().get_parent().name:
		pTransPrev = platformTranslation
		platformName = $playerfeet.get_collider().get_parent().name
		platformTranslation = $playerfeet.get_collider().get_parent().get_parent()
		get_parent().remove_child(self)
		$playerfeet.get_collider().get_parent().get_parent().add_child(self)
		## if there's no previous platform...
		if (pTransPrev == null):
			translation = translation - platformTranslation.translation		
			print("Moved from NO PLATFORM to "+platformTranslation.name)
		## but if there is...
		if (pTransPrev != null):
			translation = (pTransPrev.translation + translation) - platformTranslation.translation		
			print("Moved from "+pTransPrev.name+" to "+platformTranslation.name)
		onPlatform = true

	## JUMPING OFF PLATFORM
	if (jumping and velocity.y >.1 and onPlatform):
		print("JUMPED OFF platform")
		get_parent().remove_child(self)
		root.add_child(self)
		translation = platformTranslation.translation + translation
		onPlatform = false
#
	## MOVING FROM PLATFORM TO REGULAR COLLIDER
	if (!$playerfeet.get_collider().get_parent().is_in_group("platform")) and onPlatform:
		print("walked off platform")
		get_parent().remove_child(self)
		root.add_child(self)
		translation = platformTranslation.translation + translation
		platformTranslation = null
		onPlatform = false
