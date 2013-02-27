<!---<cfsetting enablecfoutputonly="Yes">
<cfcontent type="application/msexcel">
<cfheader name="Content-Disposition" value="filename=applicants.xls">--->

<cfheader name="Content-Disposition" value="inline; filename=applicants.xls">
<cfcontent type="application/vnd.msexcel">

<cffunction name="showerrors">
<cfargument name="banner_error">
	<cfset error="<i>">
	<cfif Find("20101", banner_error)><cfset error=error & "Access Denied">
	<cfelseif Find("20102", banner_error)><cfset error=error & "Confidential Student Info">
	<cfelseif Find("20103", banner_error)><cfset error=error & "Missing Parameter(s).  Please contact the DBA.">
	<cfelseif Find("20104", banner_error)><cfset error=error & "Invalid Parameter.  Please contact the DBA.">
	<cfelseif Find("20105", banner_error)><cfset error=error & "Invalid Student Id">
	<cfelseif Find("20106", banner_error)><cfset error=error & "Bad data present for id.  This is an internal database error.  Please contact the DBA.">
	<cfelseif Find("20107", banner_error)><cfset error=error & "20107 Unknown exception. This is an internal database error.  Please contact the DBA.">
	<cfelseif Find("20108", banner_error)><cfset error=error & "No Active Academic Info For Student">
	<cfelseif Find("20109", banner_error)><cfset error=error & "No Registration Info For Student">
	<cfelseif Find("1034", banner_error) or Find("7429", banner_error)>
		<!---<cfmail
		from="christina@gsu.edu"
		replyto = "christina@gsu.edu"
		to="christina@gsu.edu"
		bcc="christina@gsu.edu"
		subject="Banner Down"
		SERVER="mailhost.gsu.edu">
		The student has been redirected to the scholarships home page.
		
		<cfif isDefined("Cookie.campusid")><cfoutput>#Cookie.campusid#</cfoutput></cfif>
		</cfmail>--->
		<cflocation url="banner_down.cfm">
		<cfexit>
	<cfelse>
		<cfset error=error & banner_error>
	</cfif>
	<cfset error=error & "</i>">
	<cfreturn error>
</cffunction>

 
 <cfinvoke component="scholadmin" method="getResetDate" returnvariable="resetdate" />
 
 <cfset additional_params="">
 <cfif isDefined("URL.completed")><cfset additional_params="and completed='true'"></cfif>
 <cfif isDefined("URL.num")>
	<cfif isDefined("URL.completed")>
		<cfif URL.num eq "1">
			<cfset additional_params=" and ascii(upper(substr(last_name, 1, 1))) < 72 ">
		<cfelseif URL.num eq "2">
			<cfset additional_params=" and ascii(upper(substr(last_name, 1, 1))) > 71 and ascii(upper(substr(last_name, 1, 1))) < 81 ">
		<cfelseif URL.num eq "3">
			<cfset additional_params=" and ascii(upper(substr(last_name, 1, 1))) > 80 ">
		</cfif>
	<cfelse>
		<cfif URL.num eq "1">
			<cfset additional_params=" and ascii(upper(substr(last_name, 1, 1))) < 71 ">
		<cfelseif URL.num eq "2">
			<cfset additional_params=" and ascii(upper(substr(last_name, 1, 1))) > 70 and ascii(upper(substr(last_name, 1, 1))) < 79 ">
		<cfelseif URL.num eq "3">
			<cfset additional_params=" and ascii(upper(substr(last_name, 1, 1))) > 78 and ascii(upper(substr(last_name, 1, 1))) < 83 ">
		<cfelseif URL.num eq "4">
			<cfset additional_params=" and ascii(upper(substr(last_name, 1, 1))) > 82 ">
		</cfif>
	</cfif>
 </cfif>
 
 <cfquery name="GetScholName" datasource="scholarships">
	select title from scholarships where scholarship_id=#URL.review_applicants#
