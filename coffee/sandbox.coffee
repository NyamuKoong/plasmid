$(document).ready ->
	`_ca = new PlasmidLL($("#sandbox"))`
	`_dragging = false`
	toggle = (cell) ->
		col = cell.index() + 1
		row = cell.parent().index() + 1
		val = _ca.cells[row][col]
		_ca.cells[row][col] = +!val
		_ca.render()
	bind = ->
		cells = $("#sandbox").children().children()
		cells.mousedown ->
			`_dragging = true`
			toggle($(this))
		cells.mouseup ->
			`_dragging = false`
		cells.mouseover ->
			if _dragging
				toggle($(this))
	bind()
	propagate = ->
		`_ca.propagate()`
		`_timer = setTimeout(propagate, 100)`
	$("#sandbox-toggle").click ->
		now = $(this).data("toggle")
		to = if now is "play" then "pause" else "play"
		icon = $($(this).children()[0])
		icon.removeClass("glyphicon-" + now).addClass("glyphicon-" + to)
		$(this).data("toggle", to)
		if now is "play"
			propagate()
		else
			clearTimeout(_timer)
	$("#sandbox-step").click ->
		_ca.propagate()
	$("#sandbox-refresh").click ->
		_ca.refresh()
		bind()
	$("#sandbox-random").click ->
		total = _ca.int(_ca.row*_ca.col/4)
		for i in [0...total] by 1
			row = _ca.int(_ca.rand()*_ca.row)+1
			col = _ca.int(_ca.rand()*_ca.col)+1
			_ca.cells[row][col] = 1
		_ca.render()