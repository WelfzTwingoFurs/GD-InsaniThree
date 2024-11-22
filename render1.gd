@tool
extends Node2D
@export var rend_scale = 100
@export var pos_z = 1

func _process(_delta):
	if !Engine.is_editor_hint():
		position += Vector2(Input.get_axis("ui_left","ui_right")*10, Input.get_axis("ui_page_down","ui_page_up"))
		pos_z -= Input.get_axis("ui_down","ui_up")
	
	
	queue_redraw()

func _draw():
	if !Engine.is_editor_hint():
		DisplayServer.window_set_title(str(Engine.get_frames_per_second())) #draw_string(ThemeDB.fallback_font, -DisplayServer.window_get_size()/2.1, str(Engine.get_frames_per_second()))
		
		#What if Z gets processed before render? Using 'draw' there's no Z-Layers, first come first served sorta deal. So organize the order they come in, d!
		draw_set_transform(Vector2(), 0, Vector2(1,1))
		for OBJ in get_tree().get_nodes_in_group("poly"): 
			var poly_array = []
			
			for VERT in OBJ.array:#Main shape
				poly_array.append(Vector2(OBJ.position.x+VERT.x-position.x, OBJ.position.y+VERT.y+position.y -OBJ.pos_z+VERT.z -pos_z) / (-OBJ.position.y-VERT.y-position.y)*rend_scale)
			
			if OBJ.array.size() == 4: draw_colored_polygon(poly_array, Color(1,1,1), [Vector2(1,1), Vector2(0,1), Vector2(0,0), Vector2(1,0)], load("res://wallfenstein.png"))
			else: draw_colored_polygon(poly_array, Color(1,1,1), [])
			
			for L in poly_array.size():#Outline
				draw_line(poly_array[L], poly_array[L+1 if (L < poly_array.size()-1) else 0], Color(), 3)
		
		
		for OBJ in get_tree().get_nodes_in_group("sprite"):
			if OBJ.hv_size == Vector2(1,1):
				if OBJ.scale_div == 1:
					draw_set_transform(Vector2(), 0, Vector2(1,1) / (-OBJ.position.y-position.y)*rend_scale)
					draw_texture(OBJ.sprite, Vector2(OBJ.position.x-position.x, OBJ.position.y+position.y -OBJ.pos_z -pos_z) - (OBJ.sprite.get_size()/2), Color(1,1,0))
				
				else:#more code but less maths... would it be faster? Separating more complex requests.....
					draw_set_transform(Vector2(), 0, Vector2(1,1) / (-OBJ.position.y-position.y)*(rend_scale/OBJ.scale_div))
					draw_texture(OBJ.sprite, (Vector2(OBJ.position.x-position.x, OBJ.position.y+position.y -OBJ.pos_z -pos_z)*OBJ.scale_div) - (OBJ.sprite.get_size()/2), Color(1,0,1))
				
			else:#Using textured polygon to simulate sprite frames
				draw_set_transform(Vector2(), 0, Vector2(1,1) / (-OBJ.position.y-position.y)*(rend_scale/OBJ.scale_div))
				
				var center = (Vector2(OBJ.position.x-position.x, OBJ.position.y+position.y -OBJ.pos_z -pos_z)*OBJ.scale_div)
				var border = (OBJ.sprite.get_size()/OBJ.hv_size) 
				
				var fram = Vector2(1,1)/OBJ.hv_size
				draw_colored_polygon(
					#[center-border, center-Vector2(-border.x,border.y), center+border, center-Vector2(border.x,-border.y)], Color(1,1,1),
					#[center-Vector2(border.x,border.y*2), center-Vector2(-border.x,border.y*2), center+Vector2(border.x,0), center-Vector2(border.x,0)], Color(1,1,1),
					[Vector2(center.x-border.x, center.y-border.y*2), Vector2(center.x+border.x, center.y-border.y*2), Vector2(center.x+border.x, center.y), Vector2(center.x-border.x, center.y)], Color(1,1,1),
					[fram*OBJ.hv_position, fram*OBJ.hv_position +Vector2(fram.x,0), fram*OBJ.hv_position +fram,  fram*OBJ.hv_position +Vector2(0,fram.y)], OBJ.sprite)

















