extends CharacterState

func is_usable():
	var hasKC = host.get_kc() != null
	return not hasKC and .is_usable()

func _frame_4():
	host.set_vel(host.get_vel().x, "0")
	host.apply_force(str(host.get_facing_int() * 10 + 0.4 * float(data.x)), str(0.1 * float(data.y) - 18.0))
