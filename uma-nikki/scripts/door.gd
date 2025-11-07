extends Node3D

@onready var _anim: AnimationPlayer = %AnimationPlayer
@onready var _doorcamera1: Camera3D = %DoorCam1
@onready var _doorcamera2: Camera3D = %DoorCam2
#Cameras are weird. Coming from the other side it appears like the player's controls are inversed
func _on_area1_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Uma"):
		#_doorcamera1.make_current()
		#cosmos.show()
		_anim.play("open1")


func _on_area1_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("Uma"):
		#body.makeUmaCameraCurrent()
		#cosmos.hide()
		_anim.play_backwards("open1")


func _on_area2_body_entered(body: Node3D) -> void:
	if body.is_in_group("Uma"):
		#_doorcamera2.make_current()
		#cosmos.show()
		_anim.play("open2")


func _on_area2_body_exited(body: Node3D) -> void:
	if body.is_in_group("Uma"):
		#body.makeUmaCameraCurrent()
		#cosmos.hide()
		_anim.play_backwards("open2")
