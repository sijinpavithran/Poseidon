<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title><spring:message code="poseidon.userListPage" text="User List" /></title>
    <script type="text/javascript" src="/js/user-scripts.js"></script>
</head>
<body onload="javascript:hideAlerts()">
<form:form method="POST" action="listAll.htm" modelAttribute="userForm">
    <input type="hidden" name="id" id="id" />
    <input type="hidden" name="addInProgress" id="addInProgress" />
    <form:hidden name="loggedInUser" path="loggedInUser" />
    <form:hidden name="loggedInRole" path="loggedInRole" />
    <%@include file="../myHeader.jsp" %>
    <div class="container">
        <div class="wrap">
            <div class="card">
              <div class="card-header">
                <spring:message code="user.searchUser" text="Search User Details" />
              </div>
              <div class="card-body">
                <table class="card-text">
                    <tr>
                        <td>
                            <label for="name" class="control-label">
                                <spring:message code="poseidon.name" text="Name" /> :
                            </label>
                        </td>
                        <td>
                            <form:input cssClass="form-control" path="searchUser.name" id="name" />
                        </td>
                        <td colspan="2">&nbsp;</td>
                        <td>
                            <label for="loginId" class="control-label">
                                <spring:message code="poseidon.loginId" text="loginId" /> :
                            </label>
                        </td>
                        <td>
                            <form:input cssClass="form-control" path="searchUser.loginId" id="loginId" />
                        </td>
                        <td colspan="2">&nbsp;</td>
                        <td>
                            <label for="role" class="control-label">
                                <spring:message code="poseidon.role" text="Role" /> :
                            </label>
                        </td>
                        <td>
                            <form:select id="role" path="searchUser.role" cssClass="form-control"
                                         onkeypress="handleEnter(event);">
                                <form:option value=""><spring:message code="common.select" text="<-- Select -->"/></form:option>
                                <form:options items="${userForm.roleList}" />
                            </form:select>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4">&nbsp;</td>
                    </tr>
                    <tr>
                        <td colspan="8">&nbsp;</td>
                        <td>
                            <label for="includes" class="control-label">
                                <spring:message code="user.includes" text="Includes" />
                                <form:checkbox path="searchUser.includes" cssStyle="vertical-align:middle" id="includes" value="" />
                            </label>
                        </td>
                        <td>
                            <label for="startsWith" class="control-label">
                                <spring:message code="user.startsWith" text="Starts with" />
                                <form:checkbox path="searchUser.startsWith" cssStyle="vertical-align:middle" id="startswith" value="" />
                            </label>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="8">&nbsp;</td>
                        <td>
                            <input class="btn btn-primary" value="<spring:message code='poseidon.search' text='Search' />" type="button" onclick="javascript:search()" />
                        </td>
                        <td>
                            <input class="btn btn-primary" value="<spring:message code='poseidon.clear' text='Clear' />" type="button" onclick="javascript:clearOut()" />
                        </td>
                    </tr>
                </table>
              </div>
            </div>
            <br />
            <br />
            <br />
            <c:if test="${userForm.statusMessage!=null}">
                <div class="alert alert-<c:out value='${userForm.statusMessageType}'/>">
                    <a class="close" data-dismiss="alert" href="#" aria-hidden="true">x</a>
                    <c:out value="${userForm.statusMessage}"/>
                </div>
            </c:if>
            <div class="panel panel-primary">
                <div class="panel-heading"><spring:message code="user.userDetails" text="User Details" /></div>
                <table id='myTable' class="table table-bordered table-striped table-hover">
                    <thead>
                    <tr>
                        <th><spring:message code="poseidon.id" text="id" /></th>
                        <th><spring:message code="poseidon.name" text="Name" /></th>
                        <th><spring:message code="poseidon.loginId" text="loginId" /></th>
                        <th><spring:message code="poseidon.role" text="Role" /></th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${userForm.userVOs}" var="iterationUser">
                        <tr>
                            <td><input type="checkbox" name="checkField" onclick="javascript:checkCall(this)"
                                       value='<c:out value="${iterationUser.id}" />' /></td>
                            <td><c:out value="${iterationUser.name}" /></td>
                            <td><c:out value="${iterationUser.loginId}" /></td>
                            <td><c:out value="${iterationUser.role}" /></td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
                <table class="foottable">
                    <tr>
                        <td>
                            <br/>
                            <br/>
                            <input class="btn btn-primary" value="<spring:message code='poseidon.add' text='Add New User' />" type="button" onclick="javascript:addNewUser()" />
                            <input class="btn btn-primary" value="<spring:message code='poseidon.edit' text='Edit User' />" type="button" onclick="javascript:editMe()" />
                            <input class="btn btn-primary" value="<spring:message code='poseidon.delete' text='Delete User' />" type="button" onclick="javascript:deleteUser()" />
                            <input class="btn btn-primary" value="<spring:message code='poseidon.simple.save' text='Save' />" type="button" onclick="javascript:simpleSave()" />
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</form:form>
</body>
</html>
