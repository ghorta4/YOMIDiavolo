extends Reference # I'd make this a proper interface if GDScript had them

var owner:BaseObj

func _init(owner:BaseObj):
	self.owner = owner

func copy_to(interface):
	interface.variables = variables.duplicate(true)

# Composite functions
# This is to allow you and your opponents to not inturrupt your flags
var variables = {
	1:init_variables(),
	2:init_variables(),
}

func init_variables():
	return {
		"invulnerable":false,
		"projectile_invulnerable":false,
		"throw_invulnerable":false,
	}

func set_composite_variable(key:String, value, target:BaseObj):
	var target_interface = target.get("composite_interface")
	if target_interface != null:
		target_interface.recieve_composite_variable(key, value, owner)
	else:
		target.set(key, value)

func recieve_composite_variable(key:String, value, origin:BaseObj):
	if !variables.has(origin.id):
		variables[origin.id] = init_variables()
	var vars = variables[origin.id]
	vars[key] = value
	var values_by_player_id = {}
	for player_id in variables:
		var var_dic = variables[player_id]
		values_by_player_id[player_id] = var_dic.get(key)
	check_composite_variable(key, values_by_player_id)

func check_composite_variable(key:String, values_by_player_id:Dictionary):
	# This exists for advanced variable implementation
	# Missing variables will be null
	# By default just assumes it'll be a bool and that nulls are false
	for value in values_by_player_id.values():
		if value:
			owner.set(key, value)
			return value
	owner.set(key, false)
	return false