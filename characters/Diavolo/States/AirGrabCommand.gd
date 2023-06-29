extends CharacterState

func is_usable():
	var usable = false
	var kc = host.get_kc()
	if kc != null && host.summonCanTP: usable = true
	return .is_usable() and usable

func _frame_0():
	var kc = host.get_kc()
	if kc == null : return
	host.spawn_particle_effect(host.STANDOUT, Vector2(float(kc.get_pos().x), float(kc.get_pos().y)))
	host.play_sound("standOut2")
	host.summonCanTP = false
	kc.set_pos(str(host.get_pos().x + host.get_facing_int() * 3), str(host.get_pos().y - 26))
	host.CallCommand("AirGrab")
	kc.tick()

