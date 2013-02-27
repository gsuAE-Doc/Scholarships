<cfquery name="q" datasource="scholarships">
   select *
   from scholarships_documents
   where document_id=#URL.doc#
</cfquery>

<cfif q.scholarship_id neq URL.schol_id><p>Sorry, the document you requested is not available for this scholarship.</p><cfabort></cfif>

<cfapplication name="scholarshipApp" 
sessionmanagement="Yes"
sessiontimeout=#CreateTimeSpan(0,0,45,0)#>

<cfheader 
    name="content-disposition" 
    value="attachment; filename=myFile.pdf">



<!---<cfdocument format="PDF" orientation="portrait">--->


<cfcontent 
    type="application/pdf" 
    variable="#q.document#">  