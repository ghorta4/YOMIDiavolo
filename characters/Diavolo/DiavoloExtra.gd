extends PlayerExtra

onready var move_stand = $"VBoxContainer/Stand Pos"

var desiredOffset

func _ready():
	move_stand.connect("data_changed", self, "emit_signal", ["data_changed"])
	return

# TODO - Figure out why this doesn't update properly until you preview a move
# LINK[id=Extras] DiavoloChar\characters\Diavolo\Diavolo.gd#Extras
func get_extra():
	var extra = {
		"desiredOffset":move_stand.get_data(),
	}
	return extra

func show_options():
	move_stand.hide()
	move_stand.visible = move_stand_visible()

func update_selected_move(move_state):
	.update_selected_move(move_state)
	move_stand.visible = move_stand_visible() || (move_state != null && move_state.name == "RushCommand")

func move_stand_visible():
	return fighter.kingCrimsonID != null && not fighter.get_kc().attacking
