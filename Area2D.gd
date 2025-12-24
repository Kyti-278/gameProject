extends Area2D

@export var scene_path: String = "res://MAP/street2.tscn"
@export var player_name: String = "Player"

func _ready():
	body_entered.connect(_on_body_entered)

#func _on_body_entered(body):
#	if body.name == player_name:
#		get_tree().change_scene_to_file(scene_path)
func _on_body_entered(body):
	if body.name == player_name:
		print("Переход на сцену: ", scene_path)
		print("Тип тела: ", body.get_class())
		print("Ошибка произойдет после этой строки...")
		await get_tree().process_frame  # небольшая задержка
		get_tree().change_scene_to_file(scene_path)
