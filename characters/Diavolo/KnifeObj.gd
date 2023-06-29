extends BaseProjectile

var dir_x = "0"
var dir_y = "0"


func _ready():
	state_variables.append_array(
		["dir_x", "dir_y"]
	)

func copy_to(o):
	.copy_to(o)
	o.data = data
	o.dir_x = dir_x
	o.dir_y = dir_y
	o.state_machine.state.set_rotation()
	o.flip.scale = flip.scale
