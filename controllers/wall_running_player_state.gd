class_name WallRunningPlayerState extends PlayerMovementState

@export var SPEED : float = 6
@export var ACCELERATION : float = 0.1
@export var DECELARATION : float = 0.25

@onready var WALL_RUNNING_SHAPECAST_LEFT : ShapeCast3D = %ShapeCastLeft
@onready var WALL_RUNNING_SHAPECAST_RIGHT : ShapeCast3D = %ShapeCastRight
