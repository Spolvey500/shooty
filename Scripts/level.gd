extends Node2D

@onready var player:CharacterBody2D = $Player
@onready var basic_enemy:= preload("res://Scenes/enemy.tscn")

@export var min_spawn_distance:float
@export var max_spawn_distance:float

@export var current_phase:int = 0
@export var phase_change_rate:float
@export var phase_timer:Timer

@export var basic_enemy_timer:Timer
@export var max_basic_enemy:int #to implement

@export_category("Initial Spawn rates")
@export var basic_enemy_spawn_rate:float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	
	basic_enemy_timer.wait_time = basic_enemy_spawn_rate
	basic_enemy_timer.start()
	phase_timer.wait_time = phase_change_rate
	phase_timer.start()

func _on_basic_enemy_timeout() -> void:
	spawn_enemy(basic_enemy)

func _on_phase_timer_timeout() -> void:
	change_phase()

func spawn_enemy(enemy_scene:Resource):
	var enemy = enemy_scene.instantiate()
	add_child(enemy)
	enemy.player = player
	var random_dir = (Vector2(randf() * (randi_range(0,1)*2-1), 
		randf() * (randi_range(0,1)*2-1)).normalized())
	var random_distance = randf_range(min_spawn_distance, max_spawn_distance)
	enemy.global_position = player.global_position + random_dir * random_distance
	print("spawned enemy at: " + str(enemy.global_position))

func change_phase(to_phase:int = current_phase + 1):
	current_phase = to_phase
	
	basic_enemy_timer.wait_time = maxf(basic_enemy_spawn_rate - (0.2 * current_phase), 1)
