class_name IAPManager extends Node

signal unlock_new_skin
signal consume_purchase

var google_payment
var new_skin_sku: String = "new_player_skin"
var new_skin_token: String = ""


func _ready() -> void:
	if Engine.has_singleton("GodotGooglePlayBilling"):
		google_payment = Engine.get_singleton("GodotGooglePlayBilling")
		MyUtilities.add_log_msg("Android IAP is enabled")

		google_payment.connected.connect(_on_connected) # No params
		google_payment.disconnected.connect(_on_disconnected) # No params
		google_payment.connect_error.connect(_on_connect_error) # Response ID (int), Debug message (string)

		google_payment.sku_details_query_completed.connect(_on_product_details_query_completed) # Products (Dictionary[])
		google_payment.sku_details_query_error.connect(_on_product_details_query_error) # Response ID (int), Debug message (string), Queried SKUs (string[])

		google_payment.query_purchases_response.connect(_on_query_purchases_response) # QueryResponse (Dictionary[])

		google_payment.purchases_updated.connect(_on_purchases_updated) # Purchases (Dictionary[])
		google_payment.purchase_error.connect(_on_purchase_error) # Response ID (int), Debug message (string)

		google_payment.purchase_acknowledged.connect(_on_purchase_acknowledged) # Purchase token (string)
		google_payment.purchase_acknowledgement_error.connect(_on_purchase_acknowledgement_error) # Response ID (int), Debug message (string), Purchase token (string)

		google_payment.purchase_consumed.connect(_on_purchase_consumed) # Purchase token (string)
		google_payment.purchase_consumption_error.connect(_on_purchase_consumption_error) # Response ID (int), Debug message (string), Purchase token (string)

		google_payment.billing_resume.connect(_on_billing_resume) # No params
		google_payment.price_change_acknowledged.connect(_on_price_acknowledged) # Response ID (int)

		google_payment.startConnection()
	else:
		MyUtilities.add_log_msg("Android IAP is not available")


func purchase_skin() -> void:
	if google_payment:
		var response: Variant = google_payment.purchase(new_skin_sku)
		MyUtilities.add_log_msg("Purchase attempted, response " + str(response.status))
		if response.status != OK:
			MyUtilities.add_log_msg("Error on purchase: " + str(response.status))


func reset_purchases() -> void:
	if google_payment and not new_skin_token.is_empty():
		google_payment.consumePurchase(new_skin_token)


func _on_connected() -> void:
	MyUtilities.add_log_msg("Android IAP connected")
	# It's required to query product details before user can make purchases
	google_payment.querySkuDetails([new_skin_sku], "inapp")


func _on_disconnected() -> void:
	MyUtilities.add_log_msg("Android IAP disconnected")


func _on_connect_error(response_id: int, debug_message: String) -> void:
	MyUtilities.add_log_msg("Android IAP connection error: " + debug_message)


func _on_product_details_query_completed(products: Array) -> void:
	# This is called when querySkuDetails() completes
	MyUtilities.add_log_msg("Android IAP product details query completed")
	for product in products:
		MyUtilities.add_log_msg("Android IAP product sku: " + str(product.sku))
	
	# Now we can query all previously purchased items
	google_payment.queryPurchases("inapp")


func _on_product_details_query_error(response_id: int, debug_message: String, queried_skus: Array) -> void:
	MyUtilities.add_log_msg("Android IAP product details query error: " + debug_message)


func _on_query_purchases_response(query_result: Dictionary) -> void:
	# This is called when queryPurchases() completes
	MyUtilities.add_log_msg("Android IAP purchases query completed")
	if query_result.status == OK:
		var purchases: Array = query_result.purchases
		var purchase: Dictionary = purchases[0]
		var purchase_sku: String = purchase["skus"][0]
		if purchase_sku == new_skin_sku:
			new_skin_token = purchase.purchase_token
			if not purchase.is_acknowledged:
				google_payment.acknowledgePurchase(purchase.purchase_token)
			else:
				MyUtilities.add_log_msg("Unlocking previously purchased skin")
				unlock_new_skin.emit()
	else:
		MyUtilities.add_log_msg("Android IAP purchases query error: " + str(query_result.status))


func _on_purchases_updated(purchases: Array) -> void:
	if purchases.size() > 0:
		var purchase: Dictionary = purchases[0]
		var purchase_sku: String = purchase["skus"][0]
		MyUtilities.add_log_msg("Purchased item with sku: " + purchase_sku)
		if purchase_sku == new_skin_sku:
			new_skin_token = purchase.purchase_token
			google_payment.acknowledgePurchase(purchase.purchase_token)


func _on_purchase_error(response_id: int, debug_message: String) -> void:
	MyUtilities.add_log_msg("Android IAP purchase error: '%s' - ID %s" % [debug_message, response_id])


func _on_purchase_acknowledged(purchase_token: String) -> void:
	if purchase_token and new_skin_token == purchase_token:
		MyUtilities.add_log_msg("Android IAP purchase acknowledged: " + purchase_token)
		unlock_new_skin.emit()


func _on_purchase_acknowledgement_error(response_id: int, debug_message: String, purchase_token: String) -> void:
	MyUtilities.add_log_msg("Android IAP purchase acknowledgement error for " + purchase_token + ": " + debug_message)


func _on_purchase_consumed(purchase_token: String) -> void:
	MyUtilities.add_log_msg("Purchase consumed successfully")
	# consume_purchase.emit()


func _on_purchase_consumption_error(response_id: int, debug_message: String, purchase_token: String) -> void:
	MyUtilities.add_log_msg("Purchase consumption error (id: %s) for %s: %s" % [response_id, purchase_token, debug_message])


func _on_billing_resume() -> void:
	MyUtilities.add_log_msg("Billing resumed")


func _on_price_acknowledged(response_id: int) -> void:
	MyUtilities.add_log_msg("Android IAP price acknowledgement: " + str(response_id))
