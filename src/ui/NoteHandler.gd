extends ColorRect

var player: Player
var state_machine: Node

var note_active: bool = false
var note_active_name: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_root().get_node("Node3D/Player")
	state_machine = player.get_node("StateMachine")
	print_debug(player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("enter") and note_active:
		get_node(note_active_name).visible = false
		player.can_move = true
		visible = false

func activate_note(note_name: String) -> void:
	player.can_move = false
	state_machine.transition_to(state_machine.movement_state[state_machine.IDLE])
	visible = true
	get_node(note_name).visible = true
	note_active = true
	note_active_name = note_name