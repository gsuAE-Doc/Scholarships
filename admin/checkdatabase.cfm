	<cfinvoke component="scholadmin" method="getResetDate" returnvariable="resetdate" />
<cftry>
<cfoutput>insert into applications (application_start_date, application_submit_date, authorizing_office, awarded, awarding_unit, award_amount, award_date, award_year, completed, county, e-mail_address, scholarship_id, semester_award_amount, student_id) values (#NOW()#, #NOW()#, 'Test Authorizing Office', 'y', 'Test Awarding Unit', 2000, #NOW()#, 2012, 'true', 'Dekalb', 'christina@gsu.edu', 1691, 1000, 96)</cfoutput>
<CFQUERY NAME="getScholarships" DATASOURCE="scholarships">
          <!---insert into applications (application_start_date, application_submit_date, authorizing_office, awarded, awarding_unit, award_amount, award_date, award_year, completed, county, e-mail_address, scholarship_id, semester_award_amount, student_id) values (#NOW()#, #NOW()#, 'Test Authorizing Office', 'y', 'Test Awarding Unit', 2000, #NOW()#, 2012, 'true', 'Dekalb', 'christina@gsu.edu', 1691, 1000, 96)--->
	   <!---insert into applications (APPLICATION_START_DATE,APPLICATION_SUBMIT_DATE,AUTHORIZING_OFFICE,AWARDED,AWARDING_UNIT,AWARD_AMOUNT,AWARD_DATE,AWARD_YEAR,CITY,COMPLETED,COUNTY,EMAIL_ADDRESS,SCHOLARSHIP_ID,SEMESTER_AWARD_AMOUNT,STATE,STUDENT_ID,ZIP) values (#NOW()#, #NOW()#, 'Test Authorizing Office', 'y', 'Test Awarding Unit', 2000, #NOW()#, 2012, 'Alanta', 'true', 'Dekalb', 'christina@gsu.edu', 1250, 1000, 'GA', 105, 30303)--->
	   	<!---Query done upon Michele's request on 11/8/2012: update scholarships set applicable='n' where scholarship_id in (select scholarship_id from scholarships_colleges where college_id=63) --->
		select * from applications where completed is not null and rownum<50
</cfquery>
<cfoutput><br>#getScholarships.RecordCount#</cfoutput>
<cfdump var="#getScholarships#">
<cfcatch><cfoutput>#cfcatch.message# -> #cfcatch.detail# <cfif isDefined("cfcatch.queryError")>#cfcatch.queryError#</cfif></cfoutput></cfcatch>
</cftry>



<!---
<table border="1" bordercolor="black" cellspacing="0">
<tr>
<cfoutput>
<cfloop index="column" list="#getScholarships.columnlist#">
	<th>#column#</th>
</cfloop>
</cfoutput>

<cfoutput query="getScholarships">
	<tr>
		<cfloop index="column" list="#getScholarships.columnlist#">
			<td>#Evaluate("getScholarships.#column#")#</td>
		</cfloop>
	</tr>
</cfoutput>
</tr>
</table>--->