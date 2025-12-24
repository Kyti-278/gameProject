# SaveData.gd
extends Node

# Путь к файлу сохранения
const SAVE_PATH = "/home/kyti/snap/godot4-mono/common/mafia/savegame.cfg"

# Данные
var coins: int = 0
var player_character: String = "player_1"
var high_score: int = 0

# Загрузить при старте
func _ready():
	load_game()

# === Сохранить данные ===
func save_game():
	var save_file = ConfigFile.new()
	save_file.set_value("player", "coins", coins)
	save_file.set_value("player", "character", player_character)
	save_file.set_value("stats", "high_score", high_score)
	
	var result = save_file.save(SAVE_PATH)
	if result == OK:
		print("💾 Данные сохранены: ", coins, " монет")
	else:
		print("❌ Ошибка сохранения")

# === Загрузить данные ===
func load_game():
	var save_file = ConfigFile.new()
	var result = save_file.load(SAVE_PATH)
	
	if result == OK:
		coins = save_file.get_value("player", "coins", 0)
		player_character = save_file.get_value("player", "character", "player_1")
		high_score = save_file.get_value("stats", "high_score", 0)
		print("📂 Данные загружены: ", coins, " монет")
	else:
		print("🆕 Нет сохранения — создаём новое")
		save_game()  # создаём файл при первом запуске
