

<cffunction name="getAddress">
<cfargument name="gsustudentid">
	<cftry>
	<cfstoredproc procedure="wwokbapi.f_get_addr" datasource="SCHOLARSHIPAPI">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="#gsustudentid#"> 
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="address_type" type="in" value="MA"> 
		<cfprocresult name="out_result_set">
	</cfstoredproc> 
	<cfcatch></cfcatch>
	</cftry>
	<cfreturn out_result_set>
</cffunction>
 
 <cfinvoke component="scholadmin" method="getResetDate" returnvariable="resetdate" />
 <cfquery name="GetStudents" datasource="scholarships">
		select distinct students.student_id from applications, students where applications.student_id=students.student_id and completed='true' and application_start_date > to_date('#Form.start_date#',  'MM/DD/YYYY') and application_start_date < to_date('#Form.end_date#', 'MM/DD/YYYY')
	</cfquery>
    <cfif GetStudents.RecordCount eq 0>
    	<p style="font-family:Arial, Helvetica, sans-serif">Sorry, no students' application start dates match that date range.  Please close this window and try again.
        <cfabort>
    </cfif>
    
    
    <cfheader name="Content-Disposition" value="inline; filename=applicants.xls">
	<cfcontent type="application/vnd.msexcel">
    
    
    <cfset studentlist=ValueList(GetStudents.student_id)>
   <cfquery name="GetStudentInfo" datasource="scholarships">
		select * from students where student_id IN (#studentlist#)
	</cfquery>
 
 <!--- output data using cfloop & cfoutput --->
 <table border="0">
 	<tr>
		<td>NAME</td><td>GSU EMAIL</td><td>PREFERRED EMAIL</td><td>STUDENT ID</td><td>ADDRESS1</td><td>CITY</td><td>STATE</td><td>ZIP</td><td>PHONE</td><td>Birth Date</td><td>Gender</td><td>HS Grad Date</td><td>HS</td><td>RESIDENCY STATUS</td><td>RESIDENCY STATE</td><td>VISA TYPE</td><td>RELIGIOUS AFFILIATION</td><td>ETHNICITY</td><td>MARITAL STATUS</td><td>MAJOR</td><td>MINOR</td><td>CONCENTRATION</td><td>COLLEGE AFFILIATION</td><td>HS GPA</td><td>SAT FRESHMAN INDEX</td><td>SAT VERBAL/CRITICAL READING</td><td>SAT MATHEMATICS</td><td>ACT FRESHMAN INDEX</td><td>ACT COMPOSITE</td><td>OVERALL GSU GPA</td><td>INSTITUTIONAL GPA</td><td>HOPE GPA</td><td>TRANSFER GPA</td><td>ENROLLMENT STATUS</td><td>CLASSIFICATION</td><td>CUM. CREDIT HOURS</td><td>EFC</td><td>UNMET FINANCIAL NEED</td><td>TOTAL NEED</td><td>BUDGET AMOUNT</td></tr>
<cfloop query="GetStudentInfo">
	<cfinvoke component="scholadmin" method="convertStudentID" tempgsustudentid="#GSU_STUDENT_ID#" returnvariable="converted_id" />
	
	<cfinvoke component="scholadmin" method="getGSUEmail" gsustudentid="#converted_id#"  returnvariable="gsuemail" />
	<cfinvoke method="getAddress" gsustudentid="#converted_id#"  returnvariable="out_result_set_address" />
	
	<cfset address1=out_result_set_address.STREET_LINE1>
	<cfif out_result_set_address.street_line2 neq ""><cfset address1=address1&" "&#out_result_set_address.street_line2#></cfif>
	<cfif out_result_set_address.street_line3 neq ""><cfset address1=address1&" "&#out_result_set_address.street_line3#></cfif>
	<cfset city1="#out_result_set_address.CITY#">
	<cfset state1="#out_result_set_address.STATE#">
	<cfset zip1="#out_result_set_address.ZIP#">
	
	
	<cfinvoke component="scholadmin" method="getHomePhone" gsustudentid="#converted_id#"   returnvariable="phone" />
	<!---<cfinvoke component="scholadmin" method="getDateOfBirth" gsustudentid="#converted_id#"   returnvariable="bdate" />
	<cfinvoke component="scholadmin" method="getGender" gsustudentid="#converted_id#"   returnvariable="gender" />
    <cfinvoke component="scholadmin" method="getReligion" gsustudentid="#converted_id#"   returnvariable="religion" />
	<cfinvoke component="scholadmin" method="getEthnicity" gsustudentid="#converted_id#"   returnvariable="ethnicity" />
	<cfinvoke component="scholadmin" method="getMaritalStatus" gsustudentid="#converted_id#"   returnvariable="marital" />--->
    <cftry>
	<cfstoredproc procedure="wwokbapi.f_get_pers" datasource="SCHOLARSHIPAPI">
		<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="#converted_id#"> 
		<cfprocresult name="out_result_set">
	</cfstoredproc>
	<cfcatch>
	#cfcatch.Detail# -> #cfcatch.Message#
	</cfcatch>
	</cftry>
    <cfset bdate=DateFormat(out_result_set.BIRTH_DATE, "mm/dd/yyyy")>
    <cfset gender=out_result_set.gender>
    <cfset religion=out_result_set.relg_code>
    <cfset ethnicity=out_result_set.ethn_code>
    <cfset marital=out_result_set.mrtl_code>
	<cfinvoke component="scholadmin" method="getHSGradDate" gsustudentid="#converted_id#"   returnvariable="hsgraddate" />
	<cfinvoke component="scholadmin" method="getHighSchool" gsustudentid="#converted_id#"   returnvariable="hs" />
	<cfinvoke component="scholadmin" method="getResStatus" gsustudentid="#converted_id#"   returnvariable="resstatus" />
	<cfinvoke component="scholadmin" method="getResState" gsustudentid="#converted_id#"   returnvariable="resstate" />
	<cfinvoke component="scholadmin" method="getVisa" gsustudentid="#converted_id#"   returnvariable="visatype" />
	<cfinvoke component="scholadmin" method="getMajor" gsustudentid="#converted_id#"   returnvariable="major" />
	<cfinvoke component="scholadmin" method="getMinor" gsustudentid="#converted_id#"   returnvariable="minor" />
	<cfinvoke component="scholadmin" method="getConcentration" gsustudentid="#converted_id#"   returnvariable="conc" />
	<cfinvoke component="scholadmin" method="getAffiliatedCollege" gsustudentid="#converted_id#"   returnvariable="college" />
	<cfinvoke component="scholadmin" method="getHSGPA" gsustudentid="#converted_id#"  returnvariable="hsgpc" />
	<cfinvoke component="scholadmin" method="getSATIndexScore" gsustudentid="#converted_id#" returnvariable="satindex" />
	<cfinvoke component="scholadmin" method="getSATVerbal" gsustudentid="#converted_id#" returnvariable="satverbal" />
	<cfinvoke component="scholadmin" method="getSATMath" gsustudentid="#converted_id#" returnvariable="satmath" />
 	<cfinvoke component="scholadmin" method="getACTIndexScore" gsustudentid="#converted_id#" returnvariable="actindex" />
	<cfinvoke component="scholadmin" method="getACTComposite" gsustudentid="#converted_id#" returnvariable="actcomposite" />
	<cfinvoke component="scholadmin" method="getGPA" gsustudentid="#converted_id#" gpa_type="O" returnvariable="ogpa" />
	<cfinvoke component="scholadmin" method="getGPA" gsustudentid="#converted_id#" gpa_type="I" returnvariable="igpa" />
 	<cfinvoke component="scholadmin" method="getHopeGPA" gsustudentid="#converted_id#" returnvariable="hgpa" />
 	<cfinvoke component="scholadmin" method="getGPA" gsustudentid="#converted_id#" gpa_type="T" returnvariable="tgpa" />
	<cfinvoke component="scholadmin" method="getEnrollmentStatus" gsustudentid="#converted_id#" returnvariable="enstatus" />
	<cfif enstatus gte 12><cfset enstatus="full-time">
	<cfelseif enstatus eq 0><cfset enstatus="not enrolled this semester">
	<cfelse><cfset enstatus="part-time"></cfif>
	<cfinvoke component="scholadmin" method="getClassification" gsustudentid="#converted_id#" returnvariable="class" />
	<cfinvoke component="scholadmin" method="getCumCreditHours" gsustudentid="#converted_id#" returnvariable="cumcredhours" />
	<!---<cfinvoke component="scholadmin" method="getFinancialInfo" gsustudentid="#converted_id#" type="EFC" returnvariable="efc" />
	<cfinvoke component="scholadmin" method="getFinancialInfo" gsustudentid="#converted_id#" type="UFN" returnvariable="ufn" />
 	<cfinvoke component="scholadmin" method="getFinancialInfo" gsustudentid="#converted_id#" type="GN" returnvariable="tn" />
	<cfinvoke component="scholadmin" method="getFinancialInfo" gsustudentid="#converted_id#" type="BA" returnvariable="ba" />--->
    <cfset curyear=year(NOW())>
	<cfset nextyear=(curyear + 1)>
	<cfset curabbyear=Right(curyear, 2)>
	<cfset nextabbyear=Right(nextyear, 2)>
	<cfset yearparam="#curabbyear##nextabbyear#">
    <cftry>
		<cfstoredproc procedure="wwokbapi.f_get_faid" datasource="SCHOLARSHIPAPI">
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="#converted_id#"> 
			<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_aidy_code" type="in" value="#yearparam#">
			<cfprocresult name="out_result_set_finaid">
		</cfstoredproc>
		<!---<cfif type eq "EFC"><cfreturn out_result_set.EFC>
		<cfelseif type eq "UFN"><cfreturn out_result_set.Unmet_need>
		<cfelseif type eq "GN"><cfreturn out_result_set.GROSS_NEED>
		<cfelseif type eq "BA"><cfreturn out_result_set.BUDGET>
		</cfif>--->
	<cfcatch>
		<cfinvoke component="scholadmin" method="showerrors" returnvariable="error" />
        <cfoutput>
        <cfmail from="ScholarshipApp <christina@gsu.edu>" to="christina@gsu.edu" server="mailhost.gsu.edu" subject="Error Occurred in Scholarship App" failto="admcmz@langate.gsu.edu">
		<cfif isDefined("error.remoteAddress")>#error.remoteAddress#</cfif>
		<cfif isDefined("error.browser")>#error.browser#</cfif>
	    <cfif isDefined("error.dateTime")>#error.dateTime#</cfif>
	    <cfif isDefined("error.HTTPReferer")>referrer: #error.HTTPReferer#</cfif>
		<cfif isDefined("error.queryString")>#error.queryString#</cfif>
		<cfif isDefined("cookie.campusid")>#cookie.campusid#</cfif>
		<cfif isDefined("Cookie.first_name")>#Cookie.first_name#</cfif>
		<cfif isDefined("Cookie.last_name")>#Cookie.last_name#</cfif>
		<cfif isDefined("Session.gsu_student_id")>#Session.gsu_student_id#</cfif>
		<cfif isDefined("error.diagnostics")>#error.diagnostics#</cfif>
		<cfif isDefined("error.generatedContent")>#error.generatedContent#</cfif>
        #cfcatch.Message# -> #cfcatch.Detail#
		<cfif isDefined("error.diagnostics") and not FindNoCase("Session",error.diagnostics) eq 0>User was notified of session error and redirected to start page</cfif>
		#DateFormat(NOW(), "mm/dd/yyyy")# #TimeFormat(NOW(), "hh:mm tt")#
		</cfmail>
        </cfoutput>
		<cfreturn error>
	</cfcatch>
	</cftry>
    <cfset efc=out_result_set_finaid.EFC>
    <cfset ufn=out_result_set_finaid.Unmet_need>
    <cfset ba=out_result_set_finaid.budget>
    <cfset tn=out_result_set_finaid.gross_need>
	 <cfoutput><tr><td>#NAME#</td><td>#gsuemail#</td><td>#email#</td><td>#converted_id#</td><td>#address1#</td><td>#city1#</td><td>#state1#</td><td>#zip1#</td><td>#phone#</td><td>#bdate#</td><td>#gender#</td><td>#hsgraddate#</td><td>#hs#</td><td>#resstatus#</td><td>#resstate#</td><td>#visatype#</td><td>#religion#</td><td>#ethnicity#</td><td>#marital#</td><td>#major#</td><td>#minor#</td><td>#conc#</td><td>#college#</td><td>#hsgpc#</td><td>#satindex#</td><td>#satverbal#</td><td>#satmath#</td><Td>#actindex#</TD><td>#actcomposite#</td><td>#ogpa#</td><td>#igpa#</td><td>#hgpa#</td><td>#tgpa#</td><td>#enstatus#</td><td>#class#</td><td>#cumcredhours#</td><td>#efc#</td><td>#ufn#</td><td><cfif tn neq "" and isNumeric(tn)><cfif tn lt 0>- </cfif>#dollarformat(tn)#<cfelse><i>No information available.  Please contact the financial aid office.</i></cfif></td><td><cfif ba neq "" and isNumeric(ba)><cfif ba lt 0>- </cfif>#dollarformat(ba)#<cfelse><i>No information available.  Please contact the financial aid office.</i></cfif></td></tr></cfoutput>
 
</cfloop>

 </table>
