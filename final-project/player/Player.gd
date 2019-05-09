extends KinematicBody
class_name Player

onready var camera : Camera = $Camera
onready var right_arm : Spatial = $Body/RightArm

export var move_speed := 1250.0
export var gravity := 75.0
export var jump_force := 20.0
export var acceleration := 5.0
export(float, 1.0, 3.0) var deceleration_factor := 2.0

var velocity := Vector3()
var yaw := 0
var current_jump_force := 0.0


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _process(delta: float) -> void:
	right_arm.rotation_degrees.x = -camera.rotation_degrees.x - 90.0


func _physics_process(delta: float) -> void:
	var motion := Vector3(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		0, Input.get_action_strength("move_back") - Input.get_action_strength("move_front"))
	
	var desired_velocity := motion.normalized() * move_speed
	
	desired_velocity = desired_velocity.rotated(Vector3.UP, rotation.y)
	var factor := 1.0 if desired_velocity != Vector3.ZERO else deceleration_factor
	velocity.x = lerp(velocity.x, desired_velocity.x, 5.0 * delta * factor)
	velocity.z = lerp(velocity.z, desired_velocity.z, 5.0 * delta * factor)
	
	velocity.y -= gravity * delta
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_force
	
	velocity = move_and_slide(velocity, Vector3.UP)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		yaw = yaw - event.relative.x * camera.mouse_sensitivity
		rotation.y = deg2rad(yaw)
