extends Node2D

export var controller_id = 0

var LP_input_left = []
var RP_input_right = []
var right_player_random_input_list = []

var left_input_accomplished
var right_input_accomplished

var left_int_to_button_dict = {
	0: "ui_left",
	1: "ui_right",
	2: "ui_up",
	3: "ui_down",
}
var right_int_to_button_dict = {
	0: "button_left",
	1: "button_right",
	2: "button_up",
	3: "button_down",
}
func _ready():
	randomize()
	for i in 20:
		LP_input_left.append(randi() % 4)
		RP_input_right.append(randi() % 4)
		
		
	pass


func _process(_delta):
	#LEFT CHECK
	#IS the Input pressed for the left side?
	for i in left_int_to_button_dict.values():
		#which of the buttons of the left side where pressed iterate
		if Input.is_action_just_pressed(i):
			var L_next_press = left_int_to_button_dict[LP_input_left[0]]
			#is the next necessary press among them then:
			if Input.is_action_just_pressed(L_next_press):
				print("L_CORRECT")
				left_input_accomplished = LP_input_left.pop_front()
				point_scored():
			
	for i in right_int_to_button_dict.values():
		#which of the buttons of the right side where pressed iterate
		if Input.is_action_just_pressed(i):
			var R_next_press = right_int_to_button_dict[RP_input_right[0]]
			#is the next necessary press among them then:
			if Input.is_action_just_pressed(R_next_press):
				print("R_CORRECT")
				right_input_accomplished = RP_input_right.pop_front()
	
	pass
	
	
	
func point_scored():
	

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
#	_______________________________________________________________________
#	func _input(event):
##	var just_pressed = event.is_pressed() and not event.is_echo()
##	if just_pressed: #only true on frames where input is just pressed not on other frames
##
##		print(event.as_text(), left_int_to_button_dict.values())
##		if event.as_text() in left_int_to_button_dict.values():
##			print("TRRRRUE")
##			var next_press= LP_input_left[0]
##			if event.is_action_pressed(left_int_to_button_dict[next_press]):
##				left_input_accomplished = LP_input_left.pop_front()
##				pass
#
#
#
#
##		for ENT in right_int_to_button_dict:
##			if event.is_action_pressed(right_int_to_button_dict[ENT]):
##				print("RIGHT")
#				pass
	
