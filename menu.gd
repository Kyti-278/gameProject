extends Node2D


func _on_start_pressed():
  get_tree().change_scene_to_file("res://street.tscn")   
pass # Replace th function body.


func _on_exit_pressed(): get_tree().quit()
	
