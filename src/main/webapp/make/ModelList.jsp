<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="Suraj">
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <spring:url value="/img/Poseidon_Ico.ico" var="posIcon" />
    <link rel="shortcut icon" href="${posIcon}" />
    <link rel="stylesheet" href="/css/bootstrap.min.css"  type="text/css" />
    <link rel="stylesheet" href="/css/custom.css" type="text/css" />
    <title>Make and Model List</title>
    <script type="text/javascript" src="/js/model-scripts.js"></script>
    <script type="text/javascript" src="/js/navbar-scripts.js"></script>
</head>
<body onload="hideAlerts();">
    <form:form method="POST" modelAttribute="makeForm" >
        <input type="hidden" name="id" id="id"/>
        <form:hidden name="loggedInUser" path="loggedInUser"/>
        <form:hidden name="loggedInRole" path="loggedInRole"/>
        <%@include file="../navbar.jsp" %>
        <div  class="container">
            <div class="wrap">
                <div class="card">
                    <div class="card-header">
                        Search Model
                    </div>
                    <div class="card-body">
                        <div class="card-text">
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                  <label for="makeName">Make Name :</label>
                                  <form:select cssClass="form-control" id="makeName" path="searchMakeAndModelVO.makeId" tabindex="1"
                                                 onkeypress="handleEnter(event);" >
                                        <form:option value="0" label="-- Select --"/>
                                        <form:options items="${makeForm.makeVOs}"
                                                      itemValue="id" itemLabel="makeName"/>
                                    </form:select>
                                </div>
                                <div class="form-group col-md-6">
                                  <label for="modelName">Model Name :</label>
                                  <form:input cssClass="form-control" path="searchMakeAndModelVO.modelName" id="modelName"/>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <div class="form-check">
                                      <form:checkbox path="searchMakeAndModelVO.includes" ccssClass="form-check-input"
                                                       id="includes" value=""/>
                                      <label class="form-check-label" for="includes">
                                        <spring:message code="user.includes" text="Includes" />
                                      </label>
                                    </div>
                                </div>
                                <div class="form-group col-md-6">    
                                    <div class="form-check">
                                      <form:checkbox path="searchMakeAndModelVO.startswith" cssClass="form-check-input"
                                                       id="startswith" value=""/>
                                      <label class="form-check-label" for="startsWith">
                                        <spring:message code="user.startsWith" text="Starts with" />
                                      </label>
                                    </div>
                                </div>
                            </div>
                            <input class="btn btn-primary" value="Search" type="button" onclick="search()"/>
                            <input class="btn btn-primary" value="Clear" type="button" onclick="clearOut()"/>
                        </div>
                    </div>
                </div>
            </div>
            <br/>
            <br/>
            <c:if test="${makeForm.statusMessage!=null}">
                <div class="alert alert-<c:out value="${makeForm.statusMessageType}"/>">
                    <a class="close" data-dismiss="alert" href="#" aria-hidden="true">x</a>
                    <c:out value="${makeForm.statusMessage}"/>
                </div>
            </c:if>
            <div class="panel panel-primary">
                <div class="panel-heading">Model Details</div>
                    <table id='myTable' class="table table-bordered table-striped table-hover">
                        <thead>
                            <tr>
                                <th class="text-center"><spring:message code="poseidon.id" text="id"/></th>
                                <th class="text-center">Make Name</th>
                                <th class="text-center">Model Name</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${makeForm.makeAndModelVOs}" var="iterationMake">
                                <tr>
                                    <td><input type="checkbox" name="checkField" onclick="checkCall(this);"
                                               value="<c:out value="${iterationMake.id}" />"/></td>
                                    <td><c:out value="${iterationMake.makeName}"/></td>
                                    <td><c:out value="${iterationMake.modelName}"/></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                    <table>
                        <tr>
                            <td colspan="5">
                                <br/>
                                <br/>
                            <td>
                        </tr>
                        <tr>
                            <td>
                                <input class="btn btn-primary" value="Make List" type="button" onclick="listAllMake();"/>
                            </td>
                            <td>
                                <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#newModelModal"
                                onclick="AddModel();">Add Model</button>
                            </td>
                            <td>
                                <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#editModelModal"
                                    onclick="editModel();">Edit Model</button>
                            </td>
                            <td>
                                <input class="btn btn-primary" value="Delete Model" type="button" onclick="deleteModel();"/>
                            </td>
                            <td>
                                <input class="btn btn-primary" value="Save Model" type="button" onclick="saveSimpleModel();"/>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>
        <div id="newModelModal" class="modal fade bd-example-modal-lg" role="dialog">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h4 class="modal-title">Add new Model</h4>
                        <button type="button" class="close" data-dismiss="modal">x</button>
                    </div>
                    <div id="modelModalBody" class="modal-body">
                        <p>Lets edit some models....</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" id="saveModal" class="btn btn-default" onclick="saveFromModal();">Save</button>
                    </div>
                </div>
            </div>
        </div>
        <div id="editModelModal" class="modal fade bd-example-modal-lg" role="dialog">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h4 class="modal-title">Edit Model</h4>
                        <button type="button" class="close" data-dismiss="modal">x</button>
                    </div>
                    <div id="modelEditModalBody" class="modal-body">
                        <p>Lets edit the model</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" id="updateModal" class="btn btn-default" onclick="updateFromModal()">Update</button>
                    </div>
                </div>
            </div>
        </div>
        <script src="/js/core/jquery-3.2.1.min.js" type="text/javascript"></script>
        <script src="/js/core/popper.min.js" type="text/javascript"></script>
        <script src="/js/core/bootstrap.min.js" type="text/javascript"></script>
        <script type="text/javascript">
            $(document).ready(function() {
                //Handles menu drop down
                $('.dropdown-menu').find('form').click(function (e) {
                    e.stopPropagation();
                });
            });
        </script>
    </form:form>
</body>
</html>