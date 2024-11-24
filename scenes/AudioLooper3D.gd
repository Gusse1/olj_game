extends AudioStreamPlayer3D


var is_finished: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if playing:
		await get_tree().create_timer(stream.get_length() + .1).timeout
		is_finished = true
	if is_finished:
		play(0.0)
		is_finished = false
