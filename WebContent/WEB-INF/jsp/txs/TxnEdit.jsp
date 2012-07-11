<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Edit Transaction</title>
        <link rel="stylesheet" type="text/css" href="../css/mainStyles.css"/>
        <script type="text/javascript">
            function update() {
                if(document.getElementById('TagNo').value.length == 0){
                    alert("Please enter a valid TagNo");
                }else if(document.getElementById('productCategory').value.length == 0){
                    alert("Please enter a valid Product Category");
                }else if(document.getElementById('serialNo').value.length == 0){
                    alert("Please enter a valid Serial No");
                }else if(document.getElementById('customerId').value.length == 0){
                        if(document.getElementById('customerName').value.length == 0
                                || document.getElementById('mobile').value.length == 0){
                            alert("Please enter a valid Customer Details");
                        }
                }else if(document.getElementById('makeId').value.length == 0){
                    alert("Please enter a valid Make detail");
                }else if(document.getElementById('modelId').value.length == 0){
                    alert("Please enter a valid Model detail");
                } else {
                    document.forms[0].action = "updateTxn.htm";
                    document.forms[0].submit();
                }
            }

            function cancel() {
                document.forms[0].action = "List.htm";
                document.forms[0].submit();
            }
            function editThisCustomer(){
                if(document.getElementById("customerId") != null){
                    document.forms[0].action = "<%=request.getContextPath()%>" + "/customer/editCustomer.htm"+
                            "?customerId=" +document.getElementById("customerId").value;
                    document.forms[0].submit();
                }else{
                    alert("Unable to get the customer Details !!!");
                }
            }
        </script>
    </head>
    <body style="background: #A9A9A9 ;">
        <form:form method="POST" commandName="transactionForm" name="transactionForm" >
            <form:hidden name="loggedInUser" path="loggedInUser" />
            <form:hidden name="loggedInRole" path="loggedInRole" />
            <form:hidden name="id" path="currentTransaction.id" />
            <%@include file="/WEB-INF/jsp/myHeader.jsp" %>
            <div id="content">
                <fieldset>
                <legend>Edit Transaction</legend>
                <table class="myTable" width="100%" >
                    <tr>
                        <td style="text-align:right;">
                            <label for="productCategory" style="font-size: .70em;">Product Category :</label>
                            <label class="mandatory">*</label>
                        </td>
                        <td style="text-align:left;">
                            <form:input path="currentTransaction.productCategory" cssStyle="border:3px double #CCCCCC; width: 200px;height:20px;"
                                        id="productCategory"/>
                        </td>
                        <td colspan="2"> &nbsp;</td>
                        <td style="text-align:right;">
                            <label for="serialNo" style="font-size: .70em;">Serial No :</label>
                            <label class="mandatory">*</label>
                        </td>
                        <td style="text-align:left;">
                            <form:input path="currentTransaction.serialNo" cssStyle="border:3px double #CCCCCC; width: 200px;height:20px;" id="serialNo"/>
                        </td>
                        <td colspan="2"> &nbsp;</td>
                        <td style="text-align:right;">
                            <label for="dateReported" style="font-size: .70em;">Transaction Date :</label>
                            <label class="mandatory">*</label>
                        </td>
                        <td style="text-align:left;">
                            <form:input path="currentTransaction.dateReported" cssStyle="border:3px double #CCCCCC; width: 200px;height:20px;" id="dateReported"/>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="10"> &nbsp;</td>
                    </tr>
                    <tr>
                        <td style="text-align:right;">
                            <label for="customerId" style="font-size: .70em;">Customer Id :</label>
                            <label class="mandatory">*</label>
                        </td>
                        <td style="text-align:left;">
                            <form:input path="customerVO.customerId" cssStyle="border:3px double #CCCCCC; width: 200px;height:20px;" id="customerId"/>
                        </td>
                        <td colspan="2"> &nbsp;</td>
                        <td colspan="2">
                            <input class="btn" value="Edit Customer Details" type="button" onclick="javascript:editThisCustomer();"/>
                        </td>
                        <td colspan="4"> &nbsp;</td>
                    </tr>
                    <tr>
                        <td style="text-align:right;">
                            <label for="customerName" style="font-size: .70em;">
                                Customer Name :
                            </label>
                        </td>
                        <td style="text-align:left;">
                            <form:input path="customerVO.customerName" cssStyle="border:3px double #CCCCCC; width: 200px;height:20px;background: #A9A9A9 ;"
                                        id="customerName" readonly="true"/>
                        </td>
                        <td colspan="2">&nbsp;</td>
                        <td style="text-align:right;">
                            <label for="address1" style="font-size: .70em;">
                                Address Line 1 :
                            </label>
                        </td>
                        <td style="text-align:left;">
                            <form:textarea path="customerVO.address1" rows="5" cols="30" cssStyle="border:3px double #CCCCCC; width: 200px;height:40px;background: #A9A9A9 ;"
                                           id="address1" readonly="true"/>
                        </td>
                        <td colspan="2"> &nbsp;</td>
                        <td style="text-align:right;">
                            <label for="address2" style="font-size: .70em;">
                                Address Line 2 :
                            </label>
                        </td>
                        <td style="text-align:left;">
                            <form:textarea path="customerVO.address2" rows="5" cols="30" cssStyle="border:3px double #CCCCCC; width: 200px;height:40px;background: #A9A9A9 ;"
                                           id="address2" readonly="true"/>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:right;">
                            <label for="phoneNo" style="font-size: .70em;">
                                Phone :
                            </label>
                        </td>
                        <td style="text-align:left;">
                            <form:input path="customerVO.phoneNo" cssStyle="border:3px double #CCCCCC; width: 200px;height:20px;background: #A9A9A9 ;"
                                        id="phoneNo" readonly="true"/>
                        </td>
                        <td colspan="2">&nbsp;</td>
                        <td style="text-align:right;">
                            <label for="mobile" style="font-size: .70em;">
                                Mobile :
                            </label>
                        </td>
                        <td style="text-align:left;">
                            <form:input path="customerVO.mobile" cssStyle="border:3px double #CCCCCC; width: 200px;height:20px;background: #A9A9A9 ;"
                                        id="mobile" readonly="true"/>
                        </td>
                        <td colspan="2">&nbsp;</td>
                        <td style="text-align:right;">
                            <label for="email" style="font-size: .70em;">
                                Email :
                            </label>
                        </td>
                        <td style="text-align:left;">
                            <form:input path="customerVO.email" cssStyle="border:3px double #CCCCCC; width: 200px;height:20px;background: #A9A9A9 ;"
                                        id="email" readonly="true"/>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:right;">
                            <label for="contactPerson1" style="font-size: .70em;">
                                Contact Person 1 :
                            </label>
                        </td>
                        <td style="text-align:left;">
                            <form:input path="customerVO.contactPerson1" cssStyle="border:3px double #CCCCCC; width: 200px;height:20px;background: #A9A9A9 ;"
                                        id="contactPerson1" readonly="true"/>
                        </td>
                        <td colspan="2">&nbsp;</td>
                        <td style="text-align:right;">
                            <label for="contactMobile1" style="font-size: .70em;">
                                Mobile of Contact Person 1 :
                            </label>
                        </td>
                        <td style="text-align:left;">
                            <form:input path="customerVO.contactMobile1" cssStyle="border:3px double #CCCCCC; width: 200px;height:20px;background: #A9A9A9 ;"
                                        id="contactMobile1" readonly="true"/>
                        </td>
                        <td colspan="4">&nbsp;</td>
                    </tr>
                    <tr>
                        <td style="text-align:right;">
                            <label for="contactPerson2" style="font-size: .70em;">
                                Contact Person 2 :
                            </label>
                        </td>
                        <td style="text-align:left;">
                            <form:input path="customerVO.contactPerson2" cssStyle="border:3px double #CCCCCC; width: 200px;height:20px;background: #A9A9A9 ;"
                                        id="contactPerson2" readonly="true"/>
                        </td>
                        <td colspan="2">&nbsp;</td>
                        <td style="text-align:right;">
                            <label for="contactMobile2" style="font-size: .70em;">
                                Mobile of Contact Person 2 :
                            </label>
                        </td>
                        <td style="text-align:left;">
                            <form:input path="customerVO.contactMobile2" cssStyle="border:3px double #CCCCCC; width: 200px;height:20px;background: #A9A9A9 ;"
                                        id="contactMobile2" readonly="true"/>
                        </td>
                        <td colspan="2">&nbsp;</td>
                        <td style="text-align:right;">
                            <label for="notes" style="font-size: .70em;">
                                Notes :
                            </label>
                        </td>
                        <td style="text-align:left;">
                            <form:textarea path="customerVO.notes" rows="5" cols="30" cssStyle="border:3px double #CCCCCC; width: 200px;height:40px;background: #A9A9A9 ;"
                                           id="notes" readonly="true"/>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="10">&nbsp;</td>
                    </tr>
                    <tr>
                        <td style="text-align:right;">
                            <label for="makeId" style="font-size: .70em;">Make :</label>
                            <label class="mandatory">*</label>
                        </td>
                        <td style="text-align:left;">
                            <form:select id="makeId" path="currentTransaction.makeId" tabindex="1"
                                         onkeypress="handleEnter(event);" onchange="changeTheModel();"
                                         cssStyle="border:3px double #CCCCCC; width: 200px;height:25px;">
                                <form:option value=""><spring:message code="common.select" text="<-- Select -->"/></form:option>
                                <form:options items="${transactionForm.makeVOs}"
                                              itemValue="Id" itemLabel="makeName"/>
                            </form:select>
                        </td>
                        <td colspan="2"> &nbsp;</td>
                        <td style="text-align:right;">
                            <label for="modelId" style="font-size: .70em;">Model :</label>
                            <label class="mandatory">*</label>
                        </td>
                        <td style="text-align:left;">
                            <form:select id="modelId" path="currentTransaction.modelId" tabindex="1"
                                         onkeypress="handleEnter(event);"
                                         cssStyle="border:3px double #CCCCCC; width: 200px;height:25px;">
                                <form:option value=""><spring:message code="common.select" text="<-- Select -->"/></form:option>
                                <form:options items="${transactionForm.makeAndModelVOs}"
                                              itemValue="modelId" itemLabel="modelName"/>
                            </form:select>
                        </td>
                        <td colspan="2"> &nbsp;</td>
                        <td style="text-align:right;">
                            <label for="status" style="font-size: .70em;">
                                Status :
                            </label>
                        </td>
                        <td style="text-align:left;">
                            <form:select id="status" path="currentTransaction.status"
                                         onkeypress="handleEnter(event);"
                                         cssStyle="border:3px double #CCCCCC; width: 200px;height:25px;">
                                <form:option value=""><spring:message code="common.select" text="<-- Select -->"/></form:option>
                                <form:options items="${transactionForm.statusList}" />
                            </form:select>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="10">&nbsp;</td>
                    </tr>
                    <tr>
                        <td style="text-align:right;">
                            <label for="accessories" style="font-size: .70em;">Accessories :</label>
                            <label class="mandatory">*</label>
                        </td>
                        <td style="text-align:left;">
                            <form:textarea path="currentTransaction.accessories" rows="5" cols="30" cssStyle="border:3px double #CCCCCC; width: 200px;height:40px;"
                                           id="accessories"/>
                        </td>
                        <td colspan="2"> &nbsp;</td>
                        <td style="text-align:right;">
                            <label for="complaintReported" style="font-size: .70em;">Complaint Reported :</label>
                            <label class="mandatory">*</label>
                        </td>
                        <td style="text-align:left;">
                            <form:textarea path="currentTransaction.complaintReported" rows="5" cols="30"
                                           cssStyle="border:3px double #CCCCCC; width: 200px;height:40px;"
                                           id="complaintReported"/>
                        </td>
                        <td colspan="2"> &nbsp;</td>
                        <td style="text-align:right;">
                            <label for="complaintDiagonsed" style="font-size: .70em;">Complaint Diagnosed :</label>
                            <label class="mandatory">*</label>
                        </td>
                        <td style="text-align:left;">
                            <form:textarea path="currentTransaction.complaintDiagonsed" rows="5" cols="30"
                                           cssStyle="border:3px double #CCCCCC; width: 200px;height:40px;"
                                           id="complaintDiagonsed"/>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:right;">
                            <label for="enggRemark" style="font-size: .70em;">Engineer Remarks :</label>
                            <label class="mandatory">*</label>
                        </td>
                        <td style="text-align:left;">
                            <form:textarea path="currentTransaction.enggRemark" rows="5" cols="30" cssStyle="border:3px double #CCCCCC; width: 200px;height:40px;"
                                           id="enggRemark"/>
                        </td>
                        <td colspan="2"> &nbsp;</td>
                        <td style="text-align:right;">
                            <label for="repairAction" style="font-size: .70em;">Repair Action :</label>
                            <label class="mandatory">*</label>
                        </td>
                        <td style="text-align:left;">
                            <form:textarea path="currentTransaction.repairAction" rows="5" cols="30" cssStyle="border:3px double #CCCCCC; width: 200px;height:40px;"
                                           id="repairAction"/>
                        </td>
                        <td colspan="2"> &nbsp;</td>
                        <td style="text-align:right;">
                            <label for="notes" style="font-size: .70em;">Notes :</label>
                            <label class="mandatory">*</label>
                        </td>
                        <td style="text-align:left;">
                            <form:textarea path="currentTransaction.notes" rows="5" cols="30" cssStyle="border:3px double #CCCCCC; width: 200px;height:40px;"
                                           id="notes"/>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="10">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td colspan="8">
                            &nbsp;
                        </td>
                        <td colspan="2">
                            <input class="btn" value="Update" type="button" onclick="javascript:update();"/>
                            <input class="btn" value="Cancel" type="button" onclick="javascript:cancel();"/>
                        </td>
                    </tr>
                </table>
            </fieldset>
        </div>
    </form:form>
    </body>
</html>