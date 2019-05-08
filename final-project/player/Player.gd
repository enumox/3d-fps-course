extends KinematicBody
class_name Player

onready var camera : Camera = $Camera
onready var right_arm : Spatial = $Mesh/RightArm

export var move_speed := 250.0
export var gravity := 2500.0
export var jump_force := 1000.0

var velocity := Vector3()
var yaw := 0


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta: float) -> void:
	var motion := Vector3(int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left")),
		0, int(Input.is_action_pressed("move_back")) - int(Input.is_action_pressed("move_front")))
	
	velocity = motion.normalized() * move_speed
	
	velocity.y -= gravity * delta
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_force
	
	velocity = move_and_slide(velocity.rotated(Vector3.UP, rotation.y), Vector3.UP)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		yaw = yaw - event.relative.x * camera.mouse_sensitivity
		rotation.y = deg2rad(yaw)
