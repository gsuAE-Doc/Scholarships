<!---  
  This file works both for doc and docx!!!!  Only change...filename on line 6 should be either doc or docx
--->

<cfset urlfilename=Replace("#URL.filename#", ",", "_", "all")>

<cfheader 
    name="content-disposition" 
    value="attachment; filename=#urlfilename#">

<!---  
 Query a specific file id (which 
 can be a URL paramter if you like) returning
 file_content into q.file_content
--->
<cfquery name="q" datasource="scholarships">
   select file_value
   from applications_custominfo
   where application_id=#URL.appid# and custominfo_id=#URL.infoid#
</cfquery>

<cfset filename=GetFileFromPath(#urlfilename#)>
<cfset fileext=GetToken(#filename#, 2, ".")>
<cfif fileext eq "pdf">
  <cfset mimetype="application/pdf">
<cfelse>
  <cfset mimetype="application/msword">
</cfif>

<!---  
 Set the MIME content encoding header to ms-excel and 
 send the contents of q.file_content 
 (containining the binary data) as the page output.
--->
<cfcontent 
    type="#mimetype#" 
    variable="#q.file_value#">    
