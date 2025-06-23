class_name JumpingPlayerState extends PlayerMovementState

@export var SPEED : float = 6
@export var ACCELERATION : float = 0.1
@export var DECELARATION : float = 0.25
@export var JUMP_STRENGTH : float = 5
@export_range(0.5,1.0,0.01) var INPUT_MULTIPLIER : float = 0.85

func enter(previous_state):
	PLAYER.velocity.y += JUMP_STRENGTH
	ANIMATION.play("jump_start")

func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED * INPUT_MULTIPLIER,ACCELERATION,DECELARATION)
	PLAYER.update_velocity()

	if Input.is_action_just_released("jump"):
		if PLAYER.velocity.y > 0:
			PLAYER.velocity.y = PLAYER.velocity.y / 2.0

	if PLAYER.is_on_floor():
		ANIMATION.play("jump_end")
		transition.emit("IdlePlayerState")
