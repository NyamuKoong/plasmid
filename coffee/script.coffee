$(document).ready ->
	`_ca = []`
	$("div[data-ca]").each ->
		canvas = $(this)
		type = canvas.data("ca")
		if type is "1d" then ca = new Plasmid1D(canvas)
		else if type is "2d" then ca = new Plasmid2D(canvas)
		else ca = new PlasmidLL(canvas)
		_ca.push(ca);
	propagate = ->
		ca.propagate() for ca in _ca
		setTimeout(propagate, 100)
	propagate()