extends CharacterBody3D

@export_group("Camera")
@export_range(0.0, 1.0) var mouse_sensitivity := 0.3

@export_group("Movement")
@export var running = 1.0
@export var move_speed = 6.0
@export var acceleration = 40.0
@export var rotation_speed := 10.0
@export var first_person := false

var _camera_input_direction := Vector2.ZERO
var _last_movement_direction := Vector3.BACK

@onready var _camera_pivot: Node3D = %CameraPivot
@onready var _camera: Camera3D = %UmaCamera
@onready var _camera_1p: Camera3D = %UmaFirstPersonCamera
@onready var _uma: Node3D = %uma
@onready var _anim: AnimationPlayer = %AnimationPlayer

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
	if event.is_action_pressed("space"):
		if running == 1.0: running = 2.5
		else: running = 1.0
		
	if event.is_action_pressed("camera_switch"):
		if first_person: 
			first_person = false
			_camera.make_current()
		else: 
			first_person = true
			_camera_1p.make_current()
		

func _unhandled_input(event: InputEvent) -> void: #Do not move camera when tabbed out.
	var is_camera_motion := (
		event is InputEventMouseMotion and
		Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	)
	if is_camera_motion:
		_camera_input_direction = event.screen_relative * mouse_sensitivity

func _physics_process(delta: float) -> void:
	_camera_pivot.rotation.x -= _camera_input_direction.y * delta
	_camera_pivot.rotation.x = clamp(_camera_pivot.rotation.x, -(PI/2)+0.05, 0) #Clamp vertical camera movement
	_camera_pivot.rotation.y -= _camera_input_direction.x * delta
	
	#_camera_1p.rotation.x -= _camera_input_direction.y * delta
	#_camera_1p.rotation.x = clamp(_camera_pivot.rotation.x, -(PI/2), 0) #Clamp vertical camera movement
	#_camera_1p.rotation.y -= _camera_input_direction.x * delta
	
	_camera_input_direction = Vector2.ZERO
	
	var raw_input := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var forward := _camera.global_basis.z
	var right := _camera.global_basis.x
	
	var move_direction := forward * raw_input.y + right * raw_input.x
	move_direction.y = 0.0
	move_direction = move_direction.normalized()

	velocity = velocity.move_toward(move_direction * move_speed * running, acceleration * delta)
	move_and_slide()
	#Horse rotation.
	if move_direction.length() > 0.2:
		_last_movement_direction = move_direction
	var target_angle := Vector3.BACK.signed_angle_to(_last_movement_direction, Vector3.UP)
	_uma.global_rotation.y = lerp_angle(_uma.rotation.y, target_angle, rotation_speed * delta)
	#Animation
	var ground_speed := velocity.length()
	if ground_speed > 0.0:
		_anim.play("walking", -1, running * 1.3)
	else:
		_anim.stop()
