<cffunction name="showApplicationNumbers">
	<h1>Scholarship Application Numbers</h1>
	 <cfinvoke component="scholadmin" method="getResetDate" returnvariable="resetdate" />
	 <cfset resetdatearray=ListToArray(resetdate, "-")>
	<!---<cfoutput><h2>as of December 1, #resetdatearray[3]#</h2></cfoutput>--->
	<cfoutput><h2>as of #DateFormat("#resetdate#", "mmmm d, yyyy")#</h2></cfoutput>
	<cfif Session.userrights eq 1>
		<!---USED TO BE<cfquery name="getSchols" datasource="scholarships">
		select scholarships.scholarship_id as scholarship_id, title, application_id, completed from scholarships, applications where applications.scholarship_id=scholarships.scholarship_id and application_start_date > to_date('#resetdate#') order by title
		</cfquery>--->
		<cfquery name="getSchols" datasource="scholarships">
		select scholarships.scholarship_id as scholarship_id, title, application_id, completed from scholarships, applications where applications.scholarship_id=scholarships.scholarship_id order by title
		<!---select scholarship_id, title from scholarships order by title--->
		</cfquery>
	<cfelseif Session.userrights eq 4>
		<cfquery name="getSchols" datasource="scholarships">
		select * from scholarships JOIN scholarships_users ON scholarships.scholarship_id=scholarships_users.scholarship_id JOIN users ON scholarships_users.user_id=users.user_id where scholarships.scholarship_id not in (select scholarship_id from scholarships_colleges where college_id = 63) and users.campus_id='#Cookie.campusid#' order by title  <!---used to be college <> 63 or college is null--->
		</cfquery>
	</cfif>
	<cfif getSchols.RecordCount eq 0>
		<cfoutput><br>There are no applications as of  #DateFormat("#resetdate#", "mmmm d, yyyy")#.  Thank you.<cfreturn></cfoutput>
	</cfif>
	<table cellpadding="5" cellspacing="0" border="0" width="100%" class="usermatrix" id="applicationNumbersTable">
	<caption>View Incomplete and Complete Application Numbers</caption>
	<tr>
		<th>Scholarship</th>
		<th>Incomplete Applications</th>
		<th>Complete Applications</th>
	</tr>
	<cfset prevschol="">
	<cfset count=2>
	<cfoutput query="getSchols">
		<cfif prevschol neq getSchols.title and scholarship_id neq "">
			<cfinvoke component="scholadmin" method="getResetDate" returnvariable="resetdate" scholid="#getSchols.scholarship_id#" />
			<cfquery name="getCompleteApps" datasource="scholarships">
				select * from applications where application_start_date > to_date('#resetdate#') AND scholarship_id=#getSchols.scholarship_id#  and completed='true'
			</cfquery>
			
			<cfquery name="getIncompleteApps" datasource="scholarships">
				select * from applications where application_start_date > to_date('#resetdate#') AND scholarship_id=#getSchols.scholarship_id# and completed is null
			</cfquery>
			<tr class="usermatrixrow#count#">
				<td>#getSchols.title#</td>
				<td>#getIncompleteApps.RecordCount#</td>
				<td>#getCompleteApps.RecordCount#</td>
			</tr>	
			<cfif count eq 2>
				<cfset count=1>
			<cfelse>
				<cfset count=2>
			</cfif>
		</cfif>
		<cfset prevschol=getSchols.title>
	</cfoutput>
	</table>
</cffunction>
<cffunction name="showScholarshipClassifications">
	<h1>Scholarship Classifications</h1>
	<cfquery name="getclassifications" datasource="scholarships">
		select * from class_levels
	</cfquery>
	<cfoutput query="getclassifications">
		<h2>#class_level#</h2>
		<cfquery name="getSchols" datasource="scholarships">
			select title from scholarships where scholarship_id in ( select SCHOLARSHIP_ID from SCHOLARSHIPS_CLASSLEVELS where LEVEL_ID = #level_id# ) order by title
		</cfquery>
		<ul>
		<cfloop query="getSchols">
			<li>#title#</li>
		</cfloop>
		</ul>
	</cfoutput>
	<h2>Unlabelled</h2>
	<cfquery name="getSchols" datasource="scholarships">
			select title from scholarships where scholarship_id not in ( select SCHOLARSHIP_ID from SCHOLARSHIPS_CLASSLEVELS ) order by title
	</cfquery>
	<ul>
	<cfoutput query="getSchols">
		<li>#title#</li>
	</cfoutput>
	</ul>
</cffunction>
<cffunction name="getMasterSpreadsheetDates">
	<br><h1>Get Master Spreadsheet</h1>
    <p><b>Note: </b>These dates refer to the application start date of the applicant who has a completed application on file.</p>
    <form method="post" target="_blank" action="masterspreadsheetcomplete.cfm" onsubmit="if (this.start_date.value=='mm/dd/yyyy' || this.end_date.value=='mm/dd/yyyy'){alert ('Please choose both dates before requesting the spreadsheet.'); return false;}">
    <SCRIPT LANGUAGE="JavaScript">
		var cal1 = new CalendarPopup("popupcalendar"); 
	</SCRIPT> 
    <table>
    <tr><td>
	<cfoutput><input  type="text" name="start_date" id="start_date" size="8" onfocus="alert('Please choose the date by clicking on the calendar to the right of the field.');this.blur();" <cfif isDefined("Form.start_date")>value="#Form.start_date#"<cfelse>value="mm/dd/yyyy"</cfif>></cfoutput>
	<img src="images/cal.gif" onClick="cal1.select(document.getElementById('start_date'),'anchor1','MM/dd/yyyy'); return false;" TITLE="start date calendar" NAME="anchor1" ID="anchor1">
	<div id="popupcalendar" STYLE="position:absolute;visibility:hidden;background-color:white;layer-background-color:white;font-family: Arial, Helvetica, sans-serif;font-size: 12px;"></div>
    </td><td>to </td>
    <td>
	  &nbsp; 
	<SCRIPT LANGUAGE="JavaScript">
	var cal2 = new CalendarPopup("popupcalendar2"); 
	</SCRIPT>
	<cfoutput><input  type="text" name="end_date" id="end_date" size="8" onfocus="alert('Please choose the date by clicking on the calendar to the right of the field.');this.blur();"  onchange="" <cfif isDefined("Form.end_date")>value="#Form.end_date#"<cfelse>value="mm/dd/yyyy"</cfif>></cfoutput>
	<img src="images/cal.gif" onclick="cal2.select(document.getElementById('end_date'),'anchor2','MM/dd/yyyy');" name="anchor2" id="anchor2">
	<div id="popupcalendar2" STYLE="position:absolute;visibility:hidden;background-color:white;layer-background-color:white;font-family: Arial, Helvetica, sans-serif;font-size: 12px;"></div>
    </td>
    <td><input type="submit" value="Get Spreadsheet"></td>
    </tr>
    </table>
    </form>
</cffunction>