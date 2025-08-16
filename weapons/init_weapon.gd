@tool

extends Node3D

@export var WEAPON_TYPE : Weapons:
	set(value):
		WEAPON_TYPE = value
		if Engine.is_editor_hint():
			load_weapon()

@onready var weapon_mesh : MeshInstance3D = %WeaponMesh
@onready var weapon_mesh_2 : MeshInstance3D = %WeaponMesh2
#@onready var weapon_shadow : MeshInstance3D = %WeaponShadow

var mouse_movement : Vector2

func _ready() -> void:
	load_weapon()

func  _input(event: InputEvent) -> void:
	if event.is_action_pressed("weapon1"):
		WEAPON_TYPE = load("res://weapons/sword/sword_resource.tres")
		load_weapon()
	if event.is_action_pressed("weapon2"):
		WEAPON_TYPE = load("res://weapons/gun1/gun1_resource.tres")
		load_weapon()
	if event is InputEventMouseMotion:
		mouse_movement = event.relative

func load_weapon() -> void:
	weapon_mesh.mesh = WEAPON_TYPE.mesh
	weapon_mesh_2.mesh = WEAPON_TYPE.mesh2
	position = WEAPON_TYPE.position
	rotation_degrees = WEAPON_TYPE.rotation
	scale = WEAPON_TYPE.scale
	#weapon_shadow.visible = WEAPON_TYPE.shadow

func sway_weapon(delta) -> void:
	mouse_movement = mouse_movement.clamp(WEAPON_TYPE.sway_min,WEAPON_TYPE.sway_max)
	position.x = lerp(position.x, WEAPON_TYPE.position.x - (mouse_movement.x *
WEAPON_TYPE.sway_amount_position) * delta, WEAPON_TYPE.sway_speed_position)
	position.y = lerp(position.y, WEAPON_TYPE.position.y + (mouse_movement.y *
WEAPON_TYPE.sway_amount_position) * delta, WEAPON_TYPE.sway_speed_position)

	rotation_degrees.y = lerp(rotation_degrees.y, WEAPON_TYPE.rotation.y + (mouse_movement.x *
WEAPON_TYPE.sway_amount_rotation) * delta, WEAPON_TYPE.sway_amount_rotation)
	rotation_degrees.x = lerp(rotation_degrees.x, WEAPON_TYPE.rotation.x - (mouse_movement.y *
WEAPON_TYPE.sway_amount_rotation) * delta, WEAPON_TYPE.sway_amount_rotation)

func _physics_process(delta: float) -> void:
	sway_weapon(delta)
