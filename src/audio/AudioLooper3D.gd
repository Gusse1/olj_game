extends AudioStreamPlayer3D

var is_finished: bool

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if playing:
		await get_tree().create_timer(stream.get_length() + .1).timeout
		is_finished = true
	if is_finished:
		play(0.0)
		is_finished = false
