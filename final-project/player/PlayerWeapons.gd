extends Spatial


onready var tween : Tween = $Tween
onready var held_weapon : Spatial = $Held
onready var available_weapons : Spatial = $Available

export var switch_time := 0.5

var selected_weapon_index := 0
var aim : RayCast


func _ready() -> void:
	yield(get_tree(), "idle_frame")
	if held_weapon.get_child_count() > 0:
		held_weapon.get_child(0).initialize(aim)
		selected_weapon_index = held_weapon.get_child(0).slot


func _unhandled_key_input(event: InputEventKey) -> void:
	if event.is_action_pressed("primary_weapon"):
		if selected_weapon_index != 0:
			selected_weapon_index = 0
			_switch_to_weapon(selected_weapon_index)
	elif event.is_action_pressed("secondary_weapon"):
		if selected_weapon_index != 1:
			selected_weapon_index = 1
			_switch_to_weapon(selected_weapon_index)


func _switch_to_weapon(index: int) -> void:
	var current_weapon := held_weapon.get_child(0)
	if current_weapon.slot == selected_weapon_index:
		return
	for weapon in available_weapons.get_children():
		if weapon.slot == selected_weapon_index:
			tween.interpolate_property(
				self,
				"rotation_degrees",
				rotation_degrees,
				Vector3(-70, 0, 0),
				switch_time / 2,
				Tween.TRANS_QUINT,
				Tween.EASE_IN)
			tween.start()
			yield(tween, "tween_completed")
			held_weapon.remove_child(current_weapon)
			current_weapon.held = false
			available_weapons.remove_child(weapon)
			available_weapons.add_child(current_weapon)
			held_weapon.add_child(weapon)
			tween.interpolate_property(
				self,
				"rotation_degrees",
				rotation_degrees,
				Vector3.ZERO,
				switch_time / 2,
				Tween.TRANS_QUINT,
				Tween.EASE_IN)
			tween.start()
			yield(tween, "tween_completed")
			weapon.initialize(aim)
			break


func initialize(_aim: RayCast) -> void:
	aim = _aim
