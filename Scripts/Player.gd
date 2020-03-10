extends KinematicBody
#Variables

export var GRAVITY = -9.8*3
export var GRAVITYMAX = 100
var GRAVITY_INIT
export var MAX_SLOPE_ANGLE = 45
export var MAX_SPEED = 6
export var DEACCEL = 10
export var DEACCELFAST = 40
export var jumpSpeed = 4
export var gravityModifier = 2
var DEACCELINIT
var velocity = Vector3()

var camera
var rotation_helper

export var MOUSE_SENSITIVITY = 0.05
var buttonPressed
var inputDir = Vector3()
var testFloat = 0
var keypressed = false
var currentSpeed = 0
var onPlatform = false
var root
var jumping
var platformTranslation
var pTransPrev
var platformName
var floor_angle = 0.0

func _ready():
	camera = $rotation_helper/Camera
	rotation_helper = $rotation_helper
	DEACCELINIT = DEACCEL
	GRAVITY_INIT = GRAVITY
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	root = get_owner()
	print(root.name)

func _physics_process(delta):
		
	if (keypressed):
		currentSpeed = lerp(currentSpeed, MAX_SPEED, delta*10)
	if (!keypressed):
		currentSpeed = lerp(currentSpeed, 0, delta*DEACCEL)
		
	if (is_on_floor() and GRAVITY != GRAVITY_INIT) and jumping:
		print("back on floor, gravity set")
		jumping = false
		GRAVITY = GRAVITY_INIT
				
				
	if ($playerfeet.is_colliding()):
		var n = $playerfeet.get_collision_normal()
		floor_angle = rad2deg(acos(n.dot(Vector3(0,1,0))))
#		print(floor_angle)
		if (floor_angle > 20):
			DEACCEL = DEACCELFAST
		else:
			DEACCEL = DEACCELINIT	
		
		## PLATFORM PHYSICS
		## MOVING FROM REST TO PLATFORM
		if ($playerfeet.get_collider().get_parent().is_in_group("platform")) and !onPlatform and velocity.y <-.1:
			platformName = $playerfeet.get_collider().get_parent().name
			print("Landed on "+ platformName)
			jumping = false
			platformTranslation = $playerfeet.get_collider().get_parent().get_parent()
			get_parent().remove_child(self)
			$playerfeet.get_collider().get_parent().get_parent().add_child(self)
			translation = translation - platformTranslation.translation
			onPlatform = true
	
		## MOVING FROM PLATFORM TO PLATFORM
		if ($playerfeet.get_collider().get_parent().is_in_group("platform")) and platformName != $playerfeet.get_collider().get_parent().name:
			pTransPrev = platformTranslation
			platformName = $playerfeet.get_collider().get_parent().name
			platformTranslation = $playerfeet.get_collider().get_parent().get_parent()
			get_parent().remove_child(self)
			$playerfeet.get_collider().get_parent().get_parent().add_child(self)
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
		
		## MOVING FROM PLATFORM TO REST
		if (!$playerfeet.get_collider().get_parent().is_in_group("platform")) and onPlatform:
			print("walked off platform")
			get_parent().remove_child(self)
			root.add_child(self)
			translation = platformTranslation.translation + translation
			onPlatform = false
	
	## ACTUAL MOVEMENT

	velocity.y += GRAVITY * delta
	
	var desired_velocity = get_input(delta) * currentSpeed

	velocity.x = desired_velocity.x
	velocity.z = desired_velocity.z
	velocity = move_and_slide(velocity, Vector3.UP, true)

func get_input(delta):
	
	if Input.is_action_just_pressed("movement_jumpin") and is_on_floor():
		print("jumpin")
		jumping = true
		GRAVITY = -9.8 * gravityModifier
		velocity += Vector3(0,jumpSpeed,0)

	if Input.is_action_pressed("movement_forward"):
		inputDir += global_transform.basis.z
		keypressed = true
	if Input.is_action_pressed("movement_backward"):
		inputDir -= global_transform.basis.z
		keypressed = true
	if Input.is_action_pressed("movement_left"):
		inputDir += global_transform.basis.x
		keypressed = true
	if Input.is_action_pressed("movement_right"):
		inputDir -= global_transform.basis.x
		keypressed = true

	get_global_transform().basis

	if (!Input.is_action_pressed("movement_forward") and
		!Input.is_action_pressed("movement_backward") and
		!Input.is_action_pressed("movement_left") and
		!Input.is_action_pressed("movement_right")):
			
			keypressed = false

	inputDir = inputDir.normalized()
	return inputDir

			

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation_helper.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY))
		self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))
		var camera_rot = rotation_helper.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -40, 40)
		rotation_helper.rotation_degrees = camera_rot
		
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
