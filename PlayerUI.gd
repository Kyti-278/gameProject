extends CanvasLayer

@onready var health_bar = $Control/HealthBar  # Проверь этот путь!
@onready var coin_label = $Control/CoinPanel/CoinLabel

func _ready():
	print("HealthBar найден: ", health_bar != null)
	print("CoinLabel найден: ", coin_label != null)
	# Настройка health bar
	health_bar.min_value = 0
	health_bar.max_value = 100
	health_bar.value = 100
	
	# Принудительно устанавливаем начальные значения
	update_health(100, 100)
	update_coins(0)

func update_health(current_health: int, max_health: int):
	print("Обновляем здоровье: ", current_health, "/", max_health)
	health_bar.max_value = max_health
	health_bar.value = current_health
	
	# Меняем цвет в зависимости от здоровья
	if current_health < max_health * 0.3:      # Меньше 30%
		health_bar.tint_progress = Color.RED
	elif current_health < max_health * 0.6:    # Меньше 60%
		health_bar.tint_progress = Color.YELLOW
	else:                                      # Больше 60%
		health_bar.tint_progress = Color.GREEN

func update_coins(coin_count: int):
	print("Обновляем монеты: ", coin_count)
	if coin_label:
		coin_label.text = "Монеты: " + str(coin_count)
