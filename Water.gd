extends Sprite
tool

func ready() -> void:
	material.set_shader_param("sprite_scale", scale)