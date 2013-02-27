  
  
function filterScholarships(filename, page){
	if (!page || page == "") page=document.getElementById("pageNumber").value;
	//alert(page+" a");
	count=Math.floor(Math.random()*999999999999999999999);
	var params=getScholParams();
	var url="/scholarships/admin/makeChanges.cfm";
	url=url+"?count="+count;
	url=url+"&filterScholarships=true" + params;
	url=url+"&filename="+filename;
	if (document.getElementById("showApplicableScholarships") != undefined && document.getElementById("showApplicableScholarships").checked==true) url=url+"&showApplicableScholarships=true";
	var pagefilename=window.location.pathname.substring(window.location.pathname.lastIndexOf('/')+1);
	if (pagefilename=="external-scholarships.cfm" || pagefilename == "external_scholarshipsTemp.cfm"){
		url=url+"&scholarshipType=external";	
	}
	else if (pagefilename=="all-scholarships.cfm" || pagefilename=="search_scholarships.cfm"){
		url=url+"&scholarshipType=all";
	}
	if (page) url=url+"&page="+page;
	//alert (url);
	var xmlHttp=createResponseObject();
	xmlHttp.open("GET",url,false);
	xmlHttp.send(null);
	var info1; var info2; var info3;
	if (info==""){
		info1="";info2="";info3="";
	}
	else{
		var info=trim(xmlHttp.responseText);
		var infoArray = info.split("^");
		if (infoArray.length>3) alert("more tildas");
		if (infoArray.length==3){
			info1=infoArray[0];info2=infoArray[1];info3=infoArray[2];
		}
		else if (infoArray.length==2){
			info1=infoArray[0];info2="";info3=infoArray[2];
		}
		else info3="";
	}
	//alert(info);
	//deleteRows();
	addRows(info1,info2, info3);  
}   
function getScholParams(){
	var params="";
	var thisform=document.filterform;
	//first look for specified student type
	if (thisform.showstudents.value!=""){
		for (i=thisform.studenttype.length-1; i > -1; i--) {
			if (thisform.studenttype[i].checked) {
				params="&studenttype="+thisform.studenttype[i].value;
			}
		}
	}    
	else if (thisform.showstudents.value=="") {params+="&studenttype="+document.getElementById("defaultstudenttype").value;}
	//next get category(ies)
	var url = window.location.href;
	var filename=url.substring(url.lastIndexOf('/')+1);
	if (filename == "internal-scholarships.cfm"){
		cattype="internal";
		var catlist=thisform.availableInternalCategories.value;
		var internalcatlist=catlist;
	}
	else if (filename == "external-scholarships.cfm" || filename == "all-scholarships.cfm" || filename=="search_scholarships.cfm"){
		cattype="external";
		var catlist=document.getElementById("availableExternalCategories").value;
		var externalcatlist=catlist;
	}
	//alert(document.getElementById("availableExternalCategories").value+"*");
	if (thisform.showcats.value!=""){
		var selected_cats="";
		var selected_internal_cats="";
		var selected_external_cats="";
		//var catlist=thisform.availableCategories.value;
		//alert(catlist);
		if (catlist) var valueArray = catlist.split(",");
		//alert(catlist);
		if (filename == "all-scholarships.cfm" || filename=="search_scholarships.cfm") var loopcount=2;
		else var loopcount=1;
		for(i2=0;i2<loopcount;i2++){
			if (filename == "all-scholarships.cfm" || filename == "search_scholarships.cfm"){//alert(i2);
					if (i2 == 0) {cattype="internal";catlist=thisform.availableInternalCategories.value;}
					else if (i2 == 1) {cattype="external";catlist=document.getElementById("availableExternalCategories").value;}
					var valueArray = catlist.split(",");
			}
			for(var i=0; i<valueArray.length; i++){
			//for (x=14; x<16; x++){
				//alert(valueArray[i]);
				
				if (document.getElementById(cattype+"cat"+valueArray[i]) && document.getElementById(cattype+"cat"+valueArray[i]).checked==true){
					if (filename == "all-scholarships.cfm" || filename=="search_scholarships.cfm"){
						if (cattype=="internal"){
							if (selected_internal_cats!="")selected_internal_cats+=",";
							selected_internal_cats+=valueArray[i];
						}
						else if (cattype=="external"){
							if (selected_external_cats!="")selected_external_cats+=",";
							selected_external_cats+=valueArray[i];
						}
					}
					else{
						if (selected_cats!="")selected_cats+=",";
						selected_cats+=valueArray[i];
					}
				}         
			}
		}
		if (selected_cats!="") params+="&"+cattype+"college="+selected_cats;
		if (selected_internal_cats!="") params+="&internalcat="+selected_internal_cats;
		if (selected_external_cats!="") params+="&externalcat="+selected_external_cats;
	}
	else if (thisform.showcats.value=="") {params+="&college="+document.getElementById("defaultcollege").value;}
	//next get majors
	if (document.filterform.majors.value!="") params+="&major="+document.filterform.majors.value;
	if (document.filterform.keywords.value!="") params+="&keywords="+document.filterform.keywords.value;
	//alert(params+" -> now");
	return params;
}

   
    

   


