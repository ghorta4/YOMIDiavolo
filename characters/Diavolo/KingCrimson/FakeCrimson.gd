extends BaseProjectile

var toFollow

func init(pos = null):
	.init(pos)
	gravity_enabled = false
	has_projectile_parry_window = false
	state_machine._change_state("Default")

func tick():
	.tick()
	set_pos(toFollow.get_pos().x, toFollow.get_pos().y)
	z_index = 2
	set_facing(toFollow.get_facing_int())
	if current_tick > 70:
		sprite.hide()
		disabled = true
		return
	if current_tick == 4:
		creator.play_sound("blast")
	if current_tick == 3:
		state_machine._change_state("Wait")

func copy_to(f):
	if f == null:
		return
	.copy_to(f)
	f.toFollow = toFollow
