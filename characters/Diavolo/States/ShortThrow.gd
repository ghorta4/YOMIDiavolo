extends ThrowState

func _frame_0():
	host.combo_count += 1
	if host.combo_count >= 3:
		hard_knockdown = false
		anim_length = 19
		iasa_at = 19
	else:
		hard_knockdown = true
		anim_length = 15
		iasa_at = 15
