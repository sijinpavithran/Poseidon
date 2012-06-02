<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title><spring:message code="poseidon.userListPage" text="User List" /></title>
		<link rel="stylesheet" type="text/css" href="../css/mainStyles.css" />
		<script type="text/javascript">

			//code to add New user
			function addNew(){
				document.forms[0].action="AddUser.htm";
				document.forms[0].submit();
			}

			// delete user
			function deleteUser(){
			    var check ='false';
			    var count = 0;
                // get all check boxes
			    var checks = document.getElementsByName('checkField');
			    if(checks){
			        //if total number of rows is one
			        if(checks.checked){
			           deleteRow();
			        }else{
			           for(var i = 0 ; i < checks.length ; i++ ) {
			               if(checks[i].checked){
			                   check = 'true';
			                   count = count + 1;
			               }
			           }
                        //check for validity
                        if(check = 'true'){
                            if(count == 1){
                                deleteRow();
                            }else{
                                alert(" Only one row can be deleted at a time, please select one row ");
                            }
                        }else{
                            alert(" No rows selected, please select one row ");
                        }
			        }
			    }
			}

            //code to delete a user
			function deleteRow(){
			    var answer = confirm(" Are you sure you wanted to delete the user ");
			    if(answer){
			        //if yes then delete
			        var userRow;
                    var checks = document.getElementsByName('checkField');
                    if(checks.checked){
                        userRow = document.getElementById("myTable").rows[0];
                        document.getElementById("id").value = userRow.cells[0].childNodes[0].value;
                        document.forms[0].action="DeleteUser.htm";
				        document.forms[0].submit();
                    }else{
                        for(var i = 0; i < checks.length ; i++){
                            if(checks[i].checked) {
                                userRow = document.getElementById("myTable").rows[i+1];
                            }
                        }
                        document.getElementById("id").value = userRow.cells[0].childNodes[0].value;
                        document.forms[0].action="DeleteUser.htm";
                        document.forms[0].submit();
                    }
			    }

			}


			//preventing multiple checks
			function checkCall(e){
			    var min = e.value;
			    var checks = document.getElementsByName('checkField');
			    for(var i = 0; i < checks.length ; i++){
			        if(checks[i].value != min) {
			            checks[i].checked = false;
			        }
			    }
			}

            //validation before edit a user
			function editMe(){
				var check ='false';
			    var count = 0;
                // get all check boxes
			    var checks = document.getElementsByName('checkField');
			    if(checks){
			        //if total number of rows is one
			        if(checks.checked){
			           editRow();
			        }else{
			           for(var i = 0 ; i < checks.length ; i++ ) {
			               if(checks[i].checked){
			                   check = 'true';
			                   count = count + 1;
			               }
			           }
                        //check for validity
                        if(check = 'true'){
                            if(count == 1){
                                editRow();
                            }else{
                                alert(" Only one row can be edited at a time, please select one row ");
                            }
                        }else{
                            alert(" No rows selected, please select one row ");
                        }
			        }
			    }
			}

			//real edit
			function editRow(){
	            var userRow;
                var checks = document.getElementsByName('checkField');
                if(checks.checked){
                    userRow = document.getElementById("myTable").rows[0];
                    document.getElementById("id").value = userRow.cells[0].childNodes[0].value;
                    document.forms[0].action="EditUser.htm";
                    document.forms[0].submit();
                }else{
                    for(var i = 0; i < checks.length ; i++){
                        if(checks[i].checked) {
                            userRow = document.getElementById("myTable").rows[i+1];
                        }
                    }
                    document.getElementById("id").value = userRow.cells[0].childNodes[0].value;
                    document.forms[0].action="EditUser.htm";
                    document.forms[0].submit();
                }
            }

			function search() {
				document.forms[0].action="SearchUser.htm";
				document.forms[0].submit();
			}

			function clear(){
			}

		</script>
	</head>
	<body style="background: #A9A9A9 ;" >
        <form:form method="POST" commandName="userForm" name="userForm" action="listAll.htm" >
        <%@include file="/WEB-INF/jsp/myHeader.jsp" %>
        <input type="hidden" name="id" id="id" />
        <form:hidden name="loggedInUser" path="loggedInUser" />
	    <form:hidden name="loggedInRole" path="loggedInRole" />
        <div id="content">
            <div class="wrap">
                <fieldset style="text-align:right;">
					<legend><spring:message code="user.searchUse" text="Search User Details" /></legend>
					<table style="margin:auto;top:50%;left:50%;">
						<tr>
							<td>
								<label for="name" style="font-size: .70em;">
									<spring:message code="poseidon.name" text="Name" />
								</label>
							</td>
							<td>
								<form:input path="searchUser.name" cssClass="textboxes" id="name" />
                                <form:errors path="searchUser.name" />
							</td>
							<td colspan="2">&nbsp;</td>
							<td>
								<label for="createdBy" style="font-size: .70em;">
									<spring:message code="poseidon.loginId" text="loginId" />
								</label>
							</td>
							<td>
								<form:input path="searchUser.createdBy" cssClass="textboxes" id="createdBy" />
                                <form:errors path="searchUser.createdBy" />
							</td>
							<td colspan="2">&nbsp;</td>
							<td>
								<label for="role" style="font-size: .70em;">
									<spring:message code="poseidon.role" text="Role" />
								</label>
							</td>
							<td>
								<form:input path="searchUser.role" cssClass="textboxes" id="role" />
                                <form:errors path="searchUser.role" />
							</td>
						</tr>
						<tr>
							<td colspan="4">&nbsp;</td>
						</tr>
						<tr>
							<td colspan="8">&nbsp;</td>
							<td>
								<label for="includes" style="font-size: .70em;">
								    <spring:message code="user.includes" text="Includes" />
									<input type="checkbox" name="includes" value="includes" />
								</label>
							</td>
							<td>
								<label for="startswith" style="font-size: .70em;">
								    <spring:message code="user.startsWith" text="Starts with" />
									<input type="checkbox" name="startswith" value="startswith" />
								</label>
							</td>
						</tr>
						<tr>
							<td colspan="8">&nbsp;</td>
							<td>
								<input class="btn" value="<spring:message code="poseidon.search" text="Search" />" type="button" onclick="javascript:search()" />
							</td>
							<td>
								<input class="btn" value="<spring:message code="poseidon.clear" text="Clear" />" type="button" onclick="javascript:clear()" />
							</td>
						</tr>
					</table>
				</fieldset>
				<br/>
				<fieldset>
					<legend><spring:message code="user.UserDetail" text="User Details" /></legend>
					<table border="2" id="myTable" style="font-size: .60em;">
						<thead>
							<tr>
								<th><spring:message code="poseidon.id" text="id" /></th>
								<th><spring:message code="poseidon.name" text="Name" /></th>
								<th><spring:message code="poseidon.loginId" text="loginId" /></th>
								<th><spring:message code="poseidon.role" text="Role" /></th>
								<th><spring:message code="poseidon.createdOn" text="Created On" /></th>
								<th><spring:message code="poseidon.createdBy" text="Created By" /></th>
								<th><spring:message code="poseidon.modifiedOn" text="Modified On" /></th>
								<th><spring:message code="poseidon.modifiedBy" text="Modified By" /></th>
							</tr>
						</thead>

						<tbody>
							<c:forEach items="${userForm.userVOs}" var="iterationUser">
								<tr>
									<td><input type="checkbox" name="checkField" onclick="javascript:checkCall(this)" value="<c:out value="${iterationUser.id}" />" /></td>
									<td><c:out value="${iterationUser.name}" /></td>
									<td><c:out value="${iterationUser.loginId}" /></td>
									<td><c:out value="${iterationUser.role}" /></td>
									<td><c:out value="${iterationUser.createdDate}" /></td>
									<td><c:out value="${iterationUser.createdBy}" /></td>
									<td><c:out value="${iterationUser.modifiedDate}" /></td>
									<td><c:out value="${iterationUser.lastModifiedBy}" /></td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
					<table  style="margin:auto;top:50%;left:50%;">
						<tr>
							<td>
								<br/>
								<br/>
								<input class="btn" value="<spring:message code="poseidon.add" text="Add New User" />" type="button" onclick="javascript:addNew()" />
								<input class="btn" value="<spring:message code="poseidon.edit" text="Edit User" />" type="button" onclick="javascript:editMe()" />
								<input class="btn" value="<spring:message code="poseidon.delete" text="Delete User" />" type="button" onclick="javascript:deleteUser()" />
							</td>
						</tr>
					</table>
				</fieldset>
			</div>
		</div>
		</form:form>
	</body>
</html>