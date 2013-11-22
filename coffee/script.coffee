$(document).ready ->
	propagate = ->
		ca.propagate() for ca in _ca
		setTimeout(propagate, 100)
	propagate()