<!---  
  myFile.xls will be the default file name 
  when prompted to download. 
  You can name it whatever.
--->

<!---  
 Query a specific file id (which 
 can be a URL paramter if you like) returning
 file_content into q.file_content
--->
<cfquery name="q" datasource="scholarships">
  select short_answer_questions from applications where student_id=1 and scholarship_id=145
</cfquery>
    <!---<cfqueryparam 
        cfsqltype="cf_sql_varchar" 
        value="0B2284648FFB5227E040DE090A0A1441">--->
<cfheader name="Content-Type" value="doc">
	<cfheader 
    name="content-disposition" 
    value="attachment; filename=form.doc">
		<cfoutput>#q.RecordCount# app.doc</cfoutput>
<!---  
 Set the MIME content encoding header to ms-excel and 
 send the contents of q.file_content 
 (containining the binary data) as the page output.
--->

<!---<cfset ext=GetToken(q.filename, 2, ".")>--->
<cfset ext="doc">
<cfif ext eq "doc" or ext eq "docx">
	<cfset ctype="msword">
<cfelseif ext eq "xls" or ext eq "xlsx" or ext eq "csv">
	<cfset ctype="vnd.ms-excel">
<cfelseif ext eq "pdf">
	<cfset ctype="pdf">
<cfelse>
	<cfset ctype="vnd.ms-word">
</cfif>

<cftry>
<cfcontent 
    type="application/#ctype#" 
    variable="#q.short_answer_questions#">
<cfcatch type="any">
<cfoutput>#cfcatch.detail# #cfcatch.message# #q.theform#</cfoutput>
File Not Found.
</cfcatch>
</cftry>
	<!---<cfcontent 
    type="application/msword"><cfoutput>#q.DOC_BLOB#</cfoutput></cfcontent>--->