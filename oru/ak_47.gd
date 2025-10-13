extends Area2D

@onready var sprite = $AnimatedSprite2D  # ← Убедитесь, что имя совпадает!

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
		# Следим за мышкой
		var mouse_pos = get_global_mouse_position()
		var dir = (mouse_pos - global_position)
		
		# Поворачиваем ТОЛЬКО по вертикали (-90° до +90°)
		var angle = atan2(dir.y, abs(dir.x))
		rotation = angle
		
		# Отражаем спрайт, если мышь слева
		sprite.flip_h = (dir.x < 0)
		
		# Смещение от игрока (настройте под ваш спрайт)
		position = Vector2(-1, 0)

func attach_to_player():
	if not player or is_attached:
		return
	
	# Убираем из текущего родителя
	if get_parent():
		get_parent().remove_child(self)
	
	# Прикрепляем к игроку
	player.add_child(self)
	is_attached = true
	print("🎯 Оружие подобрано!")

func shoot():
	var bullet = preload("res://bullet.tscn").instantiate()
	bullet.global_position = global_position
	bullet.rotation = rotation
	bullet.direction = Vector2.RIGHT.rotated(rotation)
	
	# Добавляем пулю в сцену
	var scene = get_tree().current_scene
	if scene:
		scene.add_child(bullet)
