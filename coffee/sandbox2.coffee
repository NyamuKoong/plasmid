$(document).ready ->
	_ca = new CanvasWorkerPlasmidLL($("#sandbox"))
	_dragging = false
	_timer = false
	_playing = false

	toggle = (e) ->
		_ca.toggleCellIfNew(e.offsetX, e.offsetY)

	bind = ->
		$canvas = $("#sandbox > canvas")
		$canvas.mousedown( ->
			_dragging = true
			toggle(event)
		).mouseup( ->
			_dragging = false
		).mousemove( (event) ->
			if _dragging
				toggle(event)
		)

	bind()
	
	play = ->
		_playing = true
		reset = ->
			_timer = setTimeout(play, 60)

		_ca.propagate(reset)

	pause = ->
		if _playing
			_playing = false
			clearTimeout(_timer)

	$("#sandbox-toggle").click ->
		now = $(this).data("toggle")
		to = if now is "play" then "pause" else "play"
		icon = $($(this).children()[0])
		icon.removeClass("glyphicon-" + now).addClass("glyphicon-" + to)
		$(this).data("toggle", to)
		if now is "play" then play() else pause()

	$("#sandbox-step").click ->
		if not _playing
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

	$(".sandbox-rule").click ->
		rule = $(this).text()
		sandbox = $("#sandbox")
		sandbox.data("rule", rule)
		_ca = new CanvasWorkerPlasmidLL($("#sandbox"))
		bind()