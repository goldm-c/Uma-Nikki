extends CharacterBody3D

@export_group("Camera")
@export_range(0.0, 1.0) var mouse_sensitivity := 0.3

@export_group("Movement")
@export var running = 1.0
@export var move_speed = 6.0
@export var acceleration = 40.0
@export var rotation_speed := 10.0
@export var first_person := false
@export var jump_strength := 12.0

var _camera_input_direction := Vector2.ZERO
var _last_movement_direction := Vector3.BACK
var gravity := -30.0
var fall_anim_started = false

@onready var _camera_pivot: Node3D = %CameraPivot
@onready var _camera: Camera3D = %UmaCamera
@onready var _camera_1p: Camera3D = %UmaFirstPersonCamera
@onready var _uma: Node3D = %uma
@onready var _anim: AnimationPlayer = %AnimationPlayer

func makeUmaCameraCurrent():
	if first_person: 
		_camera_1p.make_current()
	else: 
		_camera.make_current()
		
func respawn():
	self.global_position = Vector3(0, 0, 0)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
	if event.is_action_pressed("f2"):
		respawn()
		
	if event.is_action_pressed("shift"):
		if running == 1.0: running = 2.5
		else: running = 1.0
		
	if event.is_action_pressed("camera_switch"):
		if first_person: 
			first_person = false
			makeUmaCameraCurrent()
		else: 
			first_person = true
			makeUmaCameraCurrent()

func _unhandled_input(event: InputEvent) -> void: #Do not move camera when tabbed out.
	var is_camera_motion := (
		event is InputEventMouseMotion and
		Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	)
	if is_camera_motion:
		_camera_input_direction = event.screen_relative * mouse_sensitivity
		
func _ready() -> void:
	pass

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
	
	#Store vertical velocity
	var y_velocity := velocity.y
	velocity.y = 0
	#Calculate horizontal velocity
	velocity = velocity.move_toward(move_direction * move_speed * running, acceleration * delta)
	#Calculate vertical velocity
	velocity.y = y_velocity + gravity * delta
	move_and_slide()
	
	var is_starting_jump := Input.is_action_just_pressed("space") and is_on_floor()
	if is_starting_jump:
		velocity.y += jump_strength
	
	#Horse rotation.
	var collision_angle = get_floor_normal() * move_direction

	if move_direction.length() > 0.2:
		_last_movement_direction = move_direction
	var target_angle := Vector3.BACK.signed_angle_to(_last_movement_direction, Vector3.UP)
	
	_uma.global_rotation.y = lerp_angle(_uma.rotation.y, target_angle, rotation_speed * delta)
	_uma.global_rotation.x = lerp_angle(_uma.global_rotation.x, collision_angle.x + collision_angle.z, rotation_speed * delta)
	#Animation
	var ground_speed := velocity.length()
	
	if is_starting_jump:
		_anim.play("jumping")
	elif not is_on_floor() and not fall_anim_started and velocity.y < 0:
		_anim.play("falling", -1, 0.7)
		fall_anim_started = true
	elif is_on_floor():
		fall_anim_started = false
		if ground_speed > 0.0:
			_anim.play("walking", -1, running * 1.3)
		else:
			_anim.play("uma_RESET")
