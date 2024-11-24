extends ColorRect

var fade_out: bool

@onready var audio_manager: Node = $"../../AudioManager"
@onready var first_intro_text: RichTextLabel = $"FirstIntroText"
@onready var original_intro_text: RichTextLabel = $"OriginalIntroText"
@onready var terminal_intro_text: RichTextLabel = $"TerminalIntroText"

@export var is_first_intro: bool
@export var is_terminal_intro: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_first_intro:
		first_intro_text.visible = true
		original_intro_text.visible = false

	if audio_manager:
		audio_manager.play_audio("ComputerThinkingSound")
	
	if is_terminal_intro:
		await get_tree().create_timer(6.0).timeout
		fade_out = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if fade_out:
		modulate.a -= delta * 1
		if modulate.a <= 0:
			visible = false
			if audio_manager:
				audio_manager.stop_audio("ComputerThinkingSound")


func _on_shader_precompiler_all_shaders_compiled() -> void:
	await get_tree().create_timer(6.0).timeout
	fade_out = true
