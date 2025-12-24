extends Area2D

@export var value: int = 1  # Стоимость монеты
@export var attract_speed: float = 200.0  # Скорость притяжения к игроку

var player: Node2D = null
var can_attract: bool = false

func _ready():
	# Ждем немного перед притягиванием
	var timer = get_tree().create_timer(0.5)
	timer.timeout.connect(_enable_attraction)
	
	# Подключаем сигнал
	body_entered.connect(_on_body_entered)

func _enable_attraction():
	can_attract = true
	# Находим игрока
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	if can_attract and player and global_position.distance_to(player.global_position) < 100:
		# Плавное притягивание к игроку
		var direction = (player.global_position - global_position).normalized()
		position += direction * attract_speed * delta

func _on_body_entered(body):
	if body.is_in_group("player"):
		# Добавляем золото игроку
		if body.has_method("add_coins"):
			body.add_coins(value)
		
		# Эффект получения
		print("+", value, " золота!")
		
		# Удаляем монету
		queue_free()
