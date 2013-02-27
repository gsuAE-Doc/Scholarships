<cfquery name="q" datasource="scholarships">
   select *
   from scholarships_documents
   where document_id=#URL.doc#
</cfquery>

<cfif q.scholarship_id neq URL.schol_id><p>Sorry, the document you requested is not available for this scholarship.</p><cfabort></cfif>


<!---  
  This file works both for doc and docx!!!!  Only change...filename on line 6 should be either doc or docx
--->
<cfheader 
    name="content-disposition" 
    value="attachment; filename=#URL.filename#">

<!---  
 Query a specific file id (which 
 can be a URL paramter if you like) returning
 file_content into q.file_content
--->


<!---  
 Set the MIME content encoding header to ms-excel and 
 send the contents of q.file_content 
 (containining the binary data) as the page output.
--->

<cfset ext=#trim(listlast(q.document_filename, "."))#>
<cfif ext eq "pdf"><cfset filetype="application/pdf">
<cfelseif ext eq "doc"><cfset filetype="application/msword">
<cfelseif ext eq "docx"><cfset filetype="application/vnd.openxmlformats-officedocument.wordprocessingml.document">
<cfelse><cfset filetype="application/pdf">
</cfif>


<cfcontent 
    type="#filetype#" 
    variable="#q.document#">    

