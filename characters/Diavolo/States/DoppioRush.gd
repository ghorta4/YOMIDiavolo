extends CharacterState

func is_usable():
	var hasKC = host.get_kc() != null
	return not hasKC and .is_usable()

func _frame_5():
	host.apply_force(str(host.get_facing_int() * 7 + 0.05 * float(data.x)), str(0.1 * float(data.y) - 7))

func _frame_12():
	var vel = host.get_vel()
	host.set_vel(str(float(vel.x) / 3), str(float(vel.y) / 3))

func _tick():
	if current_tick > 12:
		var vel = host.get_vel()
		host.set_vel(vel.x, str(min(float(vel.y), 0.5)))
	if current_tick > 4 && current_tick < 12:
		host.apply_forces_no_limit()
	else:
		host.apply_forces()
	._tick()
