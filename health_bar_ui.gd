extends CanvasLayer

@onready var hp = $Control/hp
@onready var coin_label = $Control/CoinLabel
func _ready():
	print("✅ HealthBarUI загружен")
	
	if not hp:
		print("❌ hp не найден!")
	else:
		print("✅ hp найден: ", hp)
	
	if not coin_label:
		print("❌ coin_label не найден!")
	else:
		print("✅ coin_label найден: ", coin_label)
	
	# Инициализируем начальные значения
	update_health(100)
	update_coins(0)

func update_health(current_health: int):
	if hp:
		hp.value = current_health
		print("Здоровье обновлено: ", current_health)
func update_coins(coin_count: int):
	if coin_label:
		coin_label.text = "Золото: " + str(coin_count)
