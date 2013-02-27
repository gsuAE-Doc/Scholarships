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

<cfquery name="getdesc" datasource="scholarships">
select full_desc from scholarships where scholarship_id=#URL.editschol#
</cfquery>
<h2>Full Description:</h2>
<cfif getdesc.full_desc eq "">	
	<i>No full description exists yet.</i>
<cfelse>
	<cfset desc=Replace(getdesc.full_desc,"\n","<br>","all")>
	<cfset desc=Replace(desc,chr(13),"","All")>
	<cfset desc=Replace(desc,chr(10),"","All")>
	<cfset desc=Replace(desc, "'", "&acute;", "all")>
	<cfoutput>#desc#</cfoutput>
</cfif>
<br><br>
<input type="button" value="GO BACK" onclick="parent.parent.GB_hide();">

</body>
</html>
