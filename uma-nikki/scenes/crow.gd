extends Node3D

@onready var crow_standing : Sprite3D = %crow_standing
@onready var crow_flying : Sprite3D = %crow_flying
@onready var crow_sound : AudioStreamPlayer3D = %crow_sound

func _ready() -> void:
	crow_standing.visible = true
	crow_flying.visible = false
	while 1 == 1:
		await get_tree().create_timer(randf_range(1.0, 7.0)).timeout
		crow_sound.play()
