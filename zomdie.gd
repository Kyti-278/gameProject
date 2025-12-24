# zombie.gd
extends CharacterBody2D

@export var speed: float = 150.0
@export var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var chase_distance: float = 200.0
@export var jump_force: float = 400.0
@export var attack_damage: int = 4
@export var attack_cooldown: float = 1.0
@export var max_health: int = 100
@export var drop_coin_chance: float = 0.7  # 70% шанс выпадения монеты
@export var drop_medkit_min: float = 0.01  # минимальный шанс аптечки (1%)
@export var drop_medkit_max: float = 0.30  # максимальный шанс аптечки (30%)
@export var coin_value_min: int = 1
@export var coin_value_max: int = 3
# Новые параметры для блуждания
@export var wander_distance: float = 150.0  # Дистанция блуждания
@export var min_wander_time: float = 2.0    # Минимальное время движения в одном направлении
@export var max_wander_time: float = 4.0    # Максимальное время движения в одном направлении

var player: Node2D = null
var can_attack: bool = true
var health: int = max_health

# Переменные для блуждания
var wander_direction: int = 1  # 1 = вправо, -1 = влево
var wander_timer: float = 0.0
var is_wandering: bool = true
var start_position: Vector2  # Начальная позиция для блужданя

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var attack_timer: Timer

# Сигнал смерти
signal died

func _ready():
	# Поиск игрока по сцене (более надежно)
	var street = get_tree().get_current_scene()
	if street and street.has_node("Player2/Player"):
		player = street.get_node("Player2/Player")
	else:
		var players = get_tree().get_nodes_in_group("player")
		if players.size() > 0:
			player = players[0]
		else:
			print_debug("Player node not found!")

	# Таймер для контроля атаки
	attack_timer = Timer.new()
	attack_timer.one_shot = true
	attack_timer.wait_time = attack_cooldown
	add_child(attack_timer)
	attack_timer.timeout.connect(_on_attack_timer_timeout)

	# Добавляем зомби в группу "enemy"
	add_to_group("enemy")
	
	# Инициализация блуждания
	start_position = global_position
	start_wander_timer()

func _physics_process(delta):
	# Если игрок не найден, просто блуждаем
	if not is_instance_valid(player):
		wander_behavior(delta)
		move_and_slide()
		return

	var direction_to_player = player.global_position - global_position
	var distance_to_player = direction_to_player.length()
	var dir_x = sign(direction_to_player.x)

	# Если игрок в радиусе преследования
	if distance_to_player <= chase_distance:
		is_wandering = false
		chase_player(delta, direction_to_player, distance_to_player, dir_x)
	else:
		# Если игрок далеко, возвращаемся к блужданию
		if not is_wandering:
			is_wandering = true
			start_position = global_position
			start_wander_timer()
		wander_behavior(delta)
	
	move_and_slide()

# Преследование игрока
func chase_player(delta, direction_to_player, distance_to_player, dir_x):
	# Гравитация
	if not is_on_floor():
		velocity.y += gravity * delta

	# Движение к игроку
	velocity.x = dir_x * speed
	animated_sprite.flip_h = (dir_x < 0)

	# Прыжок, если игрок выше
	if is_on_floor() and (player.global_position.y + 10) < global_position.y:
		velocity.y = -jump_force
		_play_animation("jump")
	elif abs(velocity.x) > 1:
		_play_animation("run")
	else:
		_play_animation("idle")

	# Атака, если близко к игроку
	if distance_to_player < 30 and can_attack:
		_attack_player()

# Поведение блуждания
func wander_behavior(delta):
	# Гравитация
	if not is_on_floor():
		velocity.y += gravity * delta

	# Обновляем таймер блуждания
	wander_timer -= delta
	if wander_timer <= 0:
		# Меняем направление и запускаем новый таймер
		wander_direction *= -1
		start_wander_timer()
	
	# Проверяем, не ушли ли мы слишком далеко от начальной позиции
	var distance_from_start = global_position.x - start_position.x
	if abs(distance_from_start) >= wander_distance:
		# Если ушли далеко, возвращаемся к начальной позиции
		wander_direction = -sign(distance_from_start)
		start_wander_timer()
	
	# Двигаемся в текущем направлении
	velocity.x = wander_direction * speed * 0.7  # Немного медленнее при блуждании
	
	# Анимация
	if abs(velocity.x) > 1:
		_play_animation("run")
		animated_sprite.flip_h = (wander_direction < 0)
	else:
		_play_animation("idle")

# Запуск таймера блуждания
func start_wander_timer():
	wander_timer = randf_range(min_wander_time, max_wander_time)

# Воспроизведение анимации
func _play_animation(name: String):
	if animated_sprite.animation != name:
		animated_sprite.play(name)

# Атака игрока
func _attack_player():
	if not is_instance_valid(player):
		return

	# Наносим урон игроку
	if player.has_method("take_damage"):
		player.take_damage(attack_damage)
	elif "health" in player:
		player.health -= attack_damage

	can_attack = false
	attack_timer.start()

# Таймер атаки
func _on_attack_timer_timeout():
	can_attack = true

# Получение урона
func take_damage(amount: int):
	health -= amount
	print("🧟 Зомби получил урон: ", amount, ". Осталось здоровья: ", health)

	if health <= 0:
		die()

# Смерть зомби
func die():
	print("💀 Зомби умер!")
	drop_loot()  # Сперва создаём предметы
	died.emit()
	queue_free()

func drop_loot():
	# Загружаем сцены
	var coin_scene = preload("res://ITEM/coin.tscn")
	var medkit_scene = preload("res://ITEM/Medkit.tscn")
	
	# Пытаемся получить игрока (на случай, если он есть)
	var players = get_tree().get_nodes_in_group("player")
	var p = null
	if players.size() > 0:
		p = players[0]
	
	# ГСЧ
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	# Монеты: шанс drop_coin_chance (по умолчанию 0.7)
	if rng.randf() <= drop_coin_chance:
		var coin = coin_scene.instantiate()
		get_parent().add_child(coin)
		coin.global_position = global_position
		coin.value = rng.randi_range(coin_value_min, coin_value_max)
		print("Выпали монеты: ", coin.value)
	
	# Аптечка: шанс линейно зависит от здоровья игрока (1%..30%)
	# Если игрока нет — используем базовый средний шанс (10%)
	var medkit_chance: float = 0.10
	if is_instance_valid(p):
		var player_max_hp = 100.0
		if "max_health" in p:
			player_max_hp = float(p.max_health)
		
		var player_current_hp = 0.0
		if "health" in p:
			player_current_hp = float(p.health)
		
		var hp_ratio = 0.0
		if player_max_hp > 0:
			hp_ratio = clamp(player_current_hp / player_max_hp, 0.0, 1.0)
		
		# Чем меньше здоровья — тем выше шанс. При hp_ratio=1 -> min (1%), при 0 -> max (30%).
		medkit_chance = lerp(drop_medkit_max, drop_medkit_min, hp_ratio)
	
	if rng.randf() <= medkit_chance:
		var medkit = medkit_scene.instantiate()
		get_parent().add_child(medkit)
		medkit.global_position = global_position
		print("Выпала аптечка! Шанс: ", medkit_chance, " HP игрока: ", is_instance_valid(p) and p.health or "unknown")
