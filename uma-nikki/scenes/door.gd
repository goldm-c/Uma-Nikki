extends Node3D

@onready var _anim: AnimationPlayer = %AnimationPlayer
@onready var _doorcamera: Camera3D = %DoorCam
@onready var marker: Marker3D = %Marker3D

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Uma"):
		_doorcamera.make_current()
		#cosmos.show()
		_anim.play("open1")

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("Uma"):
		body.makeUmaCameraCurrent()
		#cosmos.hide()
		_anim.play("open1", -1, 1, true)
