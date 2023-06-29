extends CharacterState

func is_usable():
	var usable = false
	var kc = host.get_kc()
	if kc != null && host.summonCanTP: usable = true
	return .is_usable() and usable

func _enter():
	var kc = host.get_kc()
	if kc == null : return
	host.spawn_particle_effect(host.STANDOUT, Vector2(float(kc.get_pos().x), float(kc.get_pos().y)))
	host.play_sound("standOut2")
	host.summonCanTP = false
	kc.set_pos(str(host.get_pos().x + host.get_facing_int() * 9), str(host.get_pos().y - 18))
	host.CallCommand("Tackle")
	kc.tick()

func _frame_7():
	host.has_hyper_armor = true

func _exit_shared():
	host.has_hyper_armor = false