function addRows(filename,info,pagenuminfo){
	//alert(info);
	 var table = document.getElementById("scholarshipTable");
	 var rowCount = table.rows.length;  
	 var color;
	 if (rowCount%2 == 0)
		 color="1";
	 else 
		 color="2";
	//DELETE ALL ROWS
		 deleteRows();   
	 if (info && info!=""){
		 var infoArray = info.split("|");
		 var x; 
		       
		 //for (x = rowCount; x<(rowCount+6); x++){
		 //<tr class='usermatrixrow#color#'><td valign='top' class='word-wrap' width='100px'><a href='#listlast(cgi.SCRIPT_NAME,'/')#?view_scholarship=#scholarship_id#'>#title#</a><br><br></td><td valign='top' class='word-wrap'><p></p></td></tr>">
		 var rowfinalnum=0;
		 var is_chrome = navigator.userAgent.toLowerCase().indexOf('chrome') > -1;
		 var count=1;
		 var months = new Array(
					'January','February','March','April','May',
					'June','July','August','September','October',
					'November','December');
		 var days = new Array(
					'Sunday','Monday','Tuesday',
					'Wednesday','Thursday','Friday','Saturday');

		 for (x=0;x<=(infoArray.length-1);x++){
			  var row = table.insertRow(x+1); 
			  var rowclass="usermatrixrow"+color;
			  row.setAttribute('class', rowclass);  
			  /*var cell1 = row.insertCell(0);
			  var element1 = document.createElement("img"); 
			  element1.setAttribute('src', 'images/delete.gif');     
			  element1.setAttribute('alt', 'Delete Scholarship');
			  element1.setAttribute('align', 'top');
			  element1.setAttribute('onclick', 'deleteScholarshipRow(this);');
			  element1.setAttribute('id', '1236');
			  cell1.appendChild(element1);  
			  var space1 = document.createElement("span");
			  space1.innerHTML = "&nbsp";
			  cell1.appendChild(space1);
			  var newa=document.createElement("a");
			  newa.setAttribute('href', 'index.cfm?edit_scholarship=1236');
			  var element2 = document.createElement("img"); 
			  element2.setAttribute('src', 'images/edit.gif'); 
			  element2.setAttribute('alt', 'Edit Scholarship');
			  element2.setAttribute('align', 'top');
			  element2.setAttribute('border', '0');
			  newa.appendChild(element2);           
			  cell1.appendChild(newa);  
			  //cell1.innerHTML="Delete Edit"; */
			  //alert(infoArray[x]);
			  var nameArray = infoArray[x].split("*");
			  var cell2 = row.insertCell(0);
			  cell2.setAttribute("valign","top");
			  cell2.setAttribute('class','word-wrap');
			  //if (is_chrome) cell2.setAttribute('width','200px');  
			  cell2.setAttribute('width','35%');  
			  var newa=document.createElement("a"); 
			  if (document.location.href.indexOf("?") == -1)
			  	newa.setAttribute('href', document.location.href +'?view_scholarship='+nameArray[1]);  
			  else 
			  	newa.setAttribute('href', document.location.href +'&view_scholarship='+nameArray[1]);  
			  var element2 = document.createElement("span"); 
			  element2.innerHTML = nameArray[0];
			  newa.appendChild(element2);           
			  cell2.appendChild(newa);
			  var linebreak1=document.createElement("br");
			  cell2.appendChild(linebreak1);
			  var image1=document.createElement("img");
			  image1.src="admin/images/scholarship_details.gif";
			  var image1link=document.createElement("a");
			  image1link.setAttribute('href', document.location.href +'?view_scholarship='+nameArray[1]);
			  image1link.appendChild(image1);
			  cell2.style.textAlign = "left";
			  cell2.style.verticalAlign = "top";
			  cell2.appendChild(image1link);
			  if (nameArray[2]=='y'){
				if (nameArray[3]!=''){
					var deadlinearray=nameArray[3].split("@");
					var deadlinedate=new Date(deadlinearray[0], (deadlinearray[1]-1), deadlinearray[2], 23, 59, 59);
				}
				else var deadlinedate=null;
				if (nameArray[4]!=''){
					var applicabledatearray=nameArray[4].split("@");
					var applicabledate=new Date(applicabledatearray[0], (applicabledatearray[1]-1), applicabledatearray[2], 1, 1, 1);
				}
				else applicabledate=null;
				var today=new Date();
				
				/*if (count==3){
					alert(deadlinedate);
					alert(applicabledate);
					if (today<=deadlinedate) alert("less than deadline");
					if (today>=applicabledate) alert("greater than app date");
				}*/
				if (today<=deadlinedate && (nameArray[4]=='' || today>=applicabledate)){//alert("found");
					var linebreak2=document.createElement("br");
					cell2.appendChild(linebreak2);
					var image2=document.createElement("img");
					image2.src="admin/images/apply_online_now.gif";
					var image1link2=document.createElement("a");
					image1link2.setAttribute('href', document.location.href +'?view_scholarship='+nameArray[1]);
					image1link2.appendChild(image2);
					cell2.appendChild(image1link2);
				}
				else if (today>deadlinedate){
					var linebreak2=document.createElement("br");
					cell2.appendChild(linebreak2);
					var image2=document.createElement("img");
					image2.src="admin/images/past_deadline.gif";
					/*var image1link2=document.createElement("a");
					image1link2.setAttribute('href', document.location.href +'?view_scholarship='+nameArray[1]);
					image1link2.appendChild(image2);*/
					cell2.appendChild(image2);
				}
				/*else{//for testing
					var info0=document.createElement("span");
					info0.innerHTML="asdfadfaf";
					cell2.appendChild(info0);
				}*/
				
			  }
			  /*var deadline=document.createElement("span");
			  deadline.innerHTML=nameArray[3];
			  cell2.appendChild(deadline);*/
			  //cell2.innerHTML = nameArray[0];             
			  var cell3 = row.insertCell(1);  
			  cell3.setAttribute('valign','top');
			  cell3.setAttribute('class','word-wrap');
			  cell3.style.verticalAlign = 'top';
			  //if (is_chrome) cell3.setAttribute('width','400px');  
			  cell3.setAttribute('width','65%');  
			  cell3.innerHTML = nameArray[5];
			  if (applicabledate!=null){
				
				if (nameArray[2]=='y') cell3.innerHTML=cell3.innerHTML+"<br><b>Online applications are accepted starting: "+days[applicabledate.getDay()]+" "+months[applicabledate.getMonth()]+" "+applicabledate.getDate()+", "+applicabledate.getFullYear()+"</b>";
			  }
			  if (color==2) color=1;
			  else color=2;
			  rowfinalnum=x;
			  count=count+1;
		}
		if (pagenuminfo != "none"){
			  var row3 = table.insertRow(rowfinalnum+2);
			  var cell1 = row3.insertCell(0);  
			  cell1.setAttribute('valign','top');
			  cell1.setAttribute('class','word-wrap');    
			  cell1.setAttribute('colSpan','2');
			  //cell1.setAttribute('width','300px');  
			  cell1.innerHTML = pagenuminfo;
		}
	}  
	else   {
		var row = table.insertRow(1); 
		  var rowclass="usermatrixrow"+color;
		  row.setAttribute('class', rowclass);  
		  var cell3 = row.insertCell(0);  
		  cell3.setAttribute('valign','top');
		  cell3.setAttribute('class','word-wrap');   
		  cell3.setAttribute('colspan','2'); 
		  //cell3.setAttribute('width','200px');
		  cell3.innerHTML = "There are currently no results.  Please broaden your search to receive more results.";
	}                 
}
function deleteRows(){
	//1 row for header.  the Edit/Delete is a caption.
	 var table = document.getElementById("scholarshipTable");             
	 var rowCount = table.rows.length; 
	  for(var i=(rowCount-1); i>0; i--) {                                
		table.deleteRow(i);                             
	   }     
}


function trim (str) {
	var	str = str.replace(/^\s\s*/, ''),
		ws = /\s/,
		i = str.length;
	while (ws.test(str.charAt(--i)));
	return str.slice(0, i + 1);
}
function changeFilter(type, value, catid, filename, filterType, externalSectionID, page){//alert(1);
	if (type=="cat" || type=="keyword" || trim(type)=="student") page=1;
	if (page) document.getElementById("pageNumber").value=page;
	var thisform=document.getElementById("filterform");
	if (document.getElementById("AtoZList")) document.getElementById("AtoZList").innerHTML="";

	if (type=="catANDkeyword"){
		catvalue = getFilteredCats(filename);
		keywordvalue = getFilteredKeywords("", filename);
		document.getElementById("cat_filter").innerHTML=catvalue;
		document.getElementById("keyword_filter").innerHTML=keywordvalue;
	}
	else{
		if (type=="cat"){
			value = getFilteredCats(filename, externalSectionID);
		}          
		//else if (type=="student") value+=" <img src='admin/images/delete.gif' align='absmiddle' id='"+catid+"' onclick='document.getElementById(\"type\"+this.id).checked=false;document.getElementById(\"student_filter\").innerHTML=\"<i>none selected</i>\";alert(1);document.getElementById(\"student_filter\").innerHTML=\"<i>none selected</i>\"; alert(2); filterScholarships();'>";
		else if (type=="student" && value != "") value+=" <img src='admin/images/delete.gif' align='absmiddle' id='"+catid+"' onclick='document.getElementById(\"type\"+this.id).checked=false;document.getElementById(\"studentFilter\").style.display=\"none\";document.getElementById(\"student_filter\").innerHTML=\"<i>none selected</i>\"; /*document.getElementById(\"messageArea\").innerHTML=\"<p></p>\";*/ filterScholarships(\""+filename+"\");'>";
		else if (type=="deletemajor"){
			getFilteredMajors(value, filename);  
			//alert(document.filterform.majors.value);
		}
		else if (type=="deletekeyword"){           
			getFilteredKeywords(value, filename);
		}
		if (type=="deletemajor") type="major";
		if (type=="deletekeyword") type="keyword";
		if (type=="major"){
			value = getFilteredMajors("", filename);
		}    
		else if (type=="keyword"){
			value = getFilteredKeywords("", filename);
		}
		if (value=="") value="<i>none selected</i>";
		if (type!="") document.getElementById(type+"_filter").innerHTML=value;
	}
	//if (type=="cat" || type=="student" || type=="keyword" || type=="major"){
	if (type=="student"){
		//if (type=="cat") type1="category";
		//else type1=type;
		if (value=="")document.getElementById(type+"Filter").style.display="none";
		else {
			document.getElementById(type+"Filter").style.display="block";
			document.getElementById("applyonlineonly").style.display="block";
		}
	}
	var browser=navigator.appName.toLowerCase(); 
	if (browser.indexOf("netscape")>-1) var display="table-row"; 
	else display="block"; 
	if (document.getElementById("scholarshipTable")) document.getElementById("scholarshipTable").style.display = document.getElementById("scholarshipTable").style.display? display:display;
	//alert(filterType);
	//alert(type);
	//if (type=="catAndkeyword" || type=="major" || type=="cat" || type=="keyword" || type=="student"){

		var externalchecked=false;
		var internalchecked=false;
		for (var i = 0; i < thisform.elements.length; i++ ) {
			if (thisform.elements[i].type == 'checkbox' && thisform.elements[i].id.substring(0,11)=='externalcat' && thisform.elements[i].checked==true) 
				externalchecked=true;
		}
		for (var i = 0; i < thisform.elements.length; i++ ) {
			if (thisform.elements[i].type == 'checkbox' && thisform.elements[i].id.substring(0,11)=='internalcat' && thisform.elements[i].checked==true) 
				internalchecked=true;
			if (thisform.elements[i].type == 'radio' && thisform.elements[i].name=='studenttype' && thisform.elements[i].checked==true)
				internalchecked=true;
		}
		if (externalchecked==true && internalchecked==true ){
			displayScholarshipMessage();
		}
		else document.getElementById("messageArea").style.display="none";// PUT THIS BACK AFTER TESTING!!!!!!!! 07/17/2012
		//alert(2);
	//}
	if (filterType == "external" && type != "catANDkeyword"){
		for (x=1;x<=4;x++)
		{
			var selectcount=0;
			var groupcats=eval("thisform.external_group_cats_"+x+".value");
			//alert(groupcats);
			var valueArray = groupcats.split(",");
			for(var i=0; i<valueArray.length; i++){
				//alert(valueArray[i]);
				//if (document.getElementById("cat625") &&  document.getElementById("cat625").checked==true) alert("checked");
			  if (document.getElementById("externalcat"+valueArray[i]) && document.getElementById("externalcat"+valueArray[i]).checked==true){//alert("checked");
					selectcount=selectcount+1;  
			  }
			}
			document.getElementById("external_cat_"+x).innerHTML=selectcount;	
		}
		/*var curnumselected=parseInt(document.getElementById("external_cat_"+externalSectionID).innerHTML);
		if (document.getElementById("cat"+catid).checked==true){
			document.getElementById("external_cat_"+externalSectionID).innerHTML=(curnumselected + 1);	
		}
		else{	
			document.getElementById("external_cat_"+externalSectionID).innerHTML=(curnumselected - 1);
		}*/
	}
	if (!page || page=="") page=document.getElementById("pageNumber").value;
	//alert(document.getElementById("pageNumber").value);
	filterScholarships(filename, page);
}
function displayScholarshipMessage(){
	var count=Math.floor(Math.random()*999999999999999999999);
	var pageurl = window.location.href;
	var filename=pageurl.substring(pageurl.lastIndexOf('/')+1);
	var scholmessage="";
	scholmessage="<b>Note:</b> You have chosen internal and external search criteria. In this case, you are receiving GSU (";
	var params=getScholParams();
	var url="/scholarships/admin/makeChanges.cfm";
	url=url+"?count="+count;
	url=url+"&filterScholarships=true&getCount=internal&scholarshipType=all" + params;
	url=url+"&filename="+filename;
	var xmlHttp=createResponseObject();
	xmlHttp.open("GET",url,false);
	xmlHttp.send(null);
	var internalcount=trim(xmlHttp.responseText);
	scholmessage=scholmessage+internalcount.toString();
	scholmessage=scholmessage+") and external scholarships (";
	var url="/scholarships/admin/makeChanges.cfm";
	url=url+"?count="+count;
	url=url+"&filterScholarships=true&getCount=external&scholarshipType=all" + params;
	url=url+"&filename="+filename;
	var xmlHttp=createResponseObject();
	xmlHttp.open("GET",url,false);
	xmlHttp.send(null);
	var externalcount=trim(xmlHttp.responseText);
	scholmessage=scholmessage+externalcount.toString();
	scholmessage=scholmessage+") together.";
	document.getElementById("messageArea").innerHTML=scholmessage;
	document.getElementById("messageArea").style.display="";
}
/*function getFilteredKeywords(deletevalue){
	//alert(document.filterform.keywords.value);
	var keywords = document.filterform.keywords.value.split(",");
	var keywordlist="";
	var keywordHTML="";
	if (document.filterform.keywords.value=='') keywords.length=0;
	for(var i=0; i<keywords.length; i++){
			if (keywords[i]!=deletevalue){
				if (keywordlist!="") keywordlist+=",";
				keywordlist += keywords[i];
				if (keywordHTML!="") keywordHTML+=" &nbsp; ";
				keywordHTML += keywords[i] + " <img src='admin/images/delete.gif' align='absmiddle' onclick='changeFilter(\"deletekeyword\", \""+keywords[i]+"\", \"\");'>";
			}
		}
	 document.filterform.keywords.value=trim(keywordlist);
	 return keywordHTML;
}*/
function getFilteredKeywords(deletevalue, filename){
	
	var keywords = document.filterform.keywords.value.split(",");
	var keywordlist="";
	var keywordHTML="";
	if (document.filterform.keywords.value=='') keywords.length=0;
	for(var i=0; i<keywords.length; i++){
		if (keywords[i]!=deletevalue){
			if (keywordlist!="") keywordlist+=",";
			keywordlist += keywords[i];
			if (keywordHTML!="") keywordHTML+=" &nbsp; ";
			keywordHTML += keywords[i] + " <img src='admin/images/delete.gif' align='absmiddle' onclick='changeFilter(\"deletekeyword\", \""+keywords[i]+"\", \"\", \""+filename+"\");'>";
		}
		
	}
	document.filterform.keywords.value=trim(keywordlist);
	if (trim(keywordHTML)==""){
		keywordHTML="<i>none selected</i>";
		document.getElementById("keywordFilter").style.display="none";
	}
	else{
		document.getElementById("keywordFilter").style.display="block";
	}
	return keywordHTML;
}
function getFilteredMajors(deletevalue, filename){
	var majors = document.filterform.majors.value.split(",");
	var majorlist="";
	var majorHTML="";
	if (document.filterform.majors.value=='') majors.length=0;
	for(var i=0; i<majors.length; i++){
		if (majors[i]!=deletevalue){
			if (majorlist!="") majorlist+=",";
			majorlist += majors[i];
			if (majorHTML!="") majorHTML+=" &nbsp; ";
			majorHTML += majors[i] + " <img src='admin/images/delete.gif' align='absmiddle' onclick='changeFilter(\"deletemajor\", \""+majors[i]+"\", \"\", \""+filename+"\");'>";
		}
		
	}
	document.filterform.majors.value=trim(majorlist);	
	if (trim(majorHTML)==""){
			majorHTML="<i>none selected</i>";
			document.getElementById("majorFilter").style.display="none";
	}
	else{
		document.getElementById("majorFilter").style.display="block";
		document.getElementById("applyonlineonly").style.display="block";
	}
	return majorHTML;
}
function getFilteredCats(filename, externalSectionID){//alert("hi");
	var url = window.location.href;
	var filename=url.substring(url.lastIndexOf('/')+1);
	var thisform=document.getElementById("filterform");
	var value='';
	for (var i = 0; i < thisform.elements.length; i++ ) {
		if (thisform.elements[i].type == 'checkbox'){// && thisform.elements[i].name=='category') {
			if (thisform.elements[i].checked == true) {
				var idnum=thisform.elements[i].id.substring(11);
				if (thisform.elements[i].id=="externalcat"+idnum) cattype="external";
				else if (thisform.elements[i].id=="internalcat"+idnum) cattype="internal";
				if (value != '') value += ' &nbsp; ';
				value += document.getElementById(cattype+"catname"+idnum).innerHTML + " <img src='admin/images/delete.gif' align='absmiddle' id='"+idnum+"' onclick='document.getElementById(\""+cattype+"cat"+idnum+"\").checked=false;changeFilter(\"cat\",\"\",\""+idnum+"\",\""+filename+"\"";
				if (filename=="external-scholarships.cfm") value+=", \"external\", \""+externalSectionID+"\"";
				value += ");'> &nbsp; "; //thisform.elements[i].value
				//alert(value); 
			}
		}
	}	
	if (trim(value)==""){
		value="<i>none selected</i>";
		document.getElementById("categoryFilter").style.display="none";
	}
	else{
		document.getElementById("categoryFilter").style.display="block";
		document.getElementById("applyonlineonly").style.display="block";
	}
	return value;
}
function getFilteredStudents(filename){
	var thisform=document.getElementById("filterform");
	var value="";
	for (i=thisform.studenttype.length-1; i > -1; i--) {
		if (thisform.studenttype[i].checked) {
			var idnum=thisform.studenttype[i].value;
			value=document.getElementById("studentname"+idnum).innerHTML + " <img src='admin/images/delete.gif' align='absmiddle' id='"+idnum+"' onclick='document.getElementById(\"type\"+this.id).checked=false;document.getElementById(\"student_filter\").innerHTML=\"<i>none selected</i>\";filterScholarships(\""+filename+"\");'>";
		}
	}
	if (trim(value)==""){
		value="<i>none selected</i>";
		document.getElementById("studentFilter").style.display="none";
	}
	else{
		document.getElementById("studentFilter").style.display="block";
		document.getElementById("applyonlineonly").style.display="block";
	}
	return value;
}

