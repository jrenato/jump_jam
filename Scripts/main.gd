extends Node

var game_in_progress: bool = false

#var ads_enabled: bool = true
#var interstitial_ad : InterstitialAd
#var interstitial_ad_load_callback := InterstitialAdLoadCallback.new()

@onready var game: Node2D = %Game
@onready var screens: CanvasLayer = %Screens
@onready var iap_manager: IAPManager = %IAPManager


func _ready() -> void:
	DisplayServer.window_set_window_event_callback(_on_window_event)

	#if Engine.has_singleton("PoingGodotAdMob"):
		#MyUtilities.add_log_msg("Initializing MobileAds")
		#MobileAds.initialize()
		#interstitial_ad_load_callback.on_ad_failed_to_load = _on_interstitial_ad_failed_to_load
		#interstitial_ad_load_callback.on_ad_loaded = _on_interstitial_ad_loaded
		#load_interstitial_ad()
	#else:
		#MyUtilities.add_log_msg("MobileAds not available")

	screens.start_game.connect(_on_start_game)
	screens.delete_level.connect(_on_delete_level)
	game.game_over.connect(_on_game_over)
	game.pause_game.connect(_on_game_pause_game)

	# IAP signals
	screens.purchase_skin.connect(_on_screens_purchase_skin)
	screens.reset_purchases.connect(_on_screens_reset_purchases)
	iap_manager.unlock_new_skin.connect(_on_iap_manager_unlock_new_skin)
	#iap_manager.consume_purchase.connect(_on_iap_manager_consume_purchase)


#func load_interstitial_ad() -> void:
	#if not Engine.has_singleton("PoingGodotAdMob"):
		#return
#
	#var unit_id : String
	#if OS.get_name() == "Android":
		#unit_id = "ca-app-pub-3940256099942544/1033173712"
	#elif OS.get_name() == "iOS":
		#unit_id = "ca-app-pub-3940256099942544/4411468910"
#
	#if interstitial_ad:
		## Always call this method on all AdFormats to free memory on Android/iOS
		#interstitial_ad.destroy()
		#interstitial_ad = null
#
	#InterstitialAdLoader.new().load(unit_id, AdRequest.new(), interstitial_ad_load_callback)


#func show_interstitial_ad():
	#if not Engine.has_singleton("PoingGodotAdMob"):
		#return
#
	#if interstitial_ad:
		#interstitial_ad.show()
#
	#load_interstitial_ad()


func _on_start_game() -> void:
	game_in_progress = true
	game.new_game()


func _on_game_over(score: int, high_score: int) -> void:
	game_in_progress = false
	screens.game_over(score, high_score)
	#if ads_enabled and Engine.has_singleton("PoingGodotAdMob"):
		#show_interstitial_ad()


func _on_delete_level() -> void:
	game_in_progress = false
	game.reset_game()


func _on_game_pause_game() -> void:
	get_tree().paused = true
	screens.pause_game()


func _on_window_event(event: int) -> void:
	match event:
		DisplayServer.WINDOW_EVENT_FOCUS_OUT:
			# Pause game if it's in progress and not already paused
			if game_in_progress and not get_tree().paused:
				_on_game_pause_game()
				MyUtilities.add_log_msg("Lost focus, pausing the game")
		DisplayServer.WINDOW_EVENT_CLOSE_REQUEST:
			get_tree().quit()


# IAP Signals
func _on_screens_purchase_skin() -> void:
	iap_manager.purchase_skin()


func _on_screens_reset_purchases() -> void:
	iap_manager.reset_purchases()


func _on_iap_manager_unlock_new_skin() -> void:
	if not game.new_skin_unlocked:
		game.new_skin_unlocked = true
		MyUtilities.add_log_msg("New skin unlocked")
		# For testing purposes
		#ads_enabled = false


#func _on_iap_manager_consume_purchase() -> void:
	#if game.new_skin_unlocked:
		#game.new_skin_unlocked = false
		## For testing purposes
		#MyUtilities.add_log_msg("Disabling ads")
		##ads_enabled = true


#func _on_interstitial_ad_failed_to_load(adError : LoadAdError) -> void:
	#interstitial_ad = null
#
#
#func _on_interstitial_ad_loaded(_interstitial_ad : InterstitialAd) -> void:
	#interstitial_ad = _interstitial_ad
