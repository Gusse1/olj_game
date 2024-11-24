class_name Stride extends PlayerState

## Variable for storing the state prior to striding
var init_state: int
var last_stride: int = -1 # Cycle between strides -1 = Idle, 0 = Left, 1 = Right

var stride_max_speed: float = 17
var stride_accumulation: float = 5.3
var stride_decay: float = 1
var stride_speed: float = 0
var brake_strength: float = 16

# Jump stride
var stride_jump_height: float = 7

# Perfect stride
var stride_perfect_max_speed: float = 23
var is_stride_perfect: bool
var stride_perfect_accumulation: float = 6.7

var stride_cooldown_max: float = 1.5
var stride_cooldown: float = 0

var stride_growth_exponent: float = 1.33
var stride_decay_exponent: float = 0.9

@onready var audio_manager: Node = $"../../AudioManager"

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@export var stride_ui_element: CenterContainer
@export var stride_ui_indicator: RichTextLabel

signal striding(stride_speed: float, stride_max_speed: float)
signal stride_on_cooldown()
signal stride_off_cooldown()

var is_jumped: bool

func enter(msg := {}) -> void:
	is_jumped = false

func handle_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("jump"):
		if not is_jumped:
			print_debug("Stride jump")
			stride_speed += pow(stride_accumulation, stride_growth_exponent) * 0.2
			player.velocity.y = stride_jump_height
			is_jumped = true


func stride_action() -> void:
	stride_ui_element.stride_correct()
	audio_manager.play_audio("FeetAudio")
	if stride_cooldown > -0.16:
		audio_manager.play_audio("PerfectStrideAudio")
		stride_ui_indicator.give_feedback("[center]PERFECT[/center]")
		print_debug("perfect", stride_cooldown)
		is_stride_perfect = true
		stride_speed += pow(stride_perfect_accumulation, stride_growth_exponent)
	else:
		stride_ui_indicator.give_feedback("[center]LATE[/center]")
		is_stride_perfect = false
		stride_speed += pow(stride_accumulation, stride_growth_exponent)
	stride_cooldown = stride_cooldown_max
		
func stride_early() -> void:
	audio_manager.play_audio("EarlyStrideAudio")
	stride_ui_element.stride_early()
	stride_ui_indicator.give_feedback("[center]EARLY[/center]")
	stride_cooldown = stride_cooldown_max

func physics_update(_delta: float) -> void:
	if stride_cooldown > 0:
		stride_cooldown -= _delta
		stride_on_cooldown.emit()
	else:
		stride_off_cooldown.emit()

	stride_cooldown -= _delta
	var scale_factor: float = 1.0 + (stride_cooldown * 1.5)
	stride_ui_element.scale = Vector2(2, 2) * scale_factor
	if stride_ui_element.scale.x <= 1.35:
		stride_ui_element.scale = Vector2(1.35, 1.35)
		
	if Input.is_action_just_pressed("stride_left"):
		if stride_cooldown <= 0:
			if last_stride != 0:
				animation_player.play("stride_left")
				stride_action()
				last_stride = 0
		else:
			stride_early()
	if Input.is_action_just_pressed("stride_right"):
		if stride_cooldown <= 0:
			if last_stride != 1:
				animation_player.play("stride_right")
				stride_action()
				last_stride = 1
		else:
			stride_early()
	if Input.is_action_pressed("brake"):
		stride_speed -= brake_strength*_delta
		
	stride_speed -= pow(stride_decay*_delta, stride_decay_exponent)

	if stride_speed < 0:
		stride_speed = 0
	
	if is_stride_perfect:
		if stride_speed > stride_perfect_max_speed:
			stride_speed = stride_perfect_max_speed
		striding.emit(stride_speed, stride_perfect_max_speed)
	else:
		if stride_speed > stride_max_speed:
			stride_speed = stride_max_speed
		striding.emit(stride_speed, stride_max_speed)


		
	var direction := (player.transform.basis * Vector3.FORWARD).normalized()

	player.velocity.x = direction.x * stride_speed + (direction.normalized().x)
	player.velocity.z = direction.z * stride_speed + (direction.normalized().z)
	
	# Player hit wall 
	if player.is_on_wall() && stride_speed > 0.5 && player.velocity.y >= 0:
		audio_manager.play_audio("CrashAudio")
		last_stride = -1
		stride_speed = 0
		stride_cooldown = 0
		is_stride_perfect = false
		stride_ui_element.scale = Vector2(1.35, 1.35)
		stride_off_cooldown.emit()
		state_machine.transition_to(state_machine.movement_state[state_machine.IDLE])
		
	if player.velocity.y < 0:
		last_stride = -1
		state_machine.transition_to(
			state_machine.movement_state[state_machine.FALL],
			{ state_machine.TO : state_machine.STRIDE }
		)

	if stride_speed < 0.5:
		last_stride = -1
		stride_cooldown = 0
		is_stride_perfect = false
		stride_ui_element.scale = Vector2(1.35, 1.35)
		stride_off_cooldown.emit()
		state_machine.transition_to(state_machine.movement_state[state_machine.IDLE])
