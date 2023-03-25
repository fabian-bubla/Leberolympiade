extends ColorRect

#var mat = $MrWobble.material

func _ready():
# warning-ignore:return_value_discarded
	GameEvents.connect("update_shader_strength", self,"_update_shader_strength")

func _update_shader_strength():
#	print("UPDATE!  ",  Stats.current_shader_strength/30.0)
	material.set_shader_param("strength", Stats.current_shader_strength/20)
	print(material.get_shader_param("strength"))
