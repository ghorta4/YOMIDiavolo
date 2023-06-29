extends ThrowState

func _enter():
	host.apply_force("0", "-9")


func _tick():
	if host.is_grounded():
		host.state_machine._change_state("KCAirGrab3")
	._tick()

func _exit():
	host.hitlag_ticks += 3
	host.opponent.hitlag_ticks += 3
