extends BaseProjectile

const BREAK = preload("res://DiavoloChar/characters/Diavolo/Particles/RockBreak.tscn")

var frameSelect = 0

func copy_to(o):
	.copy_to(o)
	o.data = data
	o.rotation_degrees = rotation_degrees
	o.flip.scale = flip.scale
