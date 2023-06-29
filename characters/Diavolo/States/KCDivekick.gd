extends CharacterState

const FFX = preload("res://DiavoloChar/characters/Diavolo/Particles/Divekick.tscn")

func is_usable():
	var hasKC = host.get_kc() != null
	return not hasKC and .is_usable()

var timer = 0

func _tick():
	timer += 1
	if timer >= 2:
		timer -= 2
		host.spawn_particle_effect_relative(FFX, Vector2(0,0), Vector2(host.get_facing_int(), 1))
	if host.is_grounded():
		host.change_state("KCLand")
