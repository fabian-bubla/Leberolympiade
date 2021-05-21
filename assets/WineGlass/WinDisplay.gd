extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func win_display():
	for i in self.get_children():
		i.visible
	$LongestCombo.text = str(self.get_parent().biggest_combo_counter)
	$Attacks.text = str(self.get_parent().attack_counter)
	$Mistakes.text = str(self.get_parent().mistakes_counter)
#	is_winner = true #PLACEHOLDER
