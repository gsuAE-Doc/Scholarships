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

<h2>Please confirm the Awardee's Name(s) and Amount(s)</h2>
You are about to notify the following people of their Scholarship Awards.  Look at the table below and make sure that the award amounts are correct.  Once you confirm this list, the students will be notified.
<br><br>
Awardee Name 1<br>
Awardee Name 2<br><br>
<!--first go to next page and submit awards, then say parent.parent.document.location=''-->
<input type="button" value="CONFIRM" onclick="parent.parent.awardeeForm.submit();"> 
<input type="button" value="GO BACK" onclick="parent.parent.GB_hide();">

</body>
</html>
