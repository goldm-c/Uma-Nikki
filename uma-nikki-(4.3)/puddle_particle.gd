extends GPUParticles3D

var size_velocity = Vector3(3.0, 1.0, 3.0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	size_velocity = 3.0
	for i in range(0, 8):
		scale_object_local(size_velocity)
		size_velocity.x += size_velocity.x/2
		size_velocity.z += size_velocity.z/2
