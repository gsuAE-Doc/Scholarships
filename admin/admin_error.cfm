<cftry>
	<cfmail from="ScholarshipApp <christina@gsu.edu>" to="christina@gsu.edu" server="mailhost.gsu.edu" subject="Error Occurred in Scholarship App" failto="admcmz@langate.gsu.edu">
		#error.remoteAddress#
		#error.browser#
	    #error.dateTime#
	    referrer: #error.HTTPReferer#
		<cfif isDefined("error.queryString")>#error.queryString#</cfif>
		<cfif isDefined("cookie.campusid")>#cookie.campusid#</cfif>
		<cfif isDefined("Cookie.first_name")>#Cookie.first_name#</cfif>
		<cfif isDefined("Cookie.last_name")>#Cookie.last_name#</cfif>
		<cfif isDefined("Session.gsu_student_id")>#Session.gsu_student_id#</cfif>
		#error.diagnostics#
		#error.generatedContent#
		<cfif not FindNoCase("Session",error.diagnostics) eq 0>User was notified of session error and redirected to start page</cfif>
		#DateFormat(NOW(), "mm/dd/yyyy")# #TimeFormat(NOW(), "hh:mm tt")#
	</cfmail>
	<cfif not isDefined("URL.session_expired") and not isDefined("URL.error_occurred")>
		<cfif not FindNoCase("Session",error.diagnostics) eq 0><cflocation url="index.cfm?session_expired=true">
		<cfelseif error.diagnostics contains "string literal too long">
			<cfif isDefined("Form.policy_id")>
				<cfset policy_id=Form.policy_id>
			<cfelseif isDefined("Form.edit_policy")>
				<cfset policy_id=Form.edit_policy>
			<cfelse>
				<cfset policy_id="">
			</cfif>
			<cflocation url="http://www.gsu.edu/scholarships/">
		<cfelse><cflocation url="http://www.gsu.edu/scholarships/">
		</cfif>
	</cfif>
	<cfcatch>
	<cflocation url="http://www.gsu.edu/scholarships/">
	</cfcatch>
</cftry>
<cfabort>