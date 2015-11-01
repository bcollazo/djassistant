$(document).ready(function() {
	$(".form-group").keyup(function() {
		$(".form-group .help-block").hide();
		$(".form-group").removeClass("has-error");
	});
	$("#submit_btn").click(function() {
		var email = $(".form-group input").val();
		var isValid = email != "";

		if (isValid) {
			$.post(
				'/submit',
				{email: email},
				function() {
					window.location.reload();
				}
			);
		} else {
			$(".form-group .help-block").show();
			$(".form-group").addClass("has-error");
		}
	});
})