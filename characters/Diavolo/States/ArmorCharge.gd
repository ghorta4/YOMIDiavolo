extends CharacterState

func _tick():
	if current_tick > 12:
		host.apply_forces_no_limit()
	else:
		host.apply_forces()
	._tick()

func _frame_13():
	host.has_hyper_armor = true
	
	host.apply_force(str(host.get_facing_int() * 20 + 0.06 * float(data.x)), str(0.05 * float(data.y) - 3))


func _exit_shared():
	host.has_hyper_armor = false

func _enter():
	var vel = host.get_vel()
	host.set_vel(str(float(vel.x) / 2), vel.y)

func is_usable():
	var hasKC = host.get_kc() != null
	return not hasKC and .is_usable()
