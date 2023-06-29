extends CharacterState

func is_usable():
	var hasKC = host.get_kc() != null
	return not hasKC and .is_usable()

func _frame_7():
	# data.x, data.y, host.get_facing_int()
	var xForce = host.get_facing_int() * (data.x) * 7
	var yForce = (data.y) * 4
	host.apply_force_relative(str(xForce), str(yForce))

func _tick():
	host.apply_forces_no_limit()
