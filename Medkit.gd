extends Area2D

@export var heal_amount: int = 25  # Количество восстанавливаемого HP

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		# Лечим игрока
		if body.has_method("heal"):
			body.heal(heal_amount)
		elif "health" in body:
			if body.has_method("heal"):  # Оңдоо: дагы бир текшерүү
				body.heal(heal_amount)
			elif body.get("health") != null and body.get("max_health") != null:
				body.health = min(body.health + heal_amount, body.max_health)
		
		# Эффект получения
		print("+", heal_amount, " HP!")
		
		# Удаляем аптечку
		queue_free()
