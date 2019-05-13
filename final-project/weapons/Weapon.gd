extends Spatial
class_name Weapon


onready var timer : Timer = $Timer
onready var animation_player : AnimationPlayer = $AnimationPlayer

export var fire_rate := 5
export var clip_size := 10
export var ammo := 50

var current_clip_ammo := clip_size


func _ready() -> void:
	timer.wait_time = 1.0 / fire_rate


func _process(delta: float) -> void:
	if Input.is_action_pressed("shoot") and timer.is_stopped() and current_clip_ammo > 0:
		_shoot()
	elif Input.is_action_just_pressed("reload") and current_clip_ammo < clip_size and ammo > 0 and not animation_player.is_playing():
		_reload()
	

func _shoot():
	timer.start()
	animation_player.stop()
	animation_player.play("shoot")
	current_clip_ammo -= 1


func _reload() -> void:
	animation_player.play("reload")
	yield(animation_player, "animation_finished")
	var to_load := clip_size - current_clip_ammo
	if ammo >= to_load:
		current_clip_ammo = clip_size
		ammo -= to_load
	else:
		current_clip_ammo = ammo
		ammo = 0
