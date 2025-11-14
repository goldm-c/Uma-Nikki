extends Node

@onready var map: Node3D = $Map
@onready var _2d_scene: Node2D

var current_3d_scene = "nexus"
var current_2d_scene

func change_map(new_map: String) -> void:
	if map.get_child_count() != 0:
		
		map.get_children()[0].queue_free()
	var new = load(new_map).instantiate()
	map.add_child(new)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("f3"):
		if current_3d_scene == "nexus":
			change_map("res://scenes/maize_domain.tscn")
			current_3d_scene = "maize"
		else:
			change_map("res://scenes/nexus.tscn")
			current_3d_scene = "nexus"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
#https://www.youtube.com/watch?v=32h8BR0FqdI
