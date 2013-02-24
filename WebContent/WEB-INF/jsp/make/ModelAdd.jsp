<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Add Model</title>
    <link rel="stylesheet" type="text/css" href="../css/mainStyles.css" />
    <link rel="stylesheet" type="text/css" href="../css/bootstrap.css" />
    <style type="text/css">
        .textfieldMyStyle {
            border:3px double #CCCCCC;
            width: 200px;
            height:20px;
        }
        .foottable {
            margin:auto;
            top:50%;
            left:50%;
        }
        fieldset
        {
            text-align:right;
        }

        table
        {
            margin:auto;
            top:50%;
            left:50%;
        }
    </style>
    <script type="text/javascript">
        function save(){
            if(document.getElementById('modelName').value.length == 0) {
                document.getElementById('modelName').style.background = 'Yellow';
                alert(" Please enter the Model name");
            }else{
                document.getElementById('modelName').style.background = 'White';
                document.forms[0].action = "saveModel.htm";
                document.forms[0].submit();
            }
        }

        function clearOut(){
            document.getElementById("makeId").value = document.getElementById('makeId').options[0].value;
            document.getElementById('modelName').value = "";
        }
    </script>
  </head>
  <body>
  <form:form method="POST" commandName="makeForm" name="makeForm" >
            <form:hidden name="loggedInUser" path="loggedInUser" />
            <form:hidden name="loggedInRole" path="loggedInRole" />
            <%@include file="/WEB-INF/jsp/myHeader.jsp" %>
            <div id="content">
                <div class="wrap">
                    <fieldset>
                        <legend>Add Model</legend>
                        <table>
                            <tr>
                                <td>
                                    <label for="makeId">
                                        Make Name :
                                    </label>
                                </td>
                                <td colspan="2">&nbsp;</td>
                                <td>
                                    <form:select id="makeId" path="currentMakeAndModeVO.makeId" tabindex="1" onkeypress="handleEnter(event);"
                                                 cssClass="textfieldMyStyle">
                                        <form:options items="${makeForm.makeAndModelVOs}"
                                                      itemValue="makeId" itemLabel="makeName"/>
                                    </form:select>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <label for="modelName">
                                        Model Name :
                                    </label>
                                </td>
                                <td colspan="2">&nbsp;</td>
                                <td>
                                    <form:input path="currentMakeAndModeVO.modelName"
                                                cssClass="textfieldMyStyle" id="modelName"/>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <input class="btn" value="Save" type="button" onclick="javascript:save()"/>
                                </td>
                                <td colspan="2">&nbsp;</td>
                                <td>
                                    <input class="btn" value="Clear" type="button" onclick="javascript:clearOut()"/>
                                </td>
                            </tr>
                        </table>

                    </fieldset>
                </div>
            </div>
      </form:form>

  </body>
</html>
