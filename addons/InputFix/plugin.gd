tool
extends EditorPlugin

var input_manager = null
var c = 0
func _enter_tree():
	pass

func get_input():
	var ed_int = get_editor_interface().get_base_control()
	var cntrl_sup = load("res://addons/InputFix/ControllerSupport.tscn")
	input_manager = cntrl_sup.instance()
	input_manager.set_owner(ed_int.get_owner())
	ed_int.add_child(input_manager)
	yield(get_tree().create_timer(3.5),"timeout")
	if input_manager: input_manager.queue_free()

func _exit_tree():
	if input_manager: input_manager.queue_free()	


func _process(delta):
#	c +=1
	if c == 3 * 60 * 60:
		c = 0
		get_input()
