@tool
extends Node2D
@export var array = [Vector3()]
@export var pos_z = 0

func _process(_delta): queue_redraw()

func _draw():
	if Engine.is_editor_hint():
		draw_colored_polygon(array, Color(1,1,1,0.2))
		
		for n in array.size():
			draw_set_transform(Vector2(), 0, Vector2(1,1))
			var m = n+1 if (n < array.size()-1) else 0
			draw_texture(load("res://pixel.png"), Vector2(array[n].x-0.5, array[n].y-0.5), Color(1,1,1,0.5))
			
			draw_line(Vector2(array[n].x, array[n].y), Vector2(array[m].x, array[m].y), Color(), 0.2)
			
			draw_set_transform(Vector2(), 0, Vector2(0.1,0.1))
			draw_string(ThemeDB.fallback_font, Vector2(array[n].x, array[n].y)*10, str(n))
