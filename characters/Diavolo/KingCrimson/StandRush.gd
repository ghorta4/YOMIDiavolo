extends ObjectState

func _exit_shared():
	host.attacking = false

func _frame_1():
	host.set_vel("0","0")
	host.apply_force(str(float(host.memorizedDirection.x)/7.0), str(float(host.memorizedDirection.y)/7.0))

func _tick():
	host.apply_force(str(float(host.get_facing_int()) * 0.15), "0")
