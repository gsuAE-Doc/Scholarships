<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>Untitled</title>
	<style type="text/css">
		body{
			font-family: arial, sans-serif
		}
	</style>
</head>

<body>

<cfif URL.definition eq "efc">
<h2>EFC</h2>
The Expected Family Contribution (EFC) is a measure of your family’s financial strength and is calculated according to a formula established by law. Your family's taxed and untaxed income, assets, and benefits (such as unemployment or Social Security) are all considered in the formula. Also considered are your family size and the number of family members who will attend college or career school during the year. <br><br>
For more information and helpful hints, <a target="_blank" href="http://www.fafsa.ed.gov/map.htm">click here</a>.
<cfelseif URL.definition eq "budget_amount">
<h2>Budget Amount</h2>
An estimate covering tuition, fees, room and board, books, supplies, transportation and miscellaneous expenses of the total amount it should cost a student to go to school.
<cfelseif URL.definition eq "total_need">
<h2>Total Need or Financial Aid Need</h2>
The difference between the Cost of Attendance and the Estimated Family Contribution which is used to determine a student’s financial aid package.
<cfelseif URL.definition eq "unmet_need">
<h2>Unmet Need</h2>
 The amount of financial aid eligibility that is not provided by the Office of University Scholarships and Financial Aid.  The unmet amount is the difference between the Cost of Attendance and the Expected Family Contribution.
</cfif>

</body>
</html>
