var xmlHttp;
var count;
var responseText;
count=0;


function validateScholarshipApplication()
{
	if (document.applicationForm.county.value == ""){
		alert("Please fill in your county of residence.");
		return false;
	}
	var email=document.applicationForm.email.value;
	if (email == ""){
		alert("Please fill in your e-mail address.");
		return false;
	}
	var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
	if (!filter.test(email)) {
		alert("Please enter a valid email.");
		return false;
	}
	//required questions
	var requiredfields = document.getElementById("requiredCustomFields").value;
	var valueArray = requiredfields.split(",");
	for(var i=0; i<valueArray.length; i++){
	if (valueArray[i]!="" && eval("document.applicationForm.short_answer_file_"+valueArray[i]) != undefined){
		//var styledisplay = eval("document.applicationForm.short_answer_file_"+valueArray[i]+".style.display");
		
		if (eval(document.getElementById("uploadFileField_"+valueArray[i])==undefined)) var styledisplay="true"
		else var styledisplay=eval("document.applicationForm.short_answer_file_"+valueArray[i]+".style.display");

		//alert(styledisplay);
		  if (eval("document.applicationForm.short_answer_file_"+valueArray[i]) != undefined && eval("document.applicationForm.short_answer_file_"+valueArray[i]+".value")=="" && styledisplay != "none" && styledisplay != ""){
				alert("Please enter the required scholarship-specific documents.  If it is a recommendation that a faculty member must upload, you must wait until that happens before continuing.");
		  	 	return false;
			}
		}
		  if (eval("document.applicationForm.custominfo_"+valueArray[i]) != undefined && eval("document.applicationForm.custominfo_"+valueArray[i]+".value")==""){
			 alert("Please fill out the required scholarship-specific questions.");
		  	 return false;
		  }
	
	}
	//student determined (optional/required) questions
	var myform=document.applicationForm;
	var requiredfields = document.getElementById("studentDeterminedCustomFields").value;
	var valueArray = requiredfields.split(",");
	for(var i=0; i<valueArray.length; i++){
		if (valueArray[i]=="")continue;
		//alert(valueArray[i]);
		//alert(document.getElementById("studDet_"+valueArray[i]+"_yes").checked);
		//alert(document.getElementById("studDet_"+valueArray[i]+"_no").checked);
		if (document.getElementById("studDet_"+valueArray[i]+"_yes").checked==false && document.getElementById("studDet_"+valueArray[i]+"_no").checked==false){
			var questiontype="question";
			if (myform["short_answer_file_"+valueArray[i]]!=undefined) questiontype="document";
			alert("Please indicate whether your scholarship-specific " + questiontype + " is required or not.");
			return false;
		}
		//alert(document.getElementById("studDet_"+valueArray[i]+"_yes").checked);
		if (document.getElementById("studDet_"+valueArray[i]+"_yes").checked==true){
			if (valueArray[i]!="" && eval("document.applicationForm.short_answer_file_"+valueArray[i]) != undefined){
				//var styledisplay = eval("document.applicationForm.short_answer_file_"+valueArray[i]+".style.display");
				
				if (eval(document.getElementById("uploadFileField_"+valueArray[i])==undefined)) var styledisplay="true"
				else var styledisplay=eval("document.applicationForm.short_answer_file_"+valueArray[i]+".style.display");
		
				//alert(styledisplay);
				  if (eval("document.applicationForm.short_answer_file_"+valueArray[i]) != undefined && eval("document.applicationForm.short_answer_file_"+valueArray[i]+".value")=="" && styledisplay != "none" && styledisplay != ""){
						alert("Please enter the required scholarship-specific documents.  If it is a recommendation that a faculty member must upload, you must wait until that happens before continuing.");
						return false;
				}
			}
			if (eval("document.applicationForm.custominfo_"+valueArray[i]) != undefined && eval("document.applicationForm.custominfo_"+valueArray[i]+".value")==""){
			       alert("Please fill out the required scholarship-specific questions.");
			       return false;
			}	
		}
		
	}
	if (document.getElementById("signature").checked==false){
		alert("Please sign your application by clicking the checkbox at the bottom.");
		return false;
	}
	
	var answer = confirm("Once you submit an application, you can not make any further changes.  Are you sure you are ready to submit this application?");
	if (answer){
		return true;
	}
	else{
		alert ("Application not submitted.");
		return false;
	}
	//return true;
}
function submitAwardAmounts(){
	var theform=document.awardeeForm;
	for(i=0; i<theform.elements.length; i++)
	{
		if (theform.elements[i].type=="text" && theform.elements[i].value!=""){
			if (isNaN(theform.elements[i].value)){
				alert("Please enter all numbers");
				return false;
			}
			else{
				theform.elements[i].value=parseFloat(theform.elements[i].value).toFixed(2);
			}
		}
	}
	/*var count=1;
	var pagelink="/scholarships/admin/popup/popup.cfm?";
	for(i=0; i<theform.elements.length; i++)
	{	
		if (theform.elements[i].type=="text"){
			if (count>1) pagelink = pagelink + "&";
			pagelink = pagelink + "awardee" + count + "id=" + theform.elements[i].name;
			pagelink = pagelink + "&awardee" + count + "amount=" + theform.elements[i].value;
			count++;
		}
	}
	document.getElementById("greyboxlink").onclick="document.location='"+pagelink+"';return false;";
	alert(pagelink);*/
	
	
	
	//took out 5/11/2012 to do differently fireEvent(document.getElementById("greyboxlink"),'click');
}
function changeUserAccess(user_id){
	xmlHttp=createResponseObject();
	count=Math.floor(Math.random()*999999999999999999999);
	var useraccessSelect=document.getElementById("accountType");
	var url="/scholarships/admin/makeChanges.cfm?count=" + count + "&editUserAccess=" + user_id + "&access=" + useraccessSelect[useraccessSelect.selectedIndex].value;
	//alert (url);
	xmlHttp.open("GET",url,false);
	xmlHttp.onreadystatechange = function(){};
	xmlHttp.send(null);
}
function changeEmailBackToDefault(scholarship_id, email_type){
	xmlHttp=createResponseObject();
	count=Math.floor(Math.random()*999999999999999999999);
	var url="/scholarships/admin/makeChanges.cfm?count=" + count + "&resetEmailToDefault=" + scholarship_id + "&email_type=" + email_type;
	//alert (url);
	xmlHttp.open("GET",url,false);
	xmlHttp.onreadystatechange = function(){};
	xmlHttp.send(null);
}
function fireEvent(obj,evt){

	var fireOnThis = obj;
	if( document.createEvent ) {
		var evObj = document.createEvent('MouseEvents');
		evObj.initEvent( evt, true, false );
		fireOnThis.dispatchEvent(evObj);
	} else if( document.createEventObject ) {
		fireOnThis.fireEvent('on'+evt);
	}
}
function updateDescription(scholarship_id, type)
{
	if (type=="brief"){
		var fckEditor = FCKeditorAPI.GetInstance('brief_description');
		var desctext = fckEditor.EditorDocument.body.innerHTML;
		var strlen = desctext.length;
		if (strlen > 200){
			alert("You have entered "+strlen+" characters.  Please enter 200 or less characters.");
			return false;
		}
	}
	xmlHttp=createResponseObject();
	count=Math.floor(Math.random()*999999999999999999999);
	var fckEditor = FCKeditorAPI.GetInstance(type+'_description');
	var desc = fckEditor.EditorDocument.body.innerHTML;
	//return false;
	var url="makeChanges.cfm";
	var params="count="+count;
	params=params+"&scholID="+scholarship_id;
	params=params+"&desc_type="+type;
	params=params+"&update_description="+escape(desc);
	xmlHttp.open("POST",url,true);
	//Send the proper header information along with the request
	xmlHttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	xmlHttp.setRequestHeader("Content-length", params.length);
	xmlHttp.setRequestHeader("Connection", "close");
	
	xmlHttp.onreadystatechange = function() {//Call a function when the state changes.
		if(xmlHttp.readyState == 4 && xmlHttp.status == 200) {
			if (trim(xmlHttp.responseText)!="") alert(trim(xmlHttp.responseText));
		}
	}
	xmlHttp.send(params);
	document.getElementById(type+"_desc_conf").innerHTML="Your description has been saved.";
}







