extends Node2D	

func _on_start_pressed():
	get_tree().change_scene_to_file("res://MAP/street.tscn")   
pass # Replace th function body.
 # Replace th function body.
func _on_start2_pressed():
	get_tree().change_scene_to_file("res://street.tscn")   
pass # Replace th function body.
 # Replace th function body.

func _on_exit_pressed(): get_tree().quit()
	


func _on_setting_pressed(): get_tree().change_scene_to_file("res://setting.tscn")
 


func _on_shop_pressed():
	get_tree().change_scene_to_file("res://character_select.tscn")
	pass # Replace with function body.
