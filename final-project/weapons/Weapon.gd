extends Spatial
class_name Weapon

signal collider_hit(collider, point)

onready var timer : Timer = $Timer
onready var animation_player : AnimationPlayer = $AnimationPlayer

const PARTICLE_EFFECT := preload("res://weapons/BulletHitParticle.tscn")

export var fire_rate := 5
export var clip_size := 10
export var ammo := 50
export(int, "Primary", "Secondary") var slot : int

var current_clip_ammo := clip_size
var aim : RayCast
var held := false setget set_held

func _ready() -> void:
	timer.wait_time = 1.0 / fire_rate
	connect("collider_hit", self, "_on_collider_hit")
	self.held = false


func _process(delta: float) -> void:
	if Input.is_action_pressed("shoot") and timer.is_stopped() and current_clip_ammo > 0\
		and not animation_player.is_playing():
		_shoot()
	elif (Input.is_action_just_pressed("reload") or Input.is_action_pressed("shoot") and current_clip_ammo == 0) \
		and current_clip_ammo < clip_size and ammo > 0 and not animation_player.is_playing():
		_reload()
	

func _shoot():
	timer.start()
	animation_player.stop()
	animation_player.play("shoot")
	current_clip_ammo -= 1
	if aim.is_colliding():
		emit_signal("collider_hit", aim.get_collider(), aim.get_collision_point())
		var particle = PARTICLE_EFFECT.instance()
		add_child(particle)
		particle.set_as_toplevel(true)
		particle.global_transform.origin = aim.get_collision_point()
		particle.emitting = true


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


func _on_collider_hit(collider: Object, point: Vector3) -> void:
	print("Collider hit not implemented on: %s" % get_path())


func initialize(_aim: RayCast) -> void:
	aim = _aim
	self.held = true

func set_held(value: bool) -> void:
	held = value
	set_process(held)
