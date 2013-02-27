<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>Untitled</title>
</head>

<body>

 <cfinvoke component="scholadmin" method="getResetDate" returnvariable="resetdate" />
<cfquery name="getSchols" datasource="scholarships">
select scholarships.scholarship_id as scholarship_id, title, application_id, completed from scholarships, applications where applications.scholarship_id=scholarships.scholarship_id and application_start_date > to_date('#resetdate#') order by title
</cfquery>

<table>
<tr>
	<th>Scholarship</th>
	<th>Incomplete Applications</th>
	<th>Complete Applications</th>
</tr>
<cfset prevschol="">
<cfoutput query="getSchols">
	<cfif prevschol neq getSchols.title>
		<cfquery name="getCompleteApps" dbtype="query">
			select * from getSchols where scholarship_id=#getSchols.scholarship_id# and completed='true'
		</cfquery>
		<cfquery name="getIncompleteApps" dbtype="query">
			select * from getSchols where scholarship_id=#getSchols.scholarship_id# and completed is null
		</cfquery>
		<tr>
			<td>#getSchols.title#</td>
			<td>#getIncompleteApps.RecordCount#</td>
			<td>#getCompleteApps.RecordCount#</td>
		</tr>	
	</cfif>
	<cfset prevschol=getSchols.title>
</cfoutput>
</table>

</body>
</html>