function deleteScholarshipRow(r){
	var confirmation=confirm("Are you sure you would like to completely delete this scholarship?");
	if (confirmation==true)
	{
		xmlHttp=createResponseObject();
		count=Math.floor(Math.random()*999999999999999999999);
		var url="/scholarships/admin/makeChanges.cfm?count=" + count + "&deleteScholarship=" + r.id;
		//alert (url);
		xmlHttp.open("GET",url,false);
		xmlHttp.onreadystatechange = function(){};
		xmlHttp.send(null);
		deleteTableRow("scholarshipTable", r);
	}
	else alert ("The scholarship has not been deleted.");
}
function deleteCategoryRow(r){
	var confirmation=confirm("Are you sure you would like to completely delete this category?");
	if (confirmation==true)
	{
		xmlHttp=createResponseObject();
		count=Math.floor(Math.random()*999999999999999999999);
		var url="/scholarships/admin/makeChanges.cfm?count=" + count + "&deleteExternalCategory=" + r.id;
		//alert (url);
		xmlHttp.open("GET",url,false);
		xmlHttp.onreadystatechange = function(){};
		xmlHttp.send(null);
		deleteTableRow("categoryTable", r);
	}
	else alert ("The category has not been deleted.");
}
function deleteOptionalInfo(r){
	var confirmation=confirm("Are you sure you would like to completely delete this category?");
	if (confirmation==true)
	{
		xmlHttp=createResponseObject();
		count=Math.floor(Math.random()*999999999999999999999);
		var url="/scholarships/admin/makeChanges.cfm?count=" + count + "&deleteOptionalInfo=" + r.id;
		//alert (url);
		xmlHttp.open("GET",url,false);
		xmlHttp.onreadystatechange = function(){};
		xmlHttp.send(null);
		deleteTableRow("optionalInfoTable", r);
	}
	else alert ("The category has not been deleted.");
}
function deleteCustomInfo(r){
	var confirmation=confirm("Are you sure you would like to completely delete this category?");
	if (confirmation==true)
	{
		xmlHttp=createResponseObject();
		count=Math.floor(Math.random()*999999999999999999999);
		var url="/scholarships/admin/makeChanges.cfm?count=" + count + "&deleteCustomInfo=" + r.id;
		//alert (url);
		xmlHttp.open("GET",url,false);
		xmlHttp.onreadystatechange = function(){};
		xmlHttp.send(null);
		deleteTableRow("customInfoTable", r);
	}
	else alert ("The category has not been deleted.");
}
function deleteUserRow(r){
	var confirmation=confirm("Are you sure you would like to completely delete this user?");
	if (confirmation==true)
	{
		xmlHttp=createResponseObject();
		count=Math.floor(Math.random()*999999999999999999999);
		var url="/scholarships/admin/makeChanges.cfm?count=" + count + "&deleteUser=" + r.id;
		//alert (url);
		xmlHttp.open("GET",url,false);
		xmlHttp.onreadystatechange = function(){};
		xmlHttp.send(null);
		deleteTableRow("usertable", r);
	}
	else alert ("The user has not been deleted.");
}
function deleteUserScholarship(schol_id, user_id){
	//alert (schol_id);
	var confirmation=confirm("Are you sure you would like to disassociate this scholarship from the user?");
	if (confirmation==true)
	{
		xmlHttp=createResponseObject();
		count=Math.floor(Math.random()*999999999999999999999);
		var url="/scholarships/admin/makeChanges.cfm?count=" + count + "&deleteUserSchol=" + schol_id + "&scholUserId=" + user_id;
		//alert (url);
		xmlHttp.open("GET",url,false);
		xmlHttp.onreadystatechange = function(){};
		xmlHttp.send(null);
		scholList = document.getElementById("userScholarshipList");
		scholList.removeChild(document.getElementById(schol_id));
	}
	else alert ("The category has not been deleted.");
}
function deleteListItem(listName, ScholID){
	myOptionList.removeChild(document.getElementById(ScholID));

}
function addScholarshipOptionalInfo(curlinkid, scholid){
	//document.getElementById(curlinkid).style.color="black";
	//document.getElementById(curlinkid).style.textDecoration="none";
	//document.getElementById(curlinkid).onclick=function(){return false;};
	xmlHttp=createResponseObject();
	count=Math.floor(Math.random()*999999999999999999999);
	var url="/scholarships/admin/makeChanges.cfm?count=" + count + "&addScholarshipOptionalInfo=" + curlinkid + "&scholid=" + scholid;
	//alert (url);
	xmlHttp.open("GET",url,false);
	xmlHttp.onreadystatechange = function(){};
	xmlHttp.send(null);
	var browser=navigator.appName.toLowerCase();
     if (browser.indexOf("netscape")>-1) var display="table-row";
     else display="block";
	document.getElementById("info_"+curlinkid).style.display=display;
}
function addScholarshipCustomInfo(curlinkid, scholid){
	xmlHttp=createResponseObject();
	count=Math.floor(Math.random()*999999999999999999999);
	//alert (eval("document.updateStaffScholarshipForm.custom"+curlinkid+"_isrequired[0].checked"));
	//alert (eval("document.updateStaffScholarshipForm.custom"+curlinkid+"_isrequired[1].checked"));
	var url="/scholarships/admin/makeChanges.cfm?count=" + count + "&addScholarshipCustomInfo=" + curlinkid + "&scholid=" + scholid;
	//alert (url);
	xmlHttp.open("GET",url,false);
	xmlHttp.onreadystatechange = function(){};
	xmlHttp.send(null);
	var browser=navigator.appName.toLowerCase();
     if (browser.indexOf("netscape")>-1) var display="table-row";
     else display="block";
	document.getElementById("custominfo_"+curlinkid).style.display=display;
}
function deleteScholarshipOptionalInfo(r, scholid){
	xmlHttp=createResponseObject();
	count=Math.floor(Math.random()*999999999999999999999);
	var url="/scholarships/admin/makeChanges.cfm?count=" + count + "&deleteScholarshipOptionalInfo=" + r.id + "&scholid=" + scholid;
	//alert (url);
	xmlHttp.open("GET",url,false);
	xmlHttp.onreadystatechange = function(){};
	xmlHttp.send(null);
	var rowid=r.parentNode.parentNode.id;
	document.getElementById("text_"+r.id).value="";
	document.getElementById(rowid).style.display="none";
}
function deleteScholarshipCustomInfo(r, scholid){
	xmlHttp=createResponseObject();
	count=Math.floor(Math.random()*999999999999999999999);
	var url="/scholarships/admin/makeChanges.cfm?count=" + count + "&deleteScholarshipCustomInfo=" + r.id + "&scholid=" + scholid;
	//alert (url);
	xmlHttp.open("GET",url,false);
	xmlHttp.onreadystatechange = function(){};
	xmlHttp.send(null);
	var rowid=r.parentNode.parentNode.id;
	//alert(rowid);
	//document.getElementById("customtext_"+r.id).value="";
	eval("document.updateStaffScholarshipForm.custom"+r.id+"_isrequired[0].checked=false");
	eval("document.updateStaffScholarshipForm.custom"+r.id+"_isrequired[1].checked=true");
	document.getElementById(rowid).style.display="none";
}
function setCustomRequired(rid, scholid, newvalue){
	xmlHttp=createResponseObject();
	count=Math.floor(Math.random()*999999999999999999999);
	var url="/scholarships/admin/makeChanges.cfm?count=" + count + "&setCustomInfoRequired=" + rid + "&scholid=" + scholid + "&newvalue=" + newvalue;
	//alert (url);
	xmlHttp.open("GET",url,false);
	xmlHttp.onreadystatechange = function(){};
	xmlHttp.send(null);
}
function validateUpdateStaffScholarship(){
	if (trim(document.getElementById("briefdesc").innerHTML) == "None Yet"){
		alert("Please specify the brief description.");
		return false;
	}
	if (trim(document.getElementById("fulldesc").innerHTML) == "None Yet"){
		alert("Please specify the full description.");
		return false;
	}
	var theform=document.updateStaffScholarshipForm;
	var thefieldvalue="";
	var thefield="";
	for(i=0; i<theform.elements.length; i++)
	{
		thefield = theform.elements[i];
		if (thefield.type == "text" || thefield.type == "select-one" || thefield.type == "select-multiple" || thefield.type == "file" || thefield.type == "textbox"){
			if (thefield.type == "select-one" || thefield.type == "select-multiple"){
				if (thefield.selectedIndex == -1)
					thefieldvalue="";
				else
					thefieldvalue = thefield[thefield.selectedIndex].value;
			}
			else {thefieldvalue = thefield.value;}
			//alert(thefieldvalue);
			var styledisplay = thefield.parentNode.parentNode.style.display;
			if (thefieldvalue == "" && styledisplay != "none"){
				alert("Please fill out all the fields before submitting.");
				return false;
			}
		}
	}
	//if (document.getElementById("text_12") != undefined)
	//{
		if (isNaN(document.getElementById("text_12").value)){
			document.getElementById("text_12").value="";
			alert ("Please enter a number for the GPA");
			return false;
		}
		else if (document.getElementById("text_12").value!="") document.getElementById("text_12").value = parseFloat(document.getElementById("text_12").value).toFixed(2);
	//}
	//if (document.getElementById("text_7") != undefined)
	//{
		if (isNaN(document.getElementById("text_7").value)){
			document.getElementById("text_7").value="";
			alert ("Please enter a number for the GPA");
			return false;
		}
		else if (document.getElementById("text_7").value!="") document.getElementById("text_7").value = parseFloat(document.getElementById("text_7").value).toFixed(2);
	//}
	return true;
}
function deleteUserScholarship(delid, delvalue){
	updateUserScholarshipList("remove", delid, delvalue);
}
function changeUserScholarshipList(checkboxid){
	var curcheckbox=document.getElementById(checkboxid);
	if (curcheckbox.checked==true) type="add";
	else type="remove";
	updateUserScholarshipList(type, curcheckbox.id, curcheckbox.value);
}
function validateAwardingStudents(){
	var awardingstudents=false;
        var elem = document.getElementById('awardApplicantsForm').elements;
        for(var i = 0; i < elem.length; i++)
        {
            if (elem[i].type=="radio" && elem[i].value=="award" && elem[i].checked==true) awardingstudents=true;
        } 
        if (awardingstudents==true){
		var confirmation=confirm('Have you received the Intent to Award Approval for every student you chose to award? Please choose \'OK\' for Yes or \'Cancel\' for No.');
		if (confirmation==false){
			alert('Awards not submitted');
			return false;
		}
		else return true;
	}
}
function updateUserScholarshipList(type, addid, addvalue){
	if (type=="add") { //checked, add to session and to list
		var selscholtable=document.getElementById("userScholTable");
		var lastRow=selscholtable.rows.length;
		var inputs = document.getElementsByTagName('div');
		for(var i=0; i<inputs.length; i++){
			if(inputs[i].getAttribute('name')=='userScholDiv'){
				var selscholdiv=inputs[i];
				var h_size1 = selscholdiv.offsetHeight;
				var w_size1 = selscholdiv.offsetWidth;
				if (lastRow>=5) selscholdiv.style.height=(h_size1 + 50+"px") //12 rows, 22px for IE
			}
		}
		var row=selscholtable.insertRow(lastRow);
		var cell=row.insertCell(0);
		var delimage=new Image();
		delimage.src="images/delete.gif";
		delimage.id="delete_"+addid;
		delimage.onclick=function(){deleteUserScholarship(addid, 'addvalue');};
		var textNode=document.createTextNode(" "+addvalue);
		cell.appendChild(delimage);
		cell.appendChild(textNode);
		addvalue=addvalue.replace("&", "+");
		var sendurl="addUserScholToSession="+addid+"->"+addvalue;
	}
	else {//unchecked, remove from session and from selected scholarships list
		var delid="delete_"+addid;
		//alert(delid);
		if (document.getElementById(addid) != undefined) document.getElementById(addid).checked=false;
		var delicon=document.getElementById(delid);
		//alert(delicon.id);
		deleteTableRow("userScholTable", delicon);
		addvalue=addvalue.replace("&", "+");
		var sendurl="removeUserScholFromSession="+addid+"&scholvalue="+addvalue;
	}
	count=Math.floor(Math.random()*999999999999999999999);
	var url="makeChanges.cfm?count="+count+"&"+sendurl;
	//alert(url);
	xmlHttp=createResponseObject();
	xmlHttp.open("GET",url,false);
	xmlHttp.onreadystatechange = function(){};
	xmlHttp.send(null);
}
function deleteTableRow(tableID, r){
	var i=r.parentNode.parentNode.rowIndex;
	//alert(tableID+" "+i);
	document.getElementById(tableID).deleteRow(i);
}
function deleteFileLink(appid, infoid){
	xmlHttp=createResponseObject();
	count=Math.floor(Math.random()*999999999999999999999);
	var url="/scholarships/admin/makeChanges.cfm?count=" + count + "&deleteFileLink=true&appid=" + appid + "&infoid=" + infoid;
	//alert (url);
	xmlHttp.open("GET",url,false);
	xmlHttp.onreadystatechange = function(){};
	xmlHttp.send(null);
	document.getElementById("fileLink_"+infoid).style.display="none";
	var browser=navigator.appName.toLowerCase();
     if (browser.indexOf("netscape")>-1) var display="table-row";
     else display="block";
	document.getElementById("uploadFileField_"+infoid).style.display=display;
}
function deleteDocumentLink(docid){
	xmlHttp=createResponseObject();
	count=Math.floor(Math.random()*999999999999999999999);
	var url="/scholarships/admin/makeChanges.cfm?count=" + count + "&deleteDocLink=true&docid=" + docid;
	//alert (url);
	xmlHttp.open("GET",url,false);
	xmlHttp.onreadystatechange = function(){};
	xmlHttp.send(null);
	document.getElementById("docLink_"+docid).style.display="none";
	var browser=navigator.appName.toLowerCase();
     if (browser.indexOf("netscape")>-1) var display="table-row";
     else display="block";
}



function createResponseObject()
{
	var tempobject=GetXmlHttpObject()
	if (tempobject==null)
	{
		alert ("Browser does not support HTTP Request")
		return false;
	}
	return tempobject;
}

function stateChanged() 
{
	//alert ("state: "+xmlHttp.readyState);
	if (xmlHttp.readyState==4 || xmlHttp.readyState=="complete")
	{ 
		//alert("changing value");
		//changeDepartmentDropdown(xmlHttp.responseText);
		if (xmlHttp.status == 200) 
		{
			var xmldoc = xmlHttp.responseText;
			//alert("response completed and succeeded :)");
		}
		else
		{
			var xmldoc = xmlHttp.responseText;
			//alert("response ccmplete but not succeeded: "+xmldoc);
		}
		xmlHttp.onreadystatechange=stateChanged;
	}
	//else alert ("response not ready: "+xmlHttp.readyState);//+", status is "+xmlHttp.status);
}

function GetXmlHttpObject()
{ 
var objXMLHttp=null;
if (window.ActiveXObject)
{
//alert("ms");
objXMLHttp=new ActiveXObject("Microsoft.XMLHTTP");
}
else if (window.XMLHttpRequest)
{
//alert("other");
objXMLHttp=new XMLHttpRequest()
}
return objXMLHttp
}
function deleteTableRow(tableID, r){
	var i=r.parentNode.parentNode.rowIndex;
	//alert(tableID+" "+i);
	document.getElementById(tableID).deleteRow(i);
}
function trim (str) {
	var	str = str.replace(/^\s\s*/, ''),
		ws = /\s/,
		i = str.length;
	while (ws.test(str.charAt(--i)));
	return str.slice(0, i + 1);
}
