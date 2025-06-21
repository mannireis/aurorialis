class_name SprintingPlayerState 

extends PlayerMovementState

@export var SPEED : float = 7
@export var ACCELERATION : float = 0.1
@export var DECELARATION : float = 0.25
@export var TOP_ANIM_SPEED : float = 1.6

func exit():
	ANIMATION.speed_scale = 1.0

func enter(previous_state) -> void:
	ANIMATION.play("walking",0.5,1.0)
	PLAYER._speed = Global.player.SPEED_SPRINTING

func update(delta):
	PLAYER.update_gravity(delta)
	PLAYER.update_input(SPEED, ACCELERATION, DECELARATION)
	PLAYER.update_velocity()
	
	set_animation_speed(PLAYER.velocity.length())
	
	if Input.is_action_just_released("sprint"):
		transition.emit("WalkingPlayerState")
		
	if Input.is_action_just_pressed("crouch") and  PLAYER.velocity.length() > 6:
		transition.emit("SlidingPlayerState")

func set_animation_speed(spd) -> void:
	var alpha = remap(spd, 0.0, SPEED, 0.0, 1.0)
	ANIMATION.speed_scale = lerp(0.0, TOP_ANIM_SPEED, alpha)
