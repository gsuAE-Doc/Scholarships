<cffunction name="listScholarships">
    <p>List of scholarships that require a faculty recommendation:</p>
    <cfquery name="getCustomInfo" datasource="scholarships">
        select * from custom_information where info_type='fileuploadbyinstructor'
    </cfquery>
    <cfset fac_rec_schols=ValueList(getCustomInfo.info_id)>
    <!---<cfdump var="#getCustomInfo#">
    <cfoutput>#fac_rec_schols#</cfoutput>--->
    <cfquery name="getSchols" datasource="scholarships">
        select * from scholarships where scholarship_id in (select scholarship_id from scholarships_custominfo where custominfo_id in (#fac_rec_schols#))
    </cfquery>
    <ul>
        <cfoutput query="getSchols">
            <li>
                <a href="faculty_recommendation.cfm?schol=#scholarship_id#">#title#</a>
            </li>
        </cfoutput>
    </ul>
</cffunction>
<cffunction name="student_pantherno_form">
    <cfif isDefined("Form.panther_number")>
        <cfif Form.panther_number eq "">
            <p style="color:red">Sorry, no value was entered. Please try again.</p>
            <cfinvoke method="show_student_pantherno_form" />
        <cfelseif Len(Form.panther_number) neq 9 or not isNumeric(Form.panther_number)>
            <p style="color:red">Please enter a 9-digit number.</p>
            <cfinvoke method="show_student_pantherno_form" />
        <cfelse>
            <cfinvoke method="processStudent" />
        </cfif>
    <cfelse>
        <cfinvoke method="show_student_pantherno_form" />
    </cfif>
</cffunction>
<cffunction name="show_student_pantherno_form">
   <p>Please enter the student's panther number below:</p>
   <cfif isDefined("URL.schol")>
    <cfset scholid=URL.schol>
    <cfelseif isDefined("Form.scholarship_id")>
    <cfset scholid=Form.scholarship_id>
   </cfif>
    <cfoutput>
    <form method="post" action="faculty_recommendation.cfm">
        <input type="text" name="panther_number" maxlength="9">
        <input type="hidden" name="scholarship_id" value="#scholid#"><br><br>
        <input type="submit" value="Submit Panther Number">
    </form>
    </cfoutput>
</cffunction>
<cffunction name="processStudent">
    <cfinvoke component="scholadmin" method="getResetDate" returnvariable="resetdate" />
    <cfquery name="checkStudent" datasource="scholarships">
        select * from applications, students where applications.student_id=students.student_id and  students.gsu_student_id=<cfqueryparam value="#Form.panther_number#" cfsqltype="CF_SQL_BIGINT"> and scholarship_id=<cfqueryparam value="#Form.scholarship_id#" cfsqltype="CF_SQL_BIGINT"> and application_start_date > to_date('#resetdate#')
    </cfquery>
    <cfif checkStudent.RecordCount eq 0>
        <p>Sorry, this student does not have a current application for this scholarship. Please <a href="faculty_recommendation.cfm">select another scholarship</a>.
    <cfelse>
        <h2>Student Name: <cfinvoke component="scholadmin" method="getName" gsustudentid="#Form.panther_number#"></h2>
        <cfquery name="getCustomInfo" datasource="scholarships">
            select * from custom_information where info_type='fileuploadbyinstructor' and info_id in (select custominfo_id from scholarships_custominfo where scholarship_id=#Form.scholarship_id#)
        </cfquery>
        <cfquery name="gg" datasource="scholarships">
            select * from scholarships_custominfo where scholarship_id=#Form.scholarship_id#
        </cfquery>
        <cfif getCustomInfo.RecordCount eq 0 and not isDefined("Form.info_id")>
            Please <a href="faculty_recommendation.cfm">reselect</a> a scholarship.
        <cfelseif getCustomInfo.RecordCount gt 1 and not isDefined("Form.info_id")>
            <p>Please select the recommendation you would like to upload:</p>
            <form action="faculty_recommendation.cfm" method="post">
                <cfoutput>
                    <cfset recavail=false>
                    <cfloop query="getCustomInfo">
                    
                        <cfquery name="check" datasource="scholarships">
                                select * from applications_custominfo where application_id=#checkStudent.application_id# and custominfo_id=#info_id#
                        </cfquery>
                        <cfif check.RecordCount eq 0>
                            <input type="radio" name="info_id" value="#info_id#"> #custom_info#<br>
                            <cfset recavail=true>
                        </cfif>
                    </cfloop>
                    <input type="hidden" name="panther_number" value="#Form.panther_number#">
                    <input type="hidden" name="scholarship_id" value="#Form.scholarship_id#">
                </cfoutput><br>
                <cfif recavail eq true>
                    <input type="submit" value="Submit Recommendation Type">
                <cfelse>
                    <p><i>Sorry, all recommendations have been uploaded for this student.</i></p>
                </cfif>
            </form>
        <cfelseif getCustomInfo.RecordCount eq 1 or isDefined("Form.info_id")>
            <cfif isDefined("Form.info_id")>
                <cfset info_id=Form.info_id>
            <cfelseif getCustomInfo.RecordCount eq 1>
                <cfset info_id=getCustomInfo.info_id>
            </cfif>
            <cfquery name="check" datasource="scholarships">
                    select * from applications_custominfo where application_id=#checkStudent.application_id# and custominfo_id=#info_id#
            </cfquery>
            <cfif check.RecordCount gt 0>
                <p>Sorry, a faculty recommendation already exists for this student and scholarship.</p>
            <cfelse>
                <p>Please upload your recommendation.  Thank you!</p>
                <cfoutput>
                <form method="post" action="faculty_recommendation.cfm" enctype="multipart/form-data">
                    <input type="file" name="recommendation"><br><br>
                    <input type="hidden" name="app_id" value="#checkStudent.application_id#">
                    <input type="hidden" name="info_id" value="#info_id#">
                    <input type="submit" value="Upload Recommendation">
                </form>
                </cfoutput>
            </cfif>
        </cfif>
    </cfif>    
</cffunction>
<cffunction name="uploadRecommendation">
    <cftry>
        <!---  
          Upload the file to a folder on the webserver and 
          outside the web root.
        --->
	
	<cfif cgi.server_name eq "glacierqa.gsu.edu" or cgi.server_name eq "glacier.gsu.edu">
	    <cfset drive="d">
        <cfelseif cgi.server_name eq "webdb.gsu.edu">
            <cfset drive="c">
        </cfif>
	<cfif isDefined("drive")><cfset filepath="#drive#:\inetpub\wwwroot\visit\test\uploadedfiles">
        <cfelseif cgi.server_name eq "istcfqa.gsu.edu">
            <cfset filepath="D:\inetpub\cf-qa\visit\test\uploadedfiles">
        <cfelseif cgi.server_name eq "app.gsu.edu">
            <cfset filepath="D:\inetpub\visit\test\uploadedfiles">
        </cfif>
	
	    <cffile action="upload"
            filefield="form.recommendation"
            destination="#filepath#"
            nameconflict="makeunique"
	    accept="application/msword, application/vnd.openxmlformats-officedocument.wordprocessingml.document, application/octet-stream, application/pdf">
			
		<cfset filename="#cffile.ClientFileName#.#cffile.ClientFileExt#">
            <!---  
              The file is on the web server now. Read it as a binary
              and put the result in the ColdFusion variable file_blob
            --->
            <cffile 
                action = "readbinary" 
                file = "#filepath#\#cffile.serverFile#" 
                variable="file_blob">
            <!---  
              Insert the ColdFusion variable file_blob
              into the table, making sure to select
              cf_sql_blob as the sql type.
            --->
			<cfquery name="check" datasource="scholarships">
				select * from applications_custominfo where application_id=#Form.app_id# and custominfo_id=#Form.info_id#
			</cfquery>
			
			<cfif check.RecordCount eq 0>
				<cfquery name="q" datasource="scholarships">
	                insert into applications_custominfo (application_id, custominfo_id, file_name, added_campusid, file_value) values (#Form.app_id#, #Form.info_id#, '#fileName#', '#Cookie.campusid#', 
							<cfqueryparam 
	                        value="#file_blob#" 
	                        cfsqltype="cf_sql_blob">
							)
	            </cfquery>
			<cfelse>
				<cfquery name="q" datasource="scholarships">
	                update applications_custominfo set file_name='#fileName#', file_value=
							<cfqueryparam 
	                        value="#file_blob#" 
	                        cfsqltype="cf_sql_blob">
							where application_id=#Form.app_id# and custominfo_id=#Form.info_id#
	            </cfquery>
			<cftry>
				<cfif isDefined("Form.studDet_#getFileQuestions.custominfo_id#")>
					<cfset custominfodetvalue=#Evaluate("Form.studDet_#getFileQuestions.custominfo_id#")#>
					<cfquery name="getAppValue" datasource="scholarships">
					update applications_custominfo set STUDENT_REQUIRED=<cfqueryparam value = "#custominfodetvalue#"> where custominfo_id=#getFileQuestions.custominfo_id# and application_id=#appid#
					</cfquery>
				</cfif>
			<cfcatch></cfcatch>
			</cftry>
			</cfif>
            <!---  
              No  need to keep the file on the webserver
              because it was just stored in the database. So,
              delete it from the folder.
            
            <cffile 
                action="delete" 
                file="#filepath#\#cffile.serverFile#">                 
			--->
            <!---File successfully saved.--->
            <h2>Thank you, the recommendation has been saved!</h2><br>
            <input type="button" value="Add another recommendation" onclick="document.location='faculty_recommendation.cfm';return false;">
    <cfcatch type="application">
        <br><i>The file you uploaded was not a Microsoft Word or PDF file.  Your application has not been submitted.  Please try again soon.</i><br><br>
		<cfoutput>
		
		#cfcatch.message#
		<br><br>
		#cfcatch.detail#
		<!---<cfmail
		from="christina@gsu.edu"
		replyto = "christina@gsu.edu"
		to="christina@gsu.edu"
		bcc="christina@gsu.edu"
		subject="Scholarships File Upload Error"
		SERVER="mail.gsu.edu">
		#cfcatch.message#
		
		#cfcatch.detail#
		
		#DateFormat(NOW(), "mm/dd/yyyy")# #TimeFormat(NOW(), "hh:mm tt")#
		</cfmail>--->
		</cfoutput>
		<cfreturn "error">
		<cfexit>
    </cfcatch>
    </cftry>
</cffunction>