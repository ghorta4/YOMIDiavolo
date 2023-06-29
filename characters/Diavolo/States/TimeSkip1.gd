extends CharacterState

func is_usable():
	return .is_usable() and host.get_kc() != null

func _frame_15():
	host.TimeSkip(45)
