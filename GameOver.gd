extends Control

@onready var coins_label = $CenterContainer/VBoxContainer/CoinsLabel
# Called when the node enters the scene tree for the first time.
func _ready():
	coins_label.text = "Собрано золота: " + str(SaveData.coins)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")
	pass # Replace with function body.


func _on_restart_button_pressed():
	get_tree().change_scene_to_file("res://MAP/street.tscn")
	pass # Replace with function body.
