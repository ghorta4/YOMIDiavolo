extends CharacterState

func is_usable():
	return .is_usable() and host.erasedFramesLeft > 0

func _frame_1():
	host.EndTimeErase()
	var kc = host.get_kc()
	if kc != null:
		kc.hitlag_ticks += 10
#	host.opponent.state_machine._change_state("HurtDizzy", host.fakeHitbox)
#	host.opponent.hitlag_ticks = 5
