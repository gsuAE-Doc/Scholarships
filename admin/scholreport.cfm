<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>Scholarship Reports</title>
	<link href="scholarships.css" rel="stylesheet" type="text/css" />
	<style type="text/css">
	body{
	background-color: White;
	}
	</style>
</head>

<body>

<cfoutput>

<table cellspacing="0" class="usermatrix">
	<caption>Scholarship Report</caption>
	<tr><th>Attribute</th><th>Amount</th></tr>
	<cfquery name="getStudents" datasource="scholarships">
	select * from students
	</cfquery>
	<tr><td><b>Total ## of students who logged in to the Scholarship directory</b></td>
	<td>#getStudents.RecordCount#</td></tr>
	<cfquery name="getApplicants" datasource="scholarships">
	select distinct(student_id) from applications order by student_id
	</cfquery>
	<tr><td><b>Total ## of applicants (incomplete and complete)</b></td><td>#getApplicants.RecordCount#</td></tr>
	<tr><td><b>Total ## of completed applications vs. Total ## of incomplete applications</b></td><td></td></tr>
	<cfquery name="getCompleteApps" datasource="scholarships">
	select * from applications where completed='true'
	</cfquery>
	<tr><td><i>complete:</i></td><td>#getCompleteApps.RecordCount#</td></tr>
	<cfquery name="getIncompleteApps" datasource="scholarships">
	select * from applications where completed is null or completed=''
	</cfquery>
	<tr><td><i>incomplete:</i></td><td>#getIncompleteApps.RecordCount#</td></tr>
	<tr><td><b>Total ## of applications for each award (incomplete and complete)</b></td><td></td></tr>
	</cfoutput>
	<cfquery name="getSchols" datasource="scholarships">
	select * from scholarships where college=15 order by title
	</cfquery>
	<cfoutput query="getSchols">
		<cfquery name="getSpecApps" datasource="scholarships">
		select * from applications where scholarship_id=#getSchols.scholarship_id#
		</cfquery>
		<tr><td><i>#getSchols.title#</i></td><td>#getSpecApps.RecordCount#</td></tr>
	</cfoutput>
</table>
<!---<cfquery name="getApps" datasource="scholarships">
select * from applications
</cfquery>
total:#getApps.RecordCount#<br>--->

</body>
</html>
