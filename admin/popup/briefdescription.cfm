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
			var fckEditor = FCKeditorAPI.GetInstance('brief_description');
			var desctext = fckEditor.EditorDocument.body.innerHTML;
			var strlen = desctext.length;
			if (strlen > 200){
				alert("You have entered "+strlen+" characters.  Please enter 200 or less characters.");
				return false;
			}
		}
	</script>
</head>

<body>
<cfif isDefined("Form.brief_description")>
	<cfquery name="add" datasource="scholarships">
			update scholarships set brief_desc=<CFQUERYPARAM VALUE="#Form.brief_description#" CFSQLTYPE="CF_SQL_CLOB"> where scholarship_id=#Form.editschol#
		</cfquery>
	<h3>Your custom information is being added...</h3>
	<cfoutput>
	<script language="javascript">
		setTimeout ( "parent.parent.document.location='/scholarships/admin/index.cfm?edit_scholarship=#Form.editschol#';//parent.parent.GB_hide();", 500 );
	</script>
	</cfoutput>
<cfelse>
<form method="post" action="briefdescription.cfm">
<cfquery name="getdesc" datasource="scholarships">
select brief_desc from scholarships where scholarship_id=#URL.editschol#
</cfquery>
<cfset desc=Replace(getdesc.brief_desc,"\n","<br>","all")>
<cfset desc=Replace(desc,chr(13),"","All")>
<cfset desc=Replace(desc,chr(10),"","All")>
<cfset desc=Replace(desc, "'", "&acute;", "all")>
<h2>Brief Description:</h2>
<script type="text/javascript">
		<!--
		var editorName="brief_description";
		var oFCKeditor = new FCKeditor( editorName ) ;
		oFCKeditor.BasePath = '/scholarships/FCKeditor/' ;
		<cfoutput>var texteditorvalue = '#desc#' ;</cfoutput>
		oFCKeditor.Value = texteditorvalue;
		oFCKeditor.Create() ;
		//-->
	</script>
<cfoutput>
<input type="submit" value="SUBMIT" onclick="return validateForm();"> 
<input type="button" value="CANCEL" onclick="parent.parent.GB_hide();">
<input type="hidden" name="editschol" value="#URL.editschol#">
</cfoutput>
</form>
</cfif>
</body>
</html>
