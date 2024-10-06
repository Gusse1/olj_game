class_name Stride extends PlayerState

## Variable for storing the state prior to striding
var init_state: int
var last_stride: int = -1 # Cycle between strides -1 = Idle, 0 = Left, 1 = Right

var stride_max_speed: float = 20
var stride_accumulation: float = 6.69
var stride_decay: float = 2
var stride_speed: float = 0
var brake_strength: float = 16
var stride_jump_height: float = 7

var stride_cooldown_max: float = 1.5
var stride_cooldown: float = 0

var stride_growth_exponent: float = 1.33
var stride_decay_exponent: float = 0.9

@onready var animation_player: AnimationPlayer = %AnimationPlayer

signal striding(stride_speed: float, stride_max_speed: float)
signal stride_on_cooldown()
signal stride_off_cooldown()

func enter(msg := {}) -> void:
	pass

func handle_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("jump"):
			print_debug("Stride jump")
			stride_speed += pow(stride_accumulation, stride_growth_exponent) * 0.2
			player.velocity.y = stride_jump_height


func physics_update(_delta: float) -> void:
	if stride_cooldown > 0:
		stride_cooldown -= _delta
		stride_on_cooldown.emit()
	else:
		stride_off_cooldown.emit()
	
	if not animation_player.is_playing():
		animation_player.play("stride")

	if Input.is_action_just_pressed("stride_left") && stride_cooldown <= 0:
		if last_stride != 0:
			animation_player.play("stride_left")
			stride_cooldown = stride_cooldown_max
			stride_speed += pow(stride_accumulation, stride_growth_exponent)
			last_stride = 0
	if Input.is_action_just_pressed("stride_right") && stride_cooldown <= 0:
		if last_stride != 1:
			animation_player.play("stride_right")
			stride_cooldown = stride_cooldown_max
			stride_speed += pow(stride_accumulation, stride_growth_exponent)
			last_stride = 1
	if Input.is_action_pressed("brake"):
		stride_speed -= brake_strength*_delta
		
	striding.emit(stride_speed, stride_max_speed)

	stride_speed -= pow(stride_decay*_delta, stride_decay_exponent)

	if stride_speed < 0:
		stride_speed = 0
	elif stride_speed > stride_max_speed:
		stride_speed = stride_max_speed
		
	var direction := (player.transform.basis * Vector3.FORWARD).normalized()

	player.velocity.x = direction.x * stride_speed + (direction.normalized().x)
	player.velocity.z = direction.z * stride_speed + (direction.normalized().z)

	# Player hit wall 
	# TODO: Add damage effect
	if player.is_on_wall() && stride_speed > 0.5 && player.velocity.y >= 0:
		last_stride = -1
		stride_speed = 0
		stride_cooldown = 0
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
		stride_off_cooldown.emit()
		state_machine.transition_to(state_machine.movement_state[state_machine.IDLE])
