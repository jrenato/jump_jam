class_name IAPManager extends Node

signal unlock_new_skin(skin_name: String)

# Matches BillingClient.ConnectionState in the Play Billing Library
enum ConnectionState {
	DISCONNECTED, # not yet connected to billing service or was already closed
	CONNECTING, # currently in process of connecting to billing service
	CONNECTED, # currently connected to billing service
	CLOSED, # already closed and shouldn't be used again
}

var google_payment


func _ready() -> void:
	if Engine.has_singleton("GodotGooglePlayBilling"):
		google_payment = Engine.get_singleton("GodotGooglePlayBilling")
		Signals.add_log_msg("Android IAP is available")

		google_payment.connected.connect(_on_connected) # No params
		google_payment.disconnected.connect(_on_disconnected) # No params
		google_payment.connect_error.connect(_on_connect_error) # Response ID (int), Debug message (string)

		google_payment.billing_resume.connect(_on_billing_resume) # No params
		google_payment.price_change_acknowledged.connect(_on_price_acknowledged) # Response ID (int)
		google_payment.purchases_updated.connect(_on_purchases_updated) # Purchases (Dictionary[])
		google_payment.purchase_error.connect(_on_purchase_error) # Response ID (int), Debug message (string)
		google_payment.sku_details_query_completed.connect(_on_product_details_query_completed) # Products (Dictionary[])
		google_payment.sku_details_query_error.connect(_on_product_details_query_error) # Response ID (int), Debug message (string), Queried SKUs (string[])
		google_payment.purchase_acknowledged.connect(_on_purchase_acknowledged) # Purchase token (string)
		google_payment.purchase_acknowledgement_error.connect(_on_purchase_acknowledgement_error) # Response ID (int), Debug message (string), Purchase token (string)
		google_payment.purchase_consumed.connect(_on_purchase_consumed) # Purchase token (string)
		google_payment.purchase_consumption_error.connect(_on_purchase_consumption_error) # Response ID (int), Debug message (string), Purchase token (string)
		google_payment.query_purchases_response.connect(_on_query_purchases_response) # Purchases (Dictionary[])

		google_payment.startConnection()
	else:
		Signals.add_log_msg("Android IAP is not available")


func _on_connected() -> void:
	Signals.add_log_msg("Android IAP connected")


func _on_disconnected() -> void:
	Signals.add_log_msg("Android IAP disconnected")


func _on_connect_error(response_id: int, debug_message: String) -> void:
	Signals.add_log_msg("Android IAP connection error: " + debug_message)


func purchase_skin(skin_name: String) -> void:
	unlock_new_skin.emit(skin_name)


func _on_billing_resume() -> void:
	Signals.add_log_msg("Billing resumed")


func _on_price_acknowledged(response_id: int) -> void:
	Signals.add_log_msg("Android IAP price acknowledgement: " + str(response_id))


func _on_purchases_updated(purchases: Array) -> void:
	Signals.add_log_msg("Android IAP purchases updated: " + str(purchases))


func _on_purchase_error(response_id: int, debug_message: String) -> void:
	Signals.add_log_msg("Android IAP purchase error: " + debug_message)


func _on_product_details_query_completed(products: Array) -> void:
	Signals.add_log_msg("Android IAP product details query completed: " + str(products))


func _on_product_details_query_error(response_id: int, debug_message: String, queried_skus: Array) -> void:
	Signals.add_log_msg("Android IAP product details query error: " + debug_message)


func _on_purchase_acknowledged(purchase_token: String) -> void:
	Signals.add_log_msg("Android IAP purchase acknowledged: " + purchase_token)


func _on_purchase_acknowledgement_error(response_id: int, debug_message: String, purchase_token: String) -> void:
	Signals.add_log_msg("Android IAP purchase acknowledgement error: " + debug_message)


func _on_purchase_consumed(purchase_token: String) -> void:
	Signals.add_log_msg("Android IAP purchase consumed: " + purchase_token)


func _on_purchase_consumption_error(response_id: int, debug_message: String, purchase_token: String) -> void:
	Signals.add_log_msg("Android IAP purchase consumption error: " + debug_message)


func _on_query_purchases_response(purchases: Array) -> void:
	Signals.add_log_msg("Android IAP query purchases response: " + str(purchases))
