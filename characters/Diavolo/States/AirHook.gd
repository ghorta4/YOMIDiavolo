extends CharacterState

func is_usable():
	var hasKC = host.get_kc() != null
	return not hasKC and .is_usable()

func _frame_2():
	host.set_vel(host.get_vel().x, str(min(float(host.get_vel().y), 0)))
