extends ObjectState

func _exit_shared():
	host.attacking = false

func _frame_15():
	host.apply_force(str(host.get_facing_int() * 32), "0")
