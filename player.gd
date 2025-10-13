extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -500.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var anim = $AnimatedSprite2D

var health = 100
var equipped_weapon: Node2D = null

func _physics_process(delta):
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
		if is_on_floor():  # Исправлено: проверка на земле, а не velocity.y == 0
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

	# Смерть
	if health <= 0:
		queue_free()
		get_tree().change_scene_to_file("res://menu.tscn")

	move_and_slide()

	# --- поворот оружия за мышкой ---
	if equipped_weapon:
		var mouse_pos = get_global_mouse_position()
		var dir = (mouse_pos - global_position).normalized()
		equipped_weapon.rotation = dir.angle()