</cfquery>
 <cfquery name="GetSchols" datasource="scholarships">
		select * from applications, students where applications.student_id=students.student_id and scholarship_id=#URL.review_applicants# <!---and ascii(upper(substr(last_name, 1, 1))) < 71--->  and application_start_date > to_date('#resetdate#')  #PreserveSingleQuotes(additional_params)# order by last_name
	</cfquery>
 
 <!--- output data using cfloop & cfoutput --->
 <table border="0">
 	<tr>
		<td>FIRST NAME</td><td>MIDDLE NAME</td><td>LAST NAME</td><td>GSU EMAIL</td><td>PREFERRED EMAIL</td><td>STUDENT ID</td><td>ADDRESS1</td><td>CITY</td><td>STATE</td><td>ZIP</td><td>COUNTY</td><td>PHONE</td><td>Birth Date</td><td>Gender</td><td>HS Grad Date</td><td>HS</td><td>RESIDENCY STATUS</td><td>RESIDENCY STATE</td><td>VISA TYPE</td><td>RELIGIOUS AFFILIATION</td><td>ETHNICITY</td><td>MARITAL STATUS</td><td>MAJOR</td><td>MINOR</td><td>CONCENTRATION</td><td>COLLEGE AFFILIATION</td><td>HS GPA</td><td>SAT FRESHMAN INDEX</td><td>SAT VERBAL/CRITICAL READING</td><td>SAT MATHEMATICS</td><td>ACT FRESHMAN INDEX</td><td>ACT COMPOSITE</td><td>OVERALL GSU GPA</td><td>INSTITUTIONAL GPA</td><td>HOPE GPA</td><td>TRANSFER GPA</td><td>ENROLLMENT STATUS</td><td>CLASSIFICATION</td><td>CUM. CREDIT HOURS</td><td>EFC</td><td>UNMET FINANCIAL NEED</td><td>TOTAL NEED</td><td>BUDGET AMOUNT</td>
<cfquery name="getCustomInfo" datasource="scholarships">
	select * from scholarships_custominfo, custom_information where info_type <> 'fileupload' and custominfo_id=info_id and scholarship_id=#URL.review_applicants#
</cfquery>
<cfset infoids=ValueList(getCustomInfo.info_id)>
<cfset infotypes=ValueList(getCustomInfo.info_type)>
<cfoutput query="getCustomInfo">
	<td>#custom_info#</td>
</cfoutput>
<td>EMPLOYER</td><td>EMPLOYER ADDRESS 1</td><td>EMPLOYER ADDRESS 2</td><td>CITY</td><td>STATE</td><td>EMPLOY BEGIN DATE</td><td> EMPLOY END DATE</td><td>APPLICATION_START_DATE</td><td>APPLICATION_SUBMIT_DATE</td><td>SCHOLARSHIP NAME</td><td>Essay Name</td>
	</tr>
	<cfset count=0>
	<cfset curyear=year(NOW())>
	<cfset nextyear=(curyear + 1)>
	<cfset lastyear=(curyear - 1)>
	<cfset curabbyear=Right(curyear, 2)>
	<cfset nextabbyear=Right(nextyear, 2)>
	<cfset lastabbyear=Right(lastyear, 2)>
	<cfif #Month(NOW())# gte 7><cfset yearparam=curabbyear&nextabbyear>
	<cfelse><cfset yearparam=lastabbyear&curabbyear></cfif>
	
	
