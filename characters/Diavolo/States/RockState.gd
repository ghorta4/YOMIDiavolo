extends "res://characters/stickman/projectiles/fireball_states/Default.gd"

func _tick():
	var pos = host.get_pos()
	var vel = host.get_vel()
	if host.is_grounded() && host.current_tick > 10:
		Kill()
		return
	
	if Utils.int_abs(pos.x) >= host.stage_width:
		Kill()
		return

	set_rotation()

func set_rotation():
	host.sprite.rotation += 3 * float(host.get_facing_int()) + float(host.get_vel().x) * 0.3

func Kill():
	host.spawn_particle_effect_relative(host.BREAK, Vector2(0,0))
	host.sprite.hide()
	terminate_hitboxes()
	host.disabled = true

func _on_hit_something(obj, hitbox):
	._on_hit_something(obj, hitbox)
	Kill()

func update_sprite_frame():
	.update_sprite_frame()
	host.sprite.frame = host.frameSelect
