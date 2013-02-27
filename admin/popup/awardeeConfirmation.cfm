<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>Untitled</title>
	<style type="text/css">
		body{
			font-family: arial, sans-serif
		}
	</style>
</head>

<body>

<cfif isDefined("Form.awardee1amount")>
	<cfloop index="i" from="1" to="20">
	<cfif isDefined("Form.awardee#i#amount")>
	<cfoutput>
		<cfquery name="awardAmount" datasource="scholarships">
			update applications set awarded='y', pending='', denied='', award_amount='#Evaluate("Form.awardee#i#amount")#', award_date=to_date('#month(NOW())#/#day(NOW())#/#year(NOW())# #Hour(NOW())#:#Minute(NOW())#:#Second(NOW())#','MM/DD/YY HH24:MI:SS') where application_id=#Evaluate("Form.awardee#i#id")#
		</cfquery>
		<cfquery name="getEmail" datasource="scholarships">
			select email_address, scholarship_id from applications where application_id=#Evaluate("Form.awardee#i#id")#
		</cfquery>
		<cfset scholarship_id=getEmail.scholarship_id>
		<cfif isDefined("getEmail.email_address") and getEmail.email_address neq "">
			<cfset notificationaddy=getEmail.email_address>
		<cfelse>
			<cfset notificationaddy="christina@gsu.edu">
		</cfif>
		<cfquery name="getEmail" datasource="scholarships">
			select STUDENT_AWARDED_EMAIL as email from scholarships where scholarship_id=#getEmail.scholarship_id#
		</cfquery>
		<cfif getEmail.email eq "">
			<cfquery name="getEmail" datasource="scholarships">
				select * from confirmation_emails where email_type='defaultawarded'
			</cfquery>
		</cfif>
		<cfinvoke component="scholarships/admin/scholadmin" method="replaceEmailFields" origemail="#getEmail.email#" scholid="#scholarship_id#" appid="#Evaluate("Form.awardee#i#id")#" returnvariable="confemail" />
		<cfoutput><cfmail
		from="The Scholarship Office <scholarships@gsu.edu>"
		replyto = "The Scholarship Office <scholarships@gsu.edu>"
		to="#notificationaddy#"
		bcc="christina@gsu.edu"
		subject="Award notification"
		SERVER="mailhost.gsu.edu"
		type="html">#confemail# <!--- Please note that this award is contingent on final clearance by the Office of Student Financial Aid. #Evaluate("Form.awardee#i#amount")#.--->
		</cfmail></cfoutput>
	</cfoutput>
	</cfif>
	</cfloop>
	<cfoutput><h2>Your Scholarship Awardees have been notified.</h2>
	<input type="button" value="CONTINUE" onClick="parent.parent.document.location='/scholarships/admin/index.cfm?awards=#Form.submitAwardees#';parent.parent.GB_hide();"></cfoutput>
<cfelse>
<form name="awardeeConfirmationForm" action="awardeeConfirmation.cfm" method="post">
<h2>Please confirm the Awardee's Name(s) and Amount(s)</h2>
You are about to notify the following people of their Scholarship Awards.  Look at the table below and make sure that the award amounts are correct.  Once you confirm this list, the student will be notified that they have received the scholarship.  They will only be notified of the amount if you have elected to include this information.
<br><br>
<script language="javascript">
	var theform=top.window.document.awardeeForm;
	for(i=0; i<theform.elements.length; i++)
	{	
		if (theform.elements[i].type=="text"){
			//code for putting commas!!
			nStr=theform.elements[i].value;
			nStr += '';
			x = nStr.split('.');
			x1 = x[0];
			x2 = x.length > 1 ? '.' + x[1] : '';
			var rgx = /(\d+)(\d{3})/;
			while (rgx.test(x1)) {
				x1 = x1.replace(rgx, '$1' + ',' + '$2');
			}
			//end code for placing commas in number

			document.write(theform.elements[i].id + " - $" + x1 + x2);
			document.write("<input type='hidden' name='awardee" + (i+1) +"id' value='" + theform.elements[i].name + "'>");
			document.write("<input type='hidden' name='awardee" + (i+1) +"amount' value='" + theform.elements[i].value + "'><br>");
		}
	}
	document.write('<input type="hidden" name="submitAwardees" value="'+theform.submitAwardees.value+'">');
	document.write('<input type="hidden" name="scholarshipName" value="'+theform.scholarshipName.value+'">');
</script>
<br>
<!--first go to next page and submit awards, then say parent.parent.document.location=''-->
<input type="button" value="CONFIRM" onClick="awardeeConfirmationForm.submit();"> 
<input type="button" value="GO BACK" onClick="parent.parent.GB_hide();">
</form>
</cfif>

</body>
</html>
