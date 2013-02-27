<cfapplication name="scholarshipApp" 
sessionmanagement="Yes"
sessiontimeout=#CreateTimeSpan(0,0,45,0)#>
<cfset Session.userrights=URL.userrights>

<cfdocument format="PDF" orientation="portrait">
<cfinvoke component="scholadmin" method="reviewScholarshipApp" />
</cfdocument>