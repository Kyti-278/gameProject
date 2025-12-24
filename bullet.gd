extends Area2D

@export var initial_speed: float = 500.0 # начальная скорость пули
@export var lifetime: float = 0.4 # время жизни пули в секундах
@export var damage: int = 10 # урон пули
@export var bullet_gravity: float = 150  # Можно настроить гравитацию если нужно

var direction: Vector2 = Vector2.RIGHT
var velocity: Vector2 = Vector2.ZERO
var initial_position: Vector2

func _ready():
	# Инициализируем скорость в заданном направлении
	velocity = direction * initial_speed
	initial_position = global_position
	
	# Таймер для автоматического удаления пули
	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = lifetime
	add_child(timer)
	timer.timeout.connect(queue_free)
	timer.start()

	# Подключаем сигналы
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)
	
	# Поворачиваем пулю в направлении движения
	if velocity.length() > 0:
		rotation = velocity.angle()

func _physics_process(delta):
	# Применяем гравитацию (если нужно)
	velocity.y += bullet_gravity * delta
	position += velocity * delta
	
	# Проверяем, не улетела ли пуля слишком далеко
	if global_position.distance_to(initial_position) > 1000:
		queue_free()

func _on_area_entered(area):
	handle_collision(area)

func _on_body_entered(body):
	handle_collision(body)

func handle_collision(target):
	# Пуля наносит урон врагам
	if target.is_in_group("enemy"):
		if target.has_method("take_damage"):
			target.take_damage(damage)
		elif "health" in target:
			target.health -= damage
		queue_free()
	
	# Столкновение с землей/стенами
	elif target.is_in_group("ground") or target.is_in_group("wall"):
		queue_free()
