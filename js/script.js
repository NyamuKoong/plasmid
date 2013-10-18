$(document).ready(function(){
	_ca = [];
	$("div[data-ca]").each(function(){
		var canvas = $(this), ca;
		var type = canvas.data("ca");
		if(type == "1d") ca = new Plasmid1D(canvas);
		else if(type == "2d") ca = new Plasmid2D(canvas);
		else if(type == "ll") ca = new PlasmidLL(canvas);
		ca.initialize();
		_ca.push(ca);
	});
});