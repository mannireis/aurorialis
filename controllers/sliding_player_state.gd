class_name SlidingPlayerState  extends PlayerMovementState

@export var SPEED : float = 6
@export var ACCELERATION : float = 0.1
@export var DECELARATION : float = 0.25
@export var TILT_AMOUNT : float = 0.09
@export_range(1, 6, 0.1) var SLIDE_ANIM_SPEED : float = 7

@onready var CROUCH_SHAPECAST : ShapeCast3D = %ShapeCastTop

func enter(previous_state) -> void:
	set_tilt(PLAYER._current_rotation)
	ANIMATION.get_animation("sliding").track_set_key_value(4,0,PLAYER.velocity.length())
	ANIMATION.speed_scale = 1.0
	ANIMATION.play("sliding", -1.0, SLIDE_ANIM_SPEED)

func update(delta):
	PLAYER.update_gravity(delta)
	#PLAYER.update_input(SPEED,ACCELERATION,DECELARATION) #will see
	PLAYER.update_velocity()

func set_tilt(player_rotation) -> void:
	var tilt = Vector3.ZERO
	tilt.z = clamp(TILT_AMOUNT * player_rotation, -0.1, 0.1)
	if tilt.z ==  0.0:
		tilt.z = 0.05
	ANIMATION.get_animation("sliding").track_set_key_value(8,1,tilt)
	ANIMATION.get_animation("sliding").track_set_key_value(8,2,tilt)
	

func finish():
	transition.emit("CrouchingPlayerState")
