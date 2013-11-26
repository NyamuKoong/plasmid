# Locals
$sandbox = null
plasmid = null
playTimer = false

# Flags
draggingFlag = false

# Sandbox related methods.
bindPlasmid = ->
	toggle = (e, reset = false) ->
		plasmid.toggleCellIfNew(e.offsetX, e.offsetY, reset)

	$canvas = $sandbox.children('canvas')

	$canvas.mousedown( ->
		draggingFlag = true
		toggle(event, true)
	).mouseup( ->
		draggingFlag = false
	).mousemove( (event) ->
		if draggingFlag then toggle(event)
	)

resetSandbox = ->
	plasmid = new CanvasWorkerPlasmidLL($sandbox)
	bindPlasmid()

# Top menu related methods.
play = ->
	plasmid.propagate ->
		playTimer = setTimeout(play, 60)

pause = ->
	if playTimer isnt false
		clearTimeout(playTimer)
		playTimer = false

toggleIcon = ($button, iconStr1, iconStr2) ->
	now = $button.data('toggle')
	to = if now is iconStr1 then iconStr2 else iconStr1
	$button.children().eq(0).removeClass("glyphicon-" + now).addClass("glyphicon-" + to)
	$button.data('toggle', to)
	return now

bindButtons = ->
	$('#sandbox-toggle').click ->
		if toggleIcon($(this), 'play', 'pause') is 'play'
			play() 
		else
			pause()

	$('#sandbox-step').click ->
		plasmid.propagate()

	$('#sandbox-refresh').click ->
		plasmid.refresh()

	$('#sandbox-random').click ->
		total = plasmid.int(plasmid.row * plasmid.col / 4)

		for i in [0...total]
			row = plasmid.int(plasmid.rand() * plasmid.row) + 1
			col = plasmid.int(plasmid.rand() * plasmid.col) + 1
			plasmid.cells[row][col] = 1
		
		plasmid.render()

	$('.sandbox-rule').click ->
		$sandbox.data("rule", $(this).text())
		resetSandbox()

$ ->
	$sandbox = $('#sandbox')
	resetSandbox()
	bindButtons()