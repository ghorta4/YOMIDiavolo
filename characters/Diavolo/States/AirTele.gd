extends CharacterState

const MIN_AIRDASH_HEIGHT = 10
const BACKDASH_LAG_FRAMES = 4
const Y_MODIFIER = "0.60"
const MIN_IASA = 0
const MAX_IASA = 12
const COMBO_IASA = 3
const MAX_EXTRA_LAG_FRAMES = 3

export  var dir_x = "3.0"
export  var dir_y = "-5.0"
export  var speed = "2.0"

var starting_y = 0
var startup_lag_frames = 0

func _frame_1():
	spawn_particle_relative(preload("res://fx/DashParticle.tscn"), host.hurtbox_pos_relative_float(), Vector2(data.x, data.y))

func _frame_0():
	var force = xy_to_dir(data.x, data.y, speed)
	var dir = xy_to_dir(data.x, data.y)
	starting_y = host.get_pos().y
	var back = false
	if host.combo_count > 0:
		starting_iasa_at = COMBO_IASA
	else :
		starting_iasa_at = fixed.round(fixed.add(fixed.mul(fixed.vec_len(dir.x, dir.y), str(MAX_IASA - MIN_IASA)), str(MIN_IASA)))
	iasa_at = starting_iasa_at
	if "-" in force.x:
		if host.get_facing() == "Right" and data.x != 0:
			back = true
	else :
		if host.get_facing() == "Left" and data.x != 0:
			back = true
	if back and host.combo_count <= 0:
		backdash_iasa = true
		beats_backdash = false

		host.hitlag_ticks += BACKDASH_LAG_FRAMES
		host.add_penalty(5)
	else :
		backdash_iasa = false
		beats_backdash = true
	
	host.apply_force(force.x, fixed.mul(force.y, Y_MODIFIER) if "-" in force.y else force.y)
	
	var pos = host.get_pos()
	host.set_pos(str(float(pos.x) + data.x * .20), str(float(pos.y) + data.y * .25))

func _tick():
	host.apply_forces_no_limit()
	if host.is_grounded():
		if host.combo_count > 0:
			queue_state_change("Landing")
		else :
			var lag = 10 + Utils.int_max(MAX_EXTRA_LAG_FRAMES - current_tick, 0)

			queue_state_change("Landing", lag)
			var vel = host.get_vel()
			if host.get_opponent_dir() != fixed.sign(vel.x):
				host.set_vel(fixed.mul(vel.x, "0.6"), vel.y)



