class_name IAPManager extends Node

signal unlock_new_skin

var google_payment
var new_skin_sku: String = "new_player_skin"
var new_skin_token: String = ""


func _ready() -> void:
	if Engine.has_singleton("GodotGooglePlayBilling"):
		google_payment = Engine.get_singleton("GodotGooglePlayBilling")
		Signals.add_log_msg("Android IAP is enabled")

		google_payment.connected.connect(_on_connected) # No params
		google_payment.disconnected.connect(_on_disconnected) # No params
		google_payment.connect_error.connect(_on_connect_error) # Response ID (int), Debug message (string)

		google_payment.sku_details_query_completed.connect(_on_product_details_query_completed) # Products (Dictionary[])
		google_payment.sku_details_query_error.connect(_on_product_details_query_error) # Response ID (int), Debug message (string), Queried SKUs (string[])

		google_payment.purchases_updated.connect(_on_purchases_updated) # Purchases (Dictionary[])
		google_payment.purchase_error.connect(_on_purchase_error) # Response ID (int), Debug message (string)

		google_payment.query_purchases_response.connect(_on_query_purchases_response) # Purchases (Dictionary[])

		google_payment.billing_resume.connect(_on_billing_resume) # No params
		google_payment.price_change_acknowledged.connect(_on_price_acknowledged) # Response ID (int)
		google_payment.purchase_acknowledged.connect(_on_purchase_acknowledged) # Purchase token (string)
		google_payment.purchase_acknowledgement_error.connect(_on_purchase_acknowledgement_error) # Response ID (int), Debug message (string), Purchase token (string)
		google_payment.purchase_consumed.connect(_on_purchase_consumed) # Purchase token (string)
		google_payment.purchase_consumption_error.connect(_on_purchase_consumption_error) # Response ID (int), Debug message (string), Purchase token (string)

		google_payment.startConnection()
	else:
		Signals.add_log_msg("Android IAP is not available")


func purchase_skin() -> void:
	if google_payment:
		var response: Variant = google_payment.purchase(new_skin_sku)
		Signals.add_log_msg("Purchase attempted, response " + str(response.status))
		if response.status != OK:
			Signals.add_log_msg("Error on purchase: " + str(response.status))


func _on_connected() -> void:
	Signals.add_log_msg("Android IAP connected")
	google_payment.querySkuDetails([new_skin_sku], "inapp")


func _on_disconnected() -> void:
	Signals.add_log_msg("Android IAP disconnected")


func _on_connect_error(response_id: int, debug_message: String) -> void:
	Signals.add_log_msg("Android IAP connection error: " + debug_message)


func _on_product_details_query_completed(skus: Array) -> void:
	Signals.add_log_msg("Android IAP product details query completed")
	for sku in skus:
		Signals.add_log_msg("Android IAP product sku: " + str(sku))


func _on_product_details_query_error(response_id: int, debug_message: String, queried_skus: Array) -> void:
	Signals.add_log_msg("Android IAP product details query error: " + debug_message)


func _on_purchases_updated(purchases: Array) -> void:
	if purchases.size() > 0:
		var purchase: Dictionary = purchases[0]
		var purchase_sku: String = purchase["skus"][0]
		Signals.add_log_msg("Purchased item with sku: " + purchase_sku)
		if purchase_sku == new_skin_sku:
			new_skin_token = purchase.purchase_token
			google_payment.acknowledgePurchase(purchase.purchase_token)


func _on_purchase_error(response_id: int, debug_message: String) -> void:
	Signals.add_log_msg("Android IAP purchase error: '%s' - ID %s" % [debug_message, response_id])


func _on_billing_resume() -> void:
	Signals.add_log_msg("Billing resumed")


func _on_price_acknowledged(response_id: int) -> void:
	Signals.add_log_msg("Android IAP price acknowledgement: " + str(response_id))


func _on_purchase_acknowledged(purchase_token: String) -> void:
	if purchase_token and new_skin_token == purchase_token:
		Signals.add_log_msg("Android IAP purchase acknowledged: " + purchase_token)
		unlock_new_skin.emit()


func _on_purchase_acknowledgement_error(response_id: int, debug_message: String, purchase_token: String) -> void:
	Signals.add_log_msg("Android IAP purchase acknowledgement error for " + purchase_token + ": " + debug_message)


func _on_purchase_consumed(purchase_token: String) -> void:
	Signals.add_log_msg("Android IAP purchase consumed: " + purchase_token)


func _on_purchase_consumption_error(response_id: int, debug_message: String, purchase_token: String) -> void:
	Signals.add_log_msg("Android IAP purchase consumption error: " + debug_message)


func _on_query_purchases_response(purchases: Array) -> void:
	Signals.add_log_msg("Android IAP query purchases response: " + str(purchases))
