# CharacterSelect.gd
extends Control

# Массив с именами персонажей — должен совпадать с тем, что в GameSettings
const CHARACTERS = ["player", "player_2", "player_3", "player_4"]

func _ready():
	# Можно здесь подгрузить превью персонажей, но пока просто кнопки
	pass

# Один обработчик на все кнопки — можно сделать через сигналы по отдельности,
# но проще: прикрепи этот метод ко всем кнопкам
func on_character_selected(char_index: int):
	var char_name = CHARACTERS[char_index]
	GameSettings.set_character(char_name)
	# Возвращаемся в главное меню
	get_tree().change_scene_to_file("res://menu.tscn")


func _on_btn_char_1_pressed():
	pass # Replace with function body.


func _on_btn_char_2_pressed(extra_arg_0):
	pass # Replace with function body.


func _on_btn_char_3_pressed(extra_arg_0):
	pass # Replace with function body.


func _on_btn_char_4_pressed(extra_arg_0):
	pass # Replace with function body.
