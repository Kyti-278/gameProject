extends Area2D

@onready var sprite = $AnimatedSprite2D

var is_attached = false
var player = null

func _on_body_entered(body):
	if body.name == "Player":
		player = body
		print("Игрок рядом! Нажмите E")

func _on_body_exited(body):
	if body.name == "Player":
		player = null

func _unhandled_input(event):
	if event.is_action_pressed("pickup") and player and not is_attached:
		attach_to_player()

func _input(event):
	if is_attached and event.is_action_pressed("shoot"):
		shoot()

func _process(delta):
	if is_attached and player:
		# Получаем позицию мыши
		var mouse_pos = get_global_mouse_position()
		
		# Вычисляем направление от игрока к мыши
		var dir_to_mouse = (mouse_pos - player.global_position).normalized()
		
		# Поворачиваем оружие
		rotation = dir_to_mouse.angle()
		
		# Определяем, с какой стороны от игрока находится мышь
		var is_mouse_left = mouse_pos.x < player.global_position.x
		
		# Позиционируем оружие относительно игрока
		var offset = Vector2(-2, 4)  # Настройте под ваш спрайт
		
		# Убираем отражение спрайта - используем только поворот
		sprite.flip_h = false
		
		# Позиционируем оружие всегда справа от игрока
		# но корректируем позицию по Y в зависимости от направления
		position = offset

func attach_to_player():
	if not player or is_attached:
		return
	
	# Убираем из текущего родителя
	if get_parent():
		get_parent().remove_child(self)
	
	# Прикрепляем к игроку
	player.add_child(self)
	is_attached = true
	player.equipped_weapon = self
	print("🎯 Оружие подобрано!")

func shoot():
	var bullet = preload("res://ITEM/BULLET/bullet.tscn").instantiate()
	
	# Устанавливаем позицию пули
	bullet.global_position = global_position
	
	# Определяем направление стрельбы
	var shoot_direction = Vector2(cos(rotation), sin(rotation))
	bullet.direction = shoot_direction
	
	# Добавляем пулю в сцену
	get_tree().current_scene.add_child(bullet)
	
	print("Выстрел в направлении: ", bullet.direction)