<cfloop query="GetSchols">
	
	<cfset converted_id=NumberFormat(#GSU_STUDENT_ID#, "000000000")>
	<!---<cfinvoke component="scholadmin" method="convertStudentID" tempgsustudentid="#GSU_STUDENT_ID#" returnvariable="converted_id" />--->
	<cfif converted_id eq 111111111><cfcontinue></cfif>
	
	<cfset count=count+1>

	<cftry>
	<cfstoredproc  procedure="wwoksrpt.p_get_scholrpt" datasource="SCHOLARSHIPAPI">
	<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_student_id" type="in" value="#converted_id#">
	<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="in_aidy_code" type="in" value="#yearparam#">
	<cfprocresult name="f_get_addr_out" resultset="1">
	<cfprocresult name="f_get_all_email_out" resultset="2">
	<cfprocresult name="f_get_tele_out" resultset="3">
	<cfprocresult name="f_get_pers_out" resultset="4">
	<cfprocresult name="f_get_hsch_out" resultset="5">
	<cfprocresult name="f_get_residency_out" resultset="6">
	<cfprocresult name="f_get_international_out" resultset="7">
	<cfprocresult name="f_get_academic_out" resultset="8">
	<cfprocresult name="F_GET_TEST_SFI" resultset="9">
	<cfprocresult name="F_GET_TEST_S01" resultset="10">
	<cfprocresult name="F_GET_TEST_S02" resultset="11">
	<cfprocresult name="F_GET_TEST_AFI" resultset="12">
	<cfprocresult name="F_GET_TEST_A05" resultset="13">
	<cfprocresult name="F_GET_LGPA_OVERALL" resultset="14">
	<cfprocresult name="F_GET_LGPA_INST" resultset="15">
	<cfprocresult name="F_GET_LGPA_TRANS" resultset="16">
	<cfprocresult name="F_GET_HOPE_GPA" resultset="17">
	<cfprocresult name="f_get_reg_hrs_out" resultset="18">
	<cfprocresult name="f_get_classification_out" resultset="19">
	<cfprocresult name="f_get_faid_out" resultset="20">
	<cfprocparam cfsqltype="CF_SQL_VARCHAR" dbvarname="error_code" type="out">
	</cfstoredproc>
	
	

	
	<cfset address1=f_get_addr_out.STREET_LINE1>
	<cfif f_get_addr_out.street_line2 neq ""><cfset address1=address1&" "&#f_get_addr_out.street_line2#></cfif>
	<cfif f_get_addr_out.street_line3 neq ""><cfset address1=address1&" "&#f_get_addr_out.street_line3#></cfif>
			
	<cfif isSimpleValue(f_get_academic_out) eq "YES">
		<cfset major = "<i>#f_get_academic_out#</i>">
	<cfelse>
		<cfset major="#f_get_academic_out.majr_code_1#">
		<cfif f_get_academic_out.majr_code_2 neq ""><cfset major=major & ", #f_get_academic_out.majr_code_2#"></cfif>
		<cfif f_get_academic_out.majr_code_1_2 neq ""><cfset major=major & ", #f_get_academic_out.majr_code_1_2#"></cfif>
		<cfif f_get_academic_out.majr_code_2_2 neq ""><cfset major=major & ", #f_get_academic_out.majr_code_2_2#"></cfif>
	</cfif>
	<cfif isSimpleValue(f_get_academic_out) eq "YES">
		<cfset minor = "<i>#f_get_academic_out#</i>">
	<cfelse>
		<cfset minor="#f_get_academic_out.MAJR_CODE_MINR_1# ">
		<cfif f_get_academic_out.MAJR_CODE_MINR_1_2 neq ""><cfset minor=minor&" #f_get_academic_out.MAJR_CODE_MINR_1_2# "></cfif>
		<cfif f_get_academic_out.majr_code_1_2 neq ""><cfset minor=minor&" #f_get_academic_out.MAJR_CODE_MINR_2# "></cfif>
		<cfif f_get_academic_out.MAJR_CODE_MINR_2_2 neq ""><cfset minor=minor&" #f_get_academic_out.MAJR_CODE_MINR_2_2# "></cfif>
	</cfif>
	
	<cfif isSimpleValue(f_get_academic_out) eq "YES">
		<cfset conc = "<i>#f_get_academic_out#</i>">
	<cfelse>
		<cfset conc="">
		<cfif f_get_academic_out.majr_code_conc_1 neq "">
			<cfif isDefined("nolabel") and nolabel eq ""><cfset conc=conc & "with concentration: ">
			</cfif>
			<cfset conc=conc & "#f_get_academic_out.majr_code_conc_1#">
		</cfif>
		<cfif f_get_academic_out.majr_code_conc_1_2 neq ""><cfset conc=conc & " and #f_get_academic_out.majr_code_conc_1_2#"></cfif>
		<cfif f_get_academic_out.majr_code_conc_1_3 neq ""><cfset conc=conc & " and #f_get_academic_out.majr_code_conc_1_3#"></cfif>
		<cfif f_get_academic_out.majr_code_conc_2 neq ""><cfset conc=conc & " and #f_get_academic_out.majr_code_conc_2#"></cfif>
		<cfif f_get_academic_out.majr_code_conc_2_2 neq ""><cfset conc=conc & " and #f_get_academic_out.majr_code_conc_2_2#"></cfif>
		<cfif f_get_academic_out.majr_code_conc_2_3 neq ""><cfset conc=conc & " and #f_get_academic_out.majr_code_conc_2_3#"></cfif>
		<cfif f_get_academic_out.majr_code_conc_121 neq ""><cfset conc=conc & " and #f_get_academic_out.majr_code_conc_121#"></cfif>
		<cfif f_get_academic_out.majr_code_conc_122 neq ""><cfset conc=conc & " and #f_get_academic_out.majr_code_conc_122#"></cfif>
		<cfif f_get_academic_out.majr_code_conc_123 neq ""><cfset conc=conc & " and #f_get_academic_out.majr_code_conc_123#"></cfif>
		<cfif f_get_academic_out.majr_code_conc_221 neq ""><cfset conc=conc & " and #f_get_academic_out.majr_code_conc_221#"></cfif>
		<cfif f_get_academic_out.majr_code_conc_222 neq ""><cfset conc=conc & " and #f_get_academic_out.majr_code_conc_222#"></cfif>
		<cfif f_get_academic_out.majr_code_conc_223 neq ""><cfset conc=conc & " and #f_get_academic_out.majr_code_conc_223#"></cfif>
	</cfif>
	<cfif isSimpleValue(f_get_academic_out) eq "YES">
		<cfset college = "<i>#f_get_academic_out#</i>">
	<cfelse>
		<cfset college="">
		<cfif f_get_academic_out.coll_code_1_desc neq ""><cfset college=college &" #f_get_academic_out.coll_code_1_desc#"></cfif>
		<cfif isDefined("f_get_academic_out.coll_code_2_desc") and isDefined("out_result_set_coll_code_2_desc") and f_get_academic_out.coll_code_2_desc neq "" and f_get_academic_out.coll_code_2_desc neq f_get_academic_out.coll_code_1_desc><cfset college=college & " and #out_result_set.coll_code_2_desc#"></cfif>
	</cfif>
	
	<cfif f_get_reg_hrs_out.reg_hours gte 12><cfset enstatus="full-time">
	<cfelseif f_get_reg_hrs_out.reg_hours eq 0><cfset enstatus="not enrolled this semester">
	<cfelse><cfset enstatus="part-time"></cfif>
		              
<cfoutput><tr>
<td>#FIRST_NAME#</td><td>#MIDDLE_NAME#</td><td>#LAST_NAME#</td>
<td><cfif isDefined("f_get_all_email_out.email_address")>#f_get_all_email_out.email_address#<cfelseif isDefined("f_get_all_email_out.error")><cfinvoke method="showerrors" banner_error="#f_get_all_email_out.error#" returnvariable="error" />#error#</cfif></td>
<td>#email_address#</td>
<td>#converted_id#</td>
<td>#address1#</td>
<td><cfif isDefined("f_get_addr_out.city")>#f_get_addr_out.city#<cfelseif isDefined("f_get_addr_out.error")></cfif></td>
<td><cfif isDefined("f_get_addr_out.state")>#f_get_addr_out.state#<cfelseif isDefined("f_get_addr_out.error")></cfif></td>
<td><cfif isDefined("f_get_addr_out.zip")>#f_get_addr_out.zip#<cfelseif isDefined("f_get_addr_out.error")></cfif></td>
<td>#county#</td>
<td><cfif isDefined("f_get_tele_out.phone_number")>(#f_get_tele_out.phone_area#)  #f_get_tele_out.phone_number#<cfelseif isDefined("f_get_tele_out.error")><cfinvoke method="showerrors" banner_error="#f_get_tele_out.error#" returnvariable="error" />#error#</cfif></td>
<td><cfif isDefined("f_get_pers_out.birth_date")>#DateFormat(f_get_pers_out.birth_date, "mm/dd/yyyy")#<cfelseif isDefined("f_get_pers_out.error")><cfinvoke method="showerrors" banner_error="#f_get_pers_out.error#" returnvariable="error" />#error#</cfif></td>
<td><cfif isDefined("f_get_pers_out.gender")>#f_get_pers_out.gender#<cfelseif isDefined("f_get_pers_out.error")><cfinvoke method="showerrors" banner_error="#f_get_pers_out.error#" returnvariable="error" />#error#</cfif></td>
<td><cfif isDefined("f_get_hsch_out.HS_GRADUATION_DATE")>#DateFormat(f_get_hsch_out.HS_GRADUATION_DATE, "mm/dd/yyyy")#<cfelseif isDefined("f_get_hsch_out.error")><cfinvoke method="showerrors" banner_error="#f_get_hsch_out.error#" returnvariable="error" />#error#</cfif></td>
<td><cfif isDefined("f_get_hsch_out.HS_CODE")>#f_get_hsch_out.HS_CODE#<cfelseif isDefined("f_get_hsch_out.error")><cfinvoke method="showerrors" banner_error="#f_get_hsch_out.error#" returnvariable="error" />#error#</cfif></td>
<td><cfif isDefined("f_get_pers_out.CITZ_CODE_DESC")>#f_get_pers_out.CITZ_CODE_DESC#<cfelseif isDefined("f_get_pers_out.error")><cfinvoke method="showerrors" banner_error="#f_get_pers_out.error#" returnvariable="error" />#error#</cfif></td>
<td><cfif isDefined("f_get_residency_out.state_code")>#f_get_residency_out.state_code#<cfelseif isDefined("f_get_residency_out.error")><cfinvoke method="showerrors" banner_error="#f_get_residency_out.error#" returnvariable="error" />#error#</cfif></td>
<td><cfif isDefined("f_get_pers_out.visa_type")>#f_get_pers_out.visa_type#<cfelseif isDefined("f_get_pers_out.error")><cfinvoke method="showerrors" banner_error="#f_get_pers_out.error#" returnvariable="error" />#error#</cfif></td>
<td><cfif isDefined("f_get_pers_out.RELG_CODE")>#f_get_pers_out.RELG_CODE#<cfelseif isDefined("f_get_pers_out.error")><cfinvoke method="showerrors" banner_error="#f_get_pers_out.error#" returnvariable="error" />#error#</cfif></td>
<td><cfif isDefined("f_get_pers_out.ETHN_CODE")>#f_get_pers_out.ETHN_CODE#<cfelseif isDefined("f_get_pers_out.error")><cfinvoke method="showerrors" banner_error="#f_get_pers_out.error#" returnvariable="error" />#error#</cfif></td>
<td><cfif isDefined("f_get_pers_out.MRTL_CODE")>#f_get_pers_out.MRTL_CODE#<cfelseif isDefined("f_get_pers_out.error")><cfinvoke method="showerrors" banner_error="#f_get_pers_out.error#" returnvariable="error" />#error#</cfif></td>
<td>#major#</td>
<td>#minor#</td>
<td>#conc#</td>
<td>#college#</td>
<td><cfif isDefined("f_get_hsch_out.HS_GPA")>#DecimalFormat(f_get_hsch_out.HS_GPA)#<cfelseif isDefined("f_get_hsch_out.error")><cfinvoke method="showerrors" banner_error="#f_get_hsch_out.error#" returnvariable="error" />#error#</cfif></td>
<td><cfif isDefined("F_GET_TEST_SFI.test_score")>#F_GET_TEST_SFI.test_score#<cfelseif isDefined("F_GET_TEST_SFI.error")><cfinvoke method="showerrors" banner_error="#F_GET_TEST_SFI.error#" returnvariable="error" />#error#</cfif></td>
<td><cfif isDefined("F_GET_TEST_S01.test_score")>#F_GET_TEST_S01.test_score#<cfelseif isDefined("F_GET_TEST_S01.error")><cfinvoke method="showerrors" banner_error="#F_GET_TEST_S01.error#" returnvariable="error" />#error#</cfif></td>
<td><cfif isDefined("F_GET_TEST_S02.test_score")>#F_GET_TEST_S02.test_score#<cfelseif isDefined("F_GET_TEST_S02.error")><cfinvoke method="showerrors" banner_error="#F_GET_TEST_S02.error#" returnvariable="error" />#error#</cfif></td>
<Td><cfif isDefined("F_GET_TEST_AFI.test_score")>#F_GET_TEST_AFI.test_score#<cfelseif isDefined("F_GET_TEST_AFI.error")><cfinvoke method="showerrors" banner_error="#F_GET_TEST_AFI.error#" returnvariable="error" />#error#</cfif></TD>
<td><cfif isDefined("F_GET_TEST_A05.test_score")>#F_GET_TEST_A05.test_score#<cfelseif isDefined("F_GET_TEST_A05.error")><cfinvoke method="showerrors" banner_error="#F_GET_TEST_A05.error#" returnvariable="error" />#error#</cfif></td>
<td align="center"><cfif isDefined("F_GET_LGPA_OVERALL.gpa")>#DecimalFormat(F_GET_LGPA_OVERALL.gpa)#<cfelseif isDefined("F_GET_LGPA_OVERALL.error")><cfinvoke method="showerrors" banner_error="#f_get_lgpa_overall.error#" returnvariable="error" />#error#</cfif></td>
<td align="center"><cfif isDefined("F_GET_LGPA_INST.gpa")>#DecimalFormat(F_GET_LGPA_INST.gpa)#<cfelseif isDefined("F_GET_LGPA_INST.ERROR")><cfinvoke method="showerrors" banner_error="#F_GET_LGPA_INST.error#" returnvariable="error" />#error#</cfif></td>
<td align="center"><cfif isDefined("F_GET_HOPE_GPA.gpa")>#DecimalFormat(F_GET_HOPE_GPA.gpa)#<cfelseif isDefined("F_GET_HOPE_GPA.ERROR")><cfinvoke method="showerrors" banner_error="#F_GET_HOPE_GPA.error#" returnvariable="error" />#error#</cfif></td>
<td align="center"><cfif isDefined("F_GET_LGPA_TRANS.gpa")>#DecimalFormat(F_GET_LGPA_TRANS.gpa)#<cfelseif isDefined("F_GET_LGPA_TRANS.ERROR")><cfinvoke method="showerrors" banner_error="#F_GET_LGPA_TRANS.error#" returnvariable="error" />#error#</cfif></td>
<td>#enstatus#</td>
<td><cfif isDefined("f_get_classification_out.classification")>#f_get_classification_out.CLASSIFICATION#<cfelseif isDefined("f_get_classification_out.ERROR")><cfinvoke method="showerrors" banner_error="#f_get_classification_out.error#" returnvariable="error" />#error#</cfif></td>
<td><cfif isDefined("f_get_lgpa_overall.gpa_hours")>#F_GET_LGPA_OVERALL.gpa_hours#<cfelseif isDefined("f_get_lgpa_overall.error")><cfinvoke method="showerrors" banner_error="#f_get_lgpa_overall.error#" returnvariable="error" />#error#</cfif></td>
<td>#f_get_faid_out.efc#</td>
<td>#f_get_faid_out.unmet_need#</td>
<td><cfif f_get_faid_out.gross_need neq "" and isNumeric(f_get_faid_out.gross_need)><cfif f_get_faid_out.gross_need lt 0>- </cfif>#dollarformat(f_get_faid_out.gross_need)#<cfelse><i>No information available.  Please contact the financial aid office.</i></cfif></td>
<td><cfif f_get_faid_out.budget neq "" and isNumeric(f_get_faid_out.budget)><cfif f_get_faid_out.budget lt 0>- </cfif>#dollarformat(f_get_faid_out.budget)#<cfelse><i>No information available.  Please contact the financial aid office.</i></cfif></td></cfoutput>

<cfloop list="#infoids#" index="info_id">
	<cfset infoindex=ListFind(infoids, info_id)>
	<cfif info_id neq "">
		<cfquery name="getCustomInfo1" datasource="scholarships">
			select * from applications, applications_custominfo where applications.application_id=applications_custominfo.application_id and scholarship_id=#URL.review_applicants# and custominfo_id=#info_id# and applications.application_id=#GetSchols.application_id#
		</cfquery>
		<cfif getCustomInfo1.RecordCount eq 0>
			<td>&nbsp;</td>
		<cfelse>
			<cfoutput query="getCustomInfo1">
				<td nowrap><cfif isDefined("#ListGetAt(infotypes, infoindex)#_value")>#Evaluate("#ListGetAt(infotypes, infoindex)#_value")#</cfif></td>
			</cfoutput>
		</cfif>
	</cfif>
</cfloop>

<!---make sure all custom info fields exist or fill in blank spaces
<cfquery name="getCustomInfoReal" datasource="scholarships">
	select * from scholarships_custominfo, custom_information where info_type <> 'fileupload' and custominfo_id=info_id and scholarship_id=#URL.review_applicants#
</cfquery>
<cfif getCustomInfo.RecordCount lt getCustomInfoReal.RecordCount>
	<cfset numneeded=getCustomInfoReal.RecordCount - getCustomInfo.RecordCount>
	<cfloop from="1" to="#numneeded#" index="itemp">
		<td>&nbsp;</td>
	</cfloop>
</cfif>--->
<!----            ---->

<cfoutput><td>#employer#</td><td>#employer_address1#</td><td>#employer_address2#</td><td>#city#</td><td>#state#</td><td>#DateFormat(employ_begin_date, "mmmm d, yyyy")#</td><td>#DateFormat(employ_end_date, "mmmm d, yyyy")#</td><td>#DateFormat(application_start_date, "mmmm d, yyyy")#</td><td>#DateFormat(application_submit_date, "mmmm d, yyyy")#</td></cfoutput>

<cfquery name="getDeletedQuestions" datasource="scholarships">
    select * from applications_custominfo where application_id=#getSchols.application_id# and (textfield_value is not null or textbox_value is not null or date_value is not null) and custominfo_id not in (select info_id from custom_information, scholarships_custominfo where info_id=custominfo_id and scholarship_id=#getSchols.scholarship_id# and custom_information.info_type<>'fileupload')
</cfquery>
<cfoutput query="getDeletedQuestions">
 	<cfif textfield_value neq "">
		<td>#getDeletedQuestions.textfield_value#</td>
    <cfelseif date_value neq "">
        <td>#DateFormat(ParseDateTime(getDeletedQuestions.date_value), 'mm/dd/yyyy')#</td>
    <cfelseif textbox_value neq "">
        <td>#getDeletedQuestions.textbox_value#</td>
    </cfif>
 </cfoutput>
 
	<cfcatch>
	
	
	
	
	
	
	<cfoutput><td><cfinvoke component="scholadmin" method="getName" gsustudentid="#converted_id#" /></td><td> </td><td> </td><td> </td><td> </td><td>#converted_id#</td><td colspan="52">Error</td></cfoutput>
	
	<cfif isDefined("Cookie.campusid")><!---put in this if 2/22/2013, sends e-mail once--->
		<cfmail
			from="The Scholarship Office <scholarships@gsu.edu>"
			replyto = "The Scholarship Office <scholarships@gsu.edu>"
			to="christina@gsu.edu"
			subject="error"
			SERVER="mailhost.gsu.edu"
			>
			#cfcatch.message# -> #cfcatch.detail#
			<cfif isDefined("converted_id")>student: #converted_id#</cfif>
			<cfif isDefined("Cookie.campusid")>#Cookie.campusid#</cfif>
			#GetScholName.title#
		</cfmail>
	</cfif>
	
	
	
	
	
	
	
	
	
	
	</cfcatch>
	</cftry>
	<cfoutput><td>#GetScholName.title#</td>
	<cfquery name="getEssayName" datasource="scholarships">
		select file_name from applications_custominfo where custominfo_id in (select info_id from custom_information where info_type='fileupload') and application_id=#GetSchols.application_id#
	</cfquery>
	<td><cfif getEssayName.RecordCount gt 0 and isDefined("getEssayName.file_name")>#getEssayName.file_name#<cfelse>&nbsp;</cfif></td>
	</cfoutput>
 </tr>

</cfloop>

     
 </table>
 
 
 <cfset intRunTimeInSeconds = DateDiff(
"s",
GetPageContext().GetFusionContext().GetStartTime(),
Now()
) />
<cfoutput>running for: #intRunTimeInSeconds# seconds for count #count#</cfoutput>
