$(function() {
   $("input:file").change(function (){
	 $('#upload-form').submit();
   });
});