<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>Untitled</title>
	<style type="text/css">
		body{
			font-family: arial, sans-serif
		}
	</style>
	<script language="javascript" src="/scholarships/FCKeditor/fckeditor.js"></script>
	<script language="javascript">
		function validateForm(){
			if (document.titleform.value == ""){
				alert("Please enter a title before submitting.");
				return false;
			}
		}
	</script>
</head>

<body>
<cfif isDefined("Form.title")>
	<cfquery name="rename" datasource="scholarships">
			update scholarships set title='#Form.title#' where scholarship_id=#Form.editschol#
		</cfquery>
	<h3>The scholarship is being renamed...</h3>
	<cfoutput>
	<script language="javascript">
		setTimeout ( "parent.parent.document.location='/scholarships/admin/index.cfm?edit_scholarship=#Form.editschol#';//parent.parent.GB_hide();", 500 );
	</script>
	</cfoutput>
<cfelse>
<form method="post" name="titleform" action="editName.cfm">
<cfquery name="gettitle" datasource="scholarships">
select title from scholarships where scholarship_id=#URL.editschol#
</cfquery>
<h2>Scholarship Title:</h2>
<cfoutput>
<input name="title" id="title" value="#gettitle.title#">
<input type="submit" value="SUBMIT" onclick="return validateForm();"> 
<input type="button" value="CANCEL" onclick="parent.parent.GB_hide();">
<input type="hidden" name="editschol" value="#URL.editschol#">
</cfoutput>
</form>
</cfif>
</body>
</html>
