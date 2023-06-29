extends SuperMove

const minFrames = 1
const maxFrames = 60

func init():
	.init()
	super_freeze_ticks = 3
	super_effect = false
	pass

var frames = 60
var performed = false #stop crashing in dittos if both perform at the same time


var exitTick = 60
func _enter():
	._enter()
	if data != null && data.count != null:
		frames = data.count
	var value = frames
	exitTick = value
	if not performed:
		performed = true
		host.TimeSkip(value)
	performed = false

#func _frame_0():
#	host.state_interruptable = true
func _tick():
	._tick()
	if current_tick >= exitTick:
		host.state_machine._change_state("TimeSkipExit")
		host.state_interruptable = true

func _exit():
	._exit()
	host.state_interruptable = true
	if host.opponent.state_machine.state.name == "Wait":
		host.opponent.state_interruptable = true
	host.RestoreComboStats(host.initialComboStats)

func is_usable():
	return .is_usable() and host.get_kc() != null
