extends CharacterState

const accel = 0.2

var ticky = 0

func _tick():
	if accel:
		host.apply_force(str(accel * host.get_facing_int()), str(0))
	host.apply_fric()
	host.apply_forces()
	host.apply_grav()
	ticky += 1
	if ticky >= 2:
		ticky -= 2
		host.gain_super_meter(1)
	._tick()

