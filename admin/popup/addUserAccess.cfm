<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>Add User Access</title>
	<link href="/scholarships/admin/scholarships.css" rel="stylesheet" type="text/css" />
	<style type="text/css">
		body{
			font-family: arial, sans-serif;
			background-color: white;
		}
	</style>
</head>

<body>

<cfif isDefined("Form.addUser")>
	<cfloop list="#Form.addUser#" index="i">
		<cfquery name="checkForUser" datasource="scholarships">
			select * from scholarships_users where user_id=#i# and scholarship_id=#Form.scholid#
		</cfquery>
		<cfif checkForUser.RecordCount eq 0>
			<cfquery name="addUsers" datasource="scholarships">
				insert into scholarships_users (scholarship_id, user_id) values (#Form.scholid#, #i#)
			</cfquery>
		</cfif>
	</cfloop>
	<h2>The users are being added...</h2>
	<cfoutput>
	<script language="javascript">
		setTimeout("parent.parent.document.location='/scholarships/admin/index.cfm?add_scholarship=#Form.scholid#'", 500);
	</script>
	</cfoutput>
<cfelse>
	<cfquery name="getScholInfo" datasource="scholarships">
		select * from scholarships where scholarship_id=#URL.scholid#
	</cfquery>
	<cfoutput><h2>Add User Access to #getScholInfo.title#</h2></cfoutput>
	Select each user you wish to grant access to this scholarship.  You may select multiple users at one time, and you may unselect users already selected by clicking on the green select box .  When you have made your selection click submit; otherwise, you may cancel your selections.
	If a user is not listed, then you must add the user to the system under the <b>User Administration</b> tab.
	<cfquery name="getUsers" datasource="scholarships">
		select * from users where account_type <> 1
	</cfquery>
	<form method="post" action="addUserAccess.cfm">
	<table cellpadding="5" cellspacing="0" border="0" width="100%" class="usermatrix" id="scholarshipTable">
		<caption>User Table</caption>
		<tr>
			<th>Campus ID</th>
			<th>First Name</th>
			<th>Last Name</th>
			<th>E-mail</th>
			<th>Select</th>
		</tr>
		
		<cfset rowcolor=1>
		<cfset rownum=0>
		<cfif not isDefined("URL.page")><cfset curPage=1>
		<cfelse><cfset curPage=URL.page></cfif>
		<cfoutput query="getUsers">
			<tr><td>#campus_id#</td><td>#first_name#</td><td>#last_name#</td><td>#campus_id#@gsu.edu</td><td><input type="checkbox" name="addUser" value="#user_id#"></td></tr>
		</cfoutput>
	</table>
	<input type="submit" value="SUBMIT"> <input type="button" value="CANCEL" onclick="parent.parent.GB_hide();">
	<cfoutput><input type="hidden" name="scholid" value="#URL.scholid#"></cfoutput>
	</form>
</cfif>

</body>
</html>