function resetFilter(){        
	//alert("hi");
	//changeFilter("","","");
	//change filters and then filterScholarships()
	var internal_cat_checked=false;
	if (document.getElementById("keyword_filter")){
		var keywordFilter=document.getElementById("keyword_filter");
		keywordFilter.innerHTML=getFilteredKeywords();
		if (keywordFilter.innerHTML!="") internal_cat_checked=true;
	}
	if (document.getElementById("major_filter")){
		var majorFilter=document.getElementById("major_filter");
		majorFilter.innerHTML=getFilteredMajors();
		if (majorFilter.innerHTML!="") internal_cat_checked=true;
	}
	if (document.getElementById("cat_filter")){
		var catFilter=document.getElementById("cat_filter");
		catFilter.innerHTML=getFilteredCats();
		if (catFilter.innerHTML!="") internal_cat_checked=true;
	}
	if (document.getElementById("student_filter")){
		var studentFilter=document.getElementById("student_filter");
		studentFilter.innerHTML=getFilteredStudents();
		if (studentFilter.innerHTML!="") internal_cat_checked=true;
	}
	//if (document.getElementById("major_filter").innerHTML=="<i>none selected</i>" && document.getElementById("cat_filter").innerHTML=="<i>none selected</i>" && document.getElementById("student_filter").innerHTML=="<i>none selected</i>"){
		//alert(document.getElementById("major_filter").innerHTML);
	/*if (!catFilter && !majorFilter && !studentFilter && !keywordFilter){
		
	}    
	else if (trim(majorFilter.innerHTML.toLowerCase())=="<i>none selected</i>" &&  trim(keywordFilter.innerHTML.toLowerCase())=="<i>none selected</i>" && (!studentFilter || trim(studentFilter.innerHTML.toLowerCase())=="<i>none selected</i>") && (!catFilter || trim(catFilter.innerHTML.toLowerCase())=="<i>none selected</i>")){
			
	}       
	else*/
	if (!document.getElementById("pageNumber")){
		//alert(43);
	}
	else if (document.getElementById("AtoZList")){//alert(3);
		if (getFilteredMajors()=="<i>none selected</i>" && getFilteredKeywords()=="<i>none selected</i>" && getFilteredStudents()=="<i>none selected</i>" && getFilteredCats() == "<i>none selected</i>") return;
		document.getElementById("AtoZList").innerHTML="";
		var browser=navigator.appName.toLowerCase(); 
		if (browser.indexOf("netscape")>-1) var display="table-row"; 
		else display="block"; 
		if (document.getElementById("scholarshipTable")) document.getElementById("scholarshipTable").style.display = document.getElementById("scholarshipTable").style.display? display:display; 
		filterScholarships();
	}      
	else {//alert(4);
		var filename=window.location.pathname.substring(window.location.pathname.lastIndexOf('/')+1);
		if (filename=="university-wide_scholarships.cfm" || filename=="freshmen_and_transfer_awards.cfm" || filename=="college_and_departmental_awards.cfm"  || filename=="external-scholarships.cfm" || filename=="external_scholarshipsTemp.cfm" || filename=="internal-scholarships.cfm" || filename=="all-scholarships.cfm" || filename=="search_scholarships.cfm")
		{
			filterScholarships(filename);  
		}
	}   
  
	//alert("HI");    
	/*if (!document.getElementById("filterform")) {      
		//alert("doesn't exist!");    
		return false;
	}
	var thisform=document.getElementById("filterform");

	
		for (var i = 0; i < thisform.elements.length; i++ ) {
			if (thisform.elements[i].type == 'checkbox' && thisform.elements[i].name=='college') {
				thisform.elements[i].checked = false;
			}
		}  
		for (var i = 0; i < thisform.elements.length; i++ ) {
			if (thisform.elements[i].type == 'radio' && thisform.elements[i].name=='studenttype') {
				thisform.elements[i].checked = false;
			}
		}
		document.filterform.major.value="";
		document.filterform.keyword.value="";*/
		
		var thisform=document.getElementById("filterform");
		if (document.getElementById("external_cat_1")){
			var external_cat_checked=false;
			for (x=1; x<=4; x++){
				var curlist=eval("thisform.external_group_cats_"+x+".value");
				//alert(curlist);
				var valueArray = curlist.split(",");
				var curnumselected=parseInt(document.getElementById("external_cat_"+x).innerHTML);
				for(var i=0; i<valueArray.length; i++){
					if (eval("thisform.externalcat"+valueArray[i]) && eval("thisform.externalcat"+valueArray[i]+".checked")==true){
						document.getElementById("external_cat_"+x).innerHTML=parseInt(document.getElementById("external_cat_"+x).innerHTML) + 1;
						external_cat_checked=true;
					}
				}
			}
		}
	if (external_cat_checked==true && internal_cat_checked==true) displayScholarshipMessage();
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
function trim (str) {
	var	str = str.replace(/^\s\s*/, ''),
		ws = /\s/,
		i = str.length;
	while (ws.test(str.charAt(--i)));
	return str.slice(0, i + 1);
}
