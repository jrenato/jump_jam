class_name IAPManager extends Node


signal unlock_new_skin(skin_name: String)


func purchase_skin(skin_name: String) -> void:
	unlock_new_skin.emit(skin_name)
