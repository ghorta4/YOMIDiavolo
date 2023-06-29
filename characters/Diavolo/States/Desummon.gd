extends CharacterState

func is_usable():
	return .is_usable() and host.get_kc() != null

func _frame_0():
	if host.combo_count == 0:
		starting_iasa_at = 12
	else:
		starting_iasa_at = 3

func _frame_1():
	host.kill_kc()

func _frame_3():
	if host.combo_count > 0:
		host.state_interruptable = true
