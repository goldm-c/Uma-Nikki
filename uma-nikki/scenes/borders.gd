extends Node3D

func _on_north_body_entered(body: Node3D) -> void:
	if body.is_in_group("Uma"):
		body.global_position.z = 57
		print("north")

func _on_east_body_entered(body: Node3D) -> void:
	if body.is_in_group("Uma"):
		body.global_position.x = -57
		print("east")

func _on_south_body_entered(body: Node3D) -> void:
	if body.is_in_group("Uma"):
		body.global_position.z = -57
		print("south")

func _on_west_body_entered(body: Node3D) -> void:
	if body.is_in_group("Uma"):
		body.global_position.x = 57
		print("west")
