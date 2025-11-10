extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func scene_transition(target: String) -> void:
	%AnimationPlayer.play("circle")
	yield(%AnimationPlayer, "animation_finished")
	#Main.change_map(destination)
	%AnimationPlayer.play_backwards("circle")
