extends Camera

onready var aim : RayCast = $Aim
onready var weapon_slot : Spatial = $WeaponSlot

export var mouse_sensitivity := 0.5
export var max_pitch := 45.0

var pitch := 0

func _ready() -> void:
	if weapon_slot.get_child_count() > 0:
		weapon_slot.get_child(0).initialize(aim)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		pitch = clamp(pitch - event.relative.y * mouse_sensitivity, - max_pitch, max_pitch)
		rotation.x = deg2rad(pitch)
	