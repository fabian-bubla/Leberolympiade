extends Node2D

export var controller_id = 0


var RP_input_right = []
var right_input_accomplished

var right_int_to_button_dict = {
	0: "button_left",
	1: "button_right",
	2: "button_up",
	3: "button_down",
}
func _ready():
	randomize()
	for i in 20:
		RP_input_right.append(randi() % 4)
		
		
	pass


func _process(_delta):
	for i in right_int_to_button_dict.values():
		#which of the buttons of the right side where pressed iterate
		if Input.is_action_just_pressed(i):
			var R_next_press = right_int_to_button_dict[RP_input_right[0]]
			#is the next necessary press among them then:
			if Input.is_action_just_pressed(R_next_press):
				print("R_CORRECT")
				right_input_accomplished = RP_input_right.pop_front()
	

	
