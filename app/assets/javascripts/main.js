$(document).ready(function() {
	$(".form-group").keyup(function() {
		$(".form-group .help-block").hide();
		$(".form-group").removeClass("has-error");
	});
	$("#submit_btn").click(function() {
		var isValid = false;

		if (isValid) {
			$.get("/submit", {email: email}, function(data) {
				// success
			});
		} else {
			$(".form-group .help-block").show();
			$(".form-group").addClass("has-error");
			 has-error
		}
	});
})