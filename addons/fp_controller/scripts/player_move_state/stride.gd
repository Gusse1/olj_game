class_name Stride extends PlayerState

## Variable for storing the state prior to striding
var init_state: int
var last_stride: int # Cycle between strides

var stride_max_speed: float = 15
var stride_accumulation: float = 6.69
var stride_decay: float = 4
var stride_speed: float = 0
var brake_strength: float = 6.9

func enter(msg := {}) -> void:
	pass


func handle_input(_event: InputEvent) -> void:
	pass
	
	
func physics_update(_delta: float) -> void:
	# TODO: Add exponent to make the lowering faster and raise more gradual
	if Input.is_action_just_pressed("stride_left"):
		print_debug("Stride Left")
		stride_speed += stride_accumulation
	if Input.is_action_just_pressed("stride_right"):
		print_debug("Stride Right")
		stride_speed += stride_accumulation
	if Input.is_action_pressed("brake"):
		stride_speed -= brake_strength*_delta
	
	stride_speed -= stride_decay*_delta
	
	if stride_speed < 0:
		stride_speed = 0
	elif stride_speed > stride_max_speed:
		stride_speed = stride_max_speed
		
	var direction := (player.transform.basis * Vector3.FORWARD).normalized()
	
	player.velocity.x = direction.x * stride_speed + (direction.normalized().x)
	player.velocity.z = direction.z * stride_speed + (direction.normalized().z)
	
	if player.velocity.y < 0:
		state_machine.transition_to(
			state_machine.movement_state[state_machine.FALL],
			{ state_machine.TO : state_machine.STRIDE }
		)
	if stride_speed < 0.5:
		state_machine.transition_to(state_machine.movement_state[state_machine.IDLE])
