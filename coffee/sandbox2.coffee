( ->
	# Locals
	$sandbox = null
	plasmid = null

	playTimer = false
	iterationSpeed = 60

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
			updateInfoSimulatneously()
			playTimer = setTimeout(play, iterationSpeed - plasmid.propagationTime)

	pause = ->
		if playTimer isnt false
			plasmid.stop()
			clearTimeout(playTimer)
			playTimer = false

	toggleIcon = ($button, iconStr1, iconStr2) ->
		now = $button.data('toggle')
		to = if now is iconStr1 then iconStr2 else iconStr1
		$button.children().eq(0).removeClass("glyphicon-" + now).addClass("glyphicon-" + to)
		$button.data('toggle', to)
		return now

	togglePlaying = ->
		if toggleIcon($('#sandbox-toggle'), 'play', 'pause') is 'play'
			play() 
		else
			pause()

	bindButtons = ->
		$('#sandbox-toggle').click ->
			togglePlaying()

		$('#sandbox-step').click ->
			plasmid.propagate()
			updateInfoSimulatneously()

		$('#sandbox-refresh').click ->
			resetSandbox()

		$('#sandbox-random').click ->
			total = plasmid.int(plasmid.row * plasmid.col / 4)

			for i in [0...total]
				row = plasmid.int(plasmid.rand() * plasmid.row) + 1
				col = plasmid.int(plasmid.rand() * plasmid.col) + 1
				plasmid.cells[row][col] = 1
			
			plasmid.render()

	# Sidemenu related methods.

	stopBeforeModification = ->
		if playTimer isnt false
			togglePlaying()

	updateInfo = ->
		startTime = plasmid.time()
		$('#query-propagation-time').text(plasmid.propagationTime)
		$('#query-update-time').text(plasmid.time() - startTime)

	updateInfoSimulatneously = ->
		if $('#update-simultaneously:checked').length > 0
			updateInfo()

	bindSidemenu = ->
		$('#iteration-speed').change ->
			iterationSpeed = plasmid.int($(this).val())
			if isNaN(iterationSpeed) then iterationSpeed = 60
			if iterationSpeed <= 0 then iterationSpeed = 1
			$(this).val(iterationSpeed)

		$('#sandbox-size-btn').click ->
			stopBeforeModification()
			size = plasmid.col
			newSize = plasmid.int($('#sandbox-size').val())
			# Check scale option.
			scale = $('#sandbox-size-scale:checked').length
			data = null
			if scale
				old = plasmid.dump(false, false)
				data = plasmid.matrix(newSize + 2, newSize + 2)
				# Scale the data.
				d = size / newSize
				c = 0.5 * (1 - d)
				scaleFunction = (x) -> Math.round(d * x + c)

				for i in [1..newSize]
					for j in  [1..newSize]
						data[i][j] = old[scaleFunction(i)][scaleFunction(j)]

			$sandbox.data('col', newSize).data('row', newSize)
			resetSandbox()

			if scale then plasmid.dump(data, false)

		$('#reverse-btn').click ->
			stopBeforeModification()
			data = plasmid.dump(false)
			size = plasmid.col
			for i in [1..size]
				for j in  [1..size]
					data[i][j] = 1 - data[i][j]
			plasmid.dump(data, false)

		$('#query-btn').click ->
			updateInfo()

		$('#sandbox-rule-btn').click ->
			$sandbox.data('rule', $('#sandbox-rule').val())
			resetSandbox()

	$ ->
		$sandbox = $('#sandbox')
		resetSandbox()
		bindButtons()
		bindSidemenu()
)()