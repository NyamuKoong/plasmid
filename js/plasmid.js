$(document).ready(function(){
	setupLayout();
	// setupEasy();
});

function setupLayout()
{
	
}

/*
function setupEasy()
{
	$("#ca-easy-create").click(function(event){
		var steps = parseInt($("#ca-easy-steps").val());
		var cells = parseInt($("#ca-easy-cells").val());
		var map = $("#ca-easy-map");
		map.empty();
		for(var i = 0; i < steps; i++)
		{
			var step = $("<div>");
			step.addClass("ca-step");
			step.attr("step", i);
			var cellWidth = 100 / cells;
			for(var j = 0; j < cells; j++)
			{
				var cell = $("<div>");
				cell.addClass("ca-cell");
				if(i == 0 && j == parseInt(cells / 2))
				{
					cell.addClass("ca-cell-on");
					cell.attr("state", 1);
				}
				else
				{
					cell.addClass("ca-cell-off");
					cell.attr("state", 0);
				}
				cell.attr("cell", j);
				cell.css("width", cellWidth + "%");
				step.append(cell);
			}
			map.append(step);
		}
	});
	$("#ca-easy-apply").click(function(event){
		pattern = [];
		var rule = $("#ca-easy-rule").attr("rule");
		var cells = parseInt($("#ca-easy-cells").val());
		var onCells = $("#ca-easy-map .ca-cell-on");
		onCells.attr("state", 0);
		onCells.removeClass("ca-cell-on");
		onCells.addClass("ca-cell-off");
		var initCell = $("#ca-easy-map .ca-step[step=0] .ca-cell[cell="+ parseInt(cells / 2) +"]");
		initCell.addClass("ca-cell-on");
		initCell.attr("state", 1);
		if(rule == "pattern")
		{
			$("#ca-easy-pattern input").each(function(){
				pattern.push(parseInt($(this).val()));
			});
		}
		else
		{
			var ruleNumber = parseInt($("#ca-easy-number input").val());
			for(var i = 0; i < 8; i++)
			{
				pattern.push(ruleNumber % 2);
				ruleNumber = parseInt(ruleNumber / 2);
			}
			pattern.reverse();
		}
		$("#ca-easy-map").attr("step", 0);
	});
	$("#ca-easy-step").click(function(event){
		var currentStep = parseInt($("#ca-easy-map").attr("step"));
		currentStep += 1;
		$("#ca-easy-map").attr("step", currentStep);
		var cells = parseInt($("#ca-easy-cells").val());
		var step = $("#ca-easy-map .ca-step[step=" + currentStep + "]");
		var previousStep = $("#ca-easy-map .ca-step[step=" + (currentStep - 1) + "]");
		for(var i = 1; i < cells - 1; i++)
		{
			var cell = step.find(".ca-cell[cell=" + i + "]");
			var left = parseInt(previousStep.find(".ca-cell[cell=" + (i - 1) + "]").attr("state"));
			var mid = parseInt(previousStep.find(".ca-cell[cell=" + i + "]").attr("state"));
			var right = parseInt(previousStep.find(".ca-cell[cell=" + (i + 1) + "]").attr("state"));
			var currentPattern = 4 * left + 2 * mid + right;
			if(pattern[currentPattern])
			{
				cell.removeClass("ca-cell-off");
				cell.addClass("ca-cell-on");
				cell.attr("state", 1);
			}
		}
	});
	$("#ca-easy-rule .nav-tabs a").click(function(event){
		event.preventDefault();
		$(this).tab("show");
		var target = $(this).attr("href");
		$("#ca-easy-rule").attr("rule", $(target).attr("rule"));
	});
	
}
*/