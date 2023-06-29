extends "res://characters/stickman/projectiles/fireball_states/Default.gd"

func _tick():
	._tick()
	set_rotation()

func set_rotation():
	var vel = fixed.vec_mul(host.dir_x, host.dir_y, data.speed_modifier)
	host.sprite.rotation = PI/2 - (atan2(float(vel.x),float(vel.y))) * host.get_facing_int()

func move():
		var dir = fixed.vec_mul(host.dir_x, host.dir_y, data.speed_modifier)
		host.move_directly_relative(dir.x, dir.y)
