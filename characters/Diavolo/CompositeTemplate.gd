extends Fighter

# Required
# INTERFACE_PATH needs to be set to the correct location
const INTERFACE_PATH = "res://DiavoloChar/characters/Diavolo/CompositeInterface.gd"
var composite_interface = preload(INTERFACE_PATH).new(self)

func copy_to(f):
	.copy_to(f)
	composite_interface.copy_to(f.composite_interface)

# Optional
func set_composite_variable(key:String, value, target:BaseObj = self):
	composite_interface.set_composite_variable(key, value, target)

# Defalt composite implementations
func start_throw_invulnerability():
	set_composite_variable("throw_invulnerable", true)

func end_throw_invulnerability():
	set_composite_variable("throw_invulnerable", false)

func start_projectile_invulnerability():
	set_composite_variable("projectile_invulnerable", true)

func end_projectile_invulnerability():
	set_composite_variable("projectile_invulnerable", false)

func start_invulnerability():
	set_composite_variable("invulnerable", true)

func end_invulnerability():
	set_composite_variable("invulnerable", false)
