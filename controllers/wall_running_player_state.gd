class_name WallRunningPlayerState extends PlayerMovementState

@export var SPEED : float = 8
@export var ACCELERATION : float = 0.1
@export var DECELARATION : float = 0.25
@export var FRICTION : float = -60

@onready var WALL_RUNNING_SHAPECAST : ShapeCast3D = %ShapeCastWall

func enter(previous_state):
	ANIMATION.pause()
	#ANIMATION.play("wall_slide")


func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED, ACCELERATION, DECELARATION)
	PLAYER.update_velocity()

	PLAYER.velocity.y = FRICTION * delta

	if PLAYER.is_on_wall() == false:
		ANIMATION.play("wall_slide_end")
		await get_tree().create_timer(1).timeout
		transition.emit("IdlePlayerState")

		
	if Input.is_action_just_pressed("jump") and PLAYER.is_on_wall():
		transition.emit("JumpingPlayerState")
