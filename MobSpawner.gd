extends Node2D

@export var mob_scene: PackedScene
@export var min_spawn_time: float = 2.0
@export var max_spawn_time: float = 5.0
@export var spawn_area: Rect2 = Rect2(-100, -100, 200, 200)
@export var max_mobs: int = 10

var mob_count: int = 0

func _ready():
	# Запускаем первый спавн
	start_spawn_timer()
		
	if mob_scene == null:
		mob_scene = preload("res://characters/mobs/zomdie.tscn")

func start_spawn_timer():
	var spawn_delay = randf_range(min_spawn_time, max_spawn_time)
	# Используем встроенный метод создания таймера
	var timer = get_tree().create_timer(spawn_delay)
	timer.timeout.connect(_on_spawn_timer_timeout)

func _on_spawn_timer_timeout():
	if mob_count < max_mobs:
		spawn_mob()
	
	start_spawn_timer()

func spawn_mob():
	if mob_scene == null:
		return
		
	var mob = mob_scene.instantiate()
	get_parent().add_child(mob)
	
	var spawn_x = randf_range(spawn_area.position.x, spawn_area.position.x + spawn_area.size.x)
	var spawn_y = randf_range(spawn_area.position.y, spawn_area.position.y + spawn_area.size.y)
	mob.global_position = global_position + Vector2(spawn_x, spawn_y)
	
	# Простое подключение без сложных проверок
	if mob.has_signal("died"):
		mob.died.connect(_on_mob_died)
	
	mob_count += 1
	print("Создан моб. Всего мобов: ", mob_count)

func _on_mob_died():
	mob_count -= 1
	print("Моб умер. Всего мобов: ", mob_count)
func _draw():
	# Рисуем область спавна (красный прямоугольник)
	draw_rect(spawn_area, Color(1, 0, 0, 0.3), true)
	# Рисуем контур области спавна
	draw_rect(spawn_area, Color(1, 0, 0, 1), false, 2.0)
	
