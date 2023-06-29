extends CharacterState

const SHIRT = preload("res://DiavoloChar/characters/Diavolo/Particles/Shirt.tscn")

var game_time = 3600
var state_variables = {}

export var sfx2 : AudioStream
export var sfx3 : AudioStream

func _enter():
	game_time = Global.current_game.time
	
	var soundToUse = host.logic_rng.randi_range(0, 3)
	match soundToUse:
		0: sfx = sfx2
		1: sfx = sfx3

func _frame_0():
	for v in host.opponent.state_variables:
		state_variables[v] = host.opponent.get(v)

func _frame_101():
	host.TimeSkip(0)
	host.carryoverColor = host.color
	host.spawn_particle_effect_relative(SHIRT, Vector2(-15, -15), Vector2(host.get_facing_int(), 0))
	host.play_sound("Intro2")

func _tick():
	host.penalty = 0
	host.opponent.penalty = 0
	var game = Global.current_game
	if(game.time-game.current_tick<game_time):
		game.time+=1
	if host.opponent.stance != "Intro" and current_tick < 119:
		for v in state_variables.keys():
			host.opponent.set(v,state_variables[v])
		host.opponent.hitlag_ticks = 1
		host.opponent.state_interruptable = false
	if current_tick == 119:
		host.opponent.state_interruptable = true
		host.state_interruptable = true
		host.stance = "Normal"
		host.state_machine._change_state("Wait")
		return "Wait"
