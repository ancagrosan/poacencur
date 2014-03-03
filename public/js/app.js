$(function() {
   $("input:file").change(function (){
	 $('#upload-form').submit();
   });
});

$("#r1, #r2, #r3, #r4, #r5, #r6").change(function () {
  $(this).parent().parent().addClass("hide");
  $("#loading").removeClass("hide");

  setTimeout(function(){
	$("#loading").addClass("hide");
	$("#after").removeClass("hide");

	$('#r4').attr('checked', false);
	$('#r5').attr('checked', false);
  },1300);
});
