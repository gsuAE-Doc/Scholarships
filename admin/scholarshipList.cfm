<CFQUERY NAME="getScholarships" DATASOURCE="scholarships">
         select title,applicable_date,deadline,award_date from scholarships where scholarship_id not in (select scholarship_id from scholarships_colleges where college_id=63) order by title
</cfquery>
<h2>Scholarship List</h2>
<table border="1" cellspacing="0">
<tr><th>Title</th><td>Applicable Date</th><th>Deadline</th><th>Award Date</th></tr>
    <cfoutput query="getScholarships">
        <tr><td>#title#</td><td>#DateFormat(applicable_date, "mm/dd/yyyy")#</td><td>#DateFormat(deadline, "mm/dd/yyyy")#</td><td>#DateFormat(award_date, "mm/dd/yyyy")#</td></tr>
    </cfoutput>
</table>