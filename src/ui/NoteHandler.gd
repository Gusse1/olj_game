extends ColorRect

var player: Player

var note_active: bool
var note_active_name: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_root().get_node("Node3D/Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("enter") and note_active:
		get_node(note_active_name).visible = false
		visible = false

func activate_note(note_name: String) -> void:
	visible = true
	get_node(note_name).visible = true
	note_active = true
	note_active_name = note_name