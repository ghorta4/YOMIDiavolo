extends CharacterState

const CIG = preload("res://DiavoloChar/characters/Diavolo/Particles/Ciggy.tscn")

func _frame_30():
	host.epitaphFramesLeft += 40

func _frame_33():
	host.spawn_particle_effect_relative(CIG, Vector2(-12,-10), Vector2(host.get_facing_int(), 0))

func is_usable():
	var hasKC = host.get_kc() != null
	return not hasKC and host.epitaphFramesLeft <= 0 && .is_usable()
