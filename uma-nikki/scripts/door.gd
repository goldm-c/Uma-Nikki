extends Node3D

@onready var _anim: AnimationPlayer = %AnimationPlayer
@onready var _doorcamera1: Camera3D = %DoorCam1
@onready var _doorcamera2: Camera3D = %DoorCam2
var is_in_door1_area = false
var is_in_door2_area = false
var destination = "res://scenes/maize_domain.tscn"
#Cameras are weird. Coming from the other side it appears like the player's controls are inversed
func _on_area1_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Uma"):
		is_in_door1_area = true
		_anim.play("open1")

func _on_area1_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("Uma"):
		#body.makeUmaCameraCurrent()
		is_in_door1_area = false
		_anim.play_backwards("open1")

func _on_area2_body_entered(body: Node3D) -> void:
	if body.is_in_group("Uma"):
		#_doorcamera2.make_current()
		is_in_door2_area = true
		_anim.play("open2")

func _on_area2_body_exited(body: Node3D) -> void:
	if body.is_in_group("Uma"):
		#body.makeUmaCameraCurrent()
		is_in_door2_area = false
		_anim.play_backwards("open2")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("z") and is_in_door1_area:
		_doorcamera1.make_current()
		#Main.change_map(destination)
