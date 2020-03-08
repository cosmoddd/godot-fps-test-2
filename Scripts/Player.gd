extends KinematicBody
#Variables
var global = "root/global"

const GRAVITY = -62.8

var vel = Vector3()
export var MAX_SLOPE_ANGLE = 45
export var MAX_SPEED = 6
export var DEACCEL = 10
export var DEACCELFAST = 40

var DEACCELINIT
var velocity = Vector3()

var camera
var rotation_helper

var MOUSE_SENSITIVITY = 0.05
var buttonPressed
var inputDir = Vector3()
var testFloat = 0
var keypressed = false
var currentSpeed = 0

func _ready():
	camera = $rotation_helper/Camera
	rotation_helper = $rotation_helper
	DEACCELINIT = DEACCEL
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	
	if (keypressed):
		currentSpeed = lerp(currentSpeed, MAX_SPEED, delta*10)
	if (!keypressed):
		currentSpeed = lerp(currentSpeed, 0, delta*DEACCEL)
			
	if ($playerfeet.is_colliding()):
		var n = $playerfeet.get_collision_normal()
		var floor_angle = rad2deg(acos(n.dot(Vector3(0,1,0))))
		print(floor_angle)
		if (floor_angle > 20):
			DEACCEL = DEACCELFAST
		else:
			DEACCEL = DEACCELINIT
		
		
	
	velocity.y += GRAVITY * delta
	var desired_velocity = get_input(delta) * currentSpeed

	velocity.x = desired_velocity.x
	velocity.z = desired_velocity.z
	velocity = move_and_slide(velocity, Vector3.UP, true)
	


func get_input(delta):
	
#	var inputDir = Vector3()
	
	
#	testFloat = lerp(testFloat, 0, delta)
		
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

	if (!Input.is_action_pressed("movement_forward") and
		!Input.is_action_pressed("movement_backward") and
		!Input.is_action_pressed("movement_left") and
		!Input.is_action_pressed("movement_right")):
			keypressed = false
		
	print(keypressed)	
	inputDir = inputDir.normalized()
	return inputDir
	

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation_helper.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY))
		self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))
		var camera_rot = rotation_helper.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		rotation_helper.rotation_degrees = camera_rot
		
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
