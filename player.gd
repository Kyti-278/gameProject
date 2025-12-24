extends CharacterBody2D

# Настройки движения
const SPEED = 300.0
const JUMP_VELOCITY = -500.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Статистика
var max_health: int = 100
var health: int = 100	
var coins: int = 0
var equipped_weapon: Node2D = null

# Ссылки на компоненты
@onready var anim = $AnimatedSprite2D

# UI элементы
var health_bar = null	
var coin_label = null


func _ready():
	add_to_group("player")
	call_deferred("_init_deferred")

func _init_deferred():
	init_ui()
	print("✅ Игрок готов! Для теста: SPACE - урон 20, UP - лечение 10, RIGHT - +5 монет")

func init_ui():
	var scene = get_tree().current_scene
	if not scene:
		print("⚠ Сцена не загружена для UI")
		return

	var health_bar_ui = scene.get_node_or_null("HealthBarUI")
	if health_bar_ui:
		health_bar = health_bar_ui.get_node_or_null("Control/hp")
		coin_label = health_bar_ui.get_node_or_null("Control/CoinLabel")
		
		if health_bar:
			health_bar.value = health
		if coin_label:
			coin_label.text = "Золото: " + str(coins)


func _physics_process(delta):
	if health <= 0:
		return  # Блокируем логику, если мёртв

	# Гравитация
	if not is_on_floor():
		velocity.y += gravity * delta

	# Прыжок
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Горизонтальное движение
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		if is_on_floor():
			anim.play("Walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor():
			anim.play("Idie")

	# Поворот спрайта
	if direction == -1:
		anim.flip_h = true
	elif direction == 1:
		anim.flip_h = false

	# Толкание ящиков
	if is_on_floor() and direction != 0:
		for i in range(get_slide_collision_count()):
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			if collider and collider.is_in_group("box") and collider is RigidBody2D:
				collider.apply_impulse(Vector2.ZERO, Vector2(direction, 0) * 100)

	move_and_slide()

# Получение урона
func take_damage(amount: int):
	if health <= 0: 
		return
	
	health = max(0, health - amount)
	if health_bar:
		health_bar.value = health
	
	if health <= 0:
		die()

# Лечение
func heal(amount: int):
	if health <= 0:
		return
	health = min(max_health, health + amount)
	if health_bar:
		health_bar.value = health

# Золото
func add_coins(amount: int):
	coins += amount
	SaveData.coins = coins 
	if coin_label:
		coin_label.text = "Золото: " + str(coins)
# Смерть — ГЛАВНОЕ ИЗМЕНЕНИЕ
		return
	
func die():
	if health > 0:
		print("💀 Игрок умер!")
	# Останавливаем управление
	SaveData.save_game()
	set_process(false)
	set_physics_process(false)
	
	# Отключаем паузу, если была включена (на всякий случай)
	get_tree().paused = false
	
	# ПЕРЕХОД К СЦЕНЕ GAME OVER
	get_tree().change_scene_to_file("res://GameOver.tscn")

# Кнопки
func _on_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://menu.tscn")

func _on_restart_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

# Оружие
func equip_weapon(weapon_node):
	if weapon_node is Node2D:
		equipped_weapon = weapon_node

func unequip_weapon():
	equipped_weapon = null
