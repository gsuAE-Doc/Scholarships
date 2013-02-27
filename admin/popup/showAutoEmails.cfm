<cfquery name="getScholInfo" datasource="scholarships">
    select * from scholarships where scholarship_id='#URL.scholid#'
</cfquery>

<cfinvoke component="/scholarships/admin/scholadmin" method="showAutoEmails" scholInfo="#getScholInfo#" />