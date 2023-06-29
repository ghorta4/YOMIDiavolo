extends CharacterState

func is_usable():
	var hasKC = host.get_kc() != null
	return not hasKC and .is_usable()

func _frame_5():
	host.has_hyper_armor = true

func _frame_13():
	host.has_hyper_armor = false

func _tick():
	host.apply_forces_no_limit()
