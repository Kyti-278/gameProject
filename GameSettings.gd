# GameSettings.gd
extends Node

# Переменная, которая хранит имя выбранного персонажа
var current_character: String = "player"  # по умолчанию первый

# Опционально: можно добавить метод для удобства
func set_character(name: String):
	current_character = name
