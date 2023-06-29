extends ObjectState

func _exit_shared():
	host.attacking = false

func _frame_1():
	host.apply_force(str(float(host.memorizedDirection.x)/3.5), str(float(host.memorizedDirection.y)/6.0))

func _frame_12():
	host.apply_force(str(float(host.memorizedDirection.x)/16.0 + 36 * host.get_facing_int()), str(float(host.memorizedDirection.y)/18.0 + 38))
