@tool
extends Node2D
@export var spritepath = "res://glueeater.png"
@export var hv_size = Vector2(1,1)
@export var hv_position = Vector2(0,0)
@export var scale_div = 1
@export var pos_z = 0
var sprite 

func _ready(): sprite = load(spritepath)

#var faketimer = 0
func _process(_delta):
	queue_redraw()
	
	#if !Engine.is_editor_hint():
		#if hv_position != null:
			#if faketimer == 0:
				#hv_position.x += 1
				#if hv_position.x > hv_size.x:
					#hv_position.x = 0
					#hv_position.y += 1
				#
				#if hv_position.y > hv_size.y:
					#hv_position = Vector2(0,0)
				#
				#faketimer = 10
			#
			#else:
				#faketimer -= 1

#func _draw(): if Engine.is_editor_hint(): draw_texture(load(sprite), position-(load(sprite).get_size()/2), Color(1,1,1,0.5))
func _draw():
	if Engine.is_editor_hint():
		draw_set_transform(Vector2(), 0, Vector2(1,1)*1/sprite.get_size())
		draw_texture(sprite, -sprite.get_size()/2, Color(1,1,1,0.5))
