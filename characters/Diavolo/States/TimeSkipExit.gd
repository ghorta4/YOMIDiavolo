extends CharacterState

func _tick():
	._tick()
	if current_tick >= 2:
		host.state_machine._change_state("Wait")
		host.state_interruptable = false

func _exit():
	pass
