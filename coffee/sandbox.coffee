$(document).ready ->
	# $("#sandbox-toggle").click ->
		# console.log 1
	$("#sandbox-step").click ->
		ca.propagate() for ca in _ca
	$("#sandbox-refresh").click ->
		ca.refresh() for ca in _ca
	# propagate = ->
		# ca.propagate() for ca in _ca
		# setTimeout(propagate, 100)
	# propagate()