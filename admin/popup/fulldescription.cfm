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
</head>

<body>
<cfif isDefined("Form.full_description")>
	<cfinvoke component="/scholarships/admin/scholadmin" method="cleanUpWord" text="#Form.full_description#" returnvariable="full_desc" />
	<cfquery name="add" datasource="scholarships">
			update scholarships set full_desc=<CFQUERYPARAM VALUE="#full_desc#" CFSQLTYPE="CF_SQL_CLOB"> where scholarship_id=#Form.editschol#
		</cfquery>
	<h3>Your custom information is being added...</h3>
	<cfoutput>
	<script language="javascript">
		setTimeout ( "parent.parent.document.location='/scholarships/admin/index.cfm?edit_scholarship=#Form.editschol#';//parent.parent.GB_hide();", 500 );
	</script>
	</cfoutput>
<cfelse>
<form method="post" action="fulldescription.cfm">
<cfquery name="getdesc" datasource="scholarships">
select full_desc from scholarships where scholarship_id=#URL.editschol#
</cfquery>
<cfset desc=Replace(getdesc.full_desc,"\n","<br>","all")>
<cfset desc=Replace(desc,chr(13),"","All")>
<cfset desc=Replace(desc,chr(10),"","All")>
<cfset desc=Replace(desc, "'", "&acute;", "all")>
<h2>Full Description:</h2>
<script type="text/javascript">
		<!--
		var editorName="full_description";
		var oFCKeditor = new FCKeditor( editorName ) ;
		oFCKeditor.BasePath = '/scholarships/FCKeditor/' ;
		<cfoutput>var texteditorvalue = '#desc#' ;</cfoutput>
		oFCKeditor.Value = texteditorvalue;
		oFCKeditor.Create() ;
		//-->
	</script>
<cfoutput>
<input type="submit" value="SUBMIT"> 
<input type="button" value="CANCEL" onclick="parent.parent.GB_hide();">
<input type="hidden" name="editschol" value="#URL.editschol#">
</cfoutput>
</form>
</cfif>
</body>
</html>
