package com.poseidon.transaction.web.controller;

import com.poseidon.customer.domain.CustomerVO;
import com.poseidon.customer.exception.CustomerException;
import com.poseidon.customer.service.CustomerService;
import com.poseidon.make.domain.MakeAndModelVO;
import com.poseidon.make.domain.MakeVO;
import com.poseidon.make.service.MakeService;
import com.poseidon.transaction.domain.TransactionVO;
import com.poseidon.transaction.exception.TransactionException;
import com.poseidon.transaction.service.TransactionService;
import com.poseidon.transaction.web.form.TransactionForm;
import org.codehaus.jackson.map.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.io.IOException;
import java.time.OffsetDateTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

/**
 * user: Suraj.
 * Date: Jun 2, 2012
 * Time: 3:33:20 PM
 */
@Controller
//@RequestMapping("/txs")
@SuppressWarnings("unused")
public class TransactionController {
    private static final Logger LOG = LoggerFactory.getLogger(TransactionController.class);
    private static final String SUCCESS = "success";
    private static final String ERROR = "error";
    private static final String DATA_FROM_DATABASE = " An error occurred while fetching data from database. !! ";
    private static final String UNKNOWN_ERROR = " An Unknown Error has been occurred !!";
    private static final String EXCEPTION_IN_CONTROLLER = " Exception type in controller {}";
    private static final String TRANSACTION_VO = " transaction vo is {}";
    private static final String MAKE_VO = "make vo is {}";
    private static final String TRANSACTION_LIST = "txs/TransactionList";
    private static final String TRANSACTION_FORM = "transactionForm";

    @Autowired
    private TransactionService transactionService;

    @Autowired
    private MakeService makeService;

    @Autowired
    private CustomerService customerService;

    /**
     * List all transactions.
     *
     * @param transactionForm TransactionForm
     * @return view
     */
    @PostMapping("/txs/List.htm")
    public ModelAndView list(final TransactionForm transactionForm) {
        List<TransactionVO> transactionVOs = null;
        try {
            transactionVOs = transactionService.listAllTransactions();
        } catch (Exception ex) {
            LOG.error(ex.getLocalizedMessage());
        }
        if (transactionVOs != null) {
            transactionVOs.stream().map(transactionVO -> " transaction vo is " + transactionVO).forEach(LOG::info);
            transactionForm.setTransactionsList(transactionVOs);
        }
        //get all the make list for displaying in search
        transactionForm.setMakeVOs(getMakeVOS());
        transactionForm.setSearchTransaction(new TransactionVO());
        transactionForm.setLoggedInRole(transactionForm.getLoggedInRole());
        transactionForm.setLoggedInUser(transactionForm.getLoggedInUser());
        transactionForm.setStatusList(populateStatus());
        return new ModelAndView(TRANSACTION_LIST, TRANSACTION_FORM, transactionForm);
    }

    private List<MakeVO> getMakeVOS() {
        List<MakeVO> makeVOs = null;
        try {
            makeVOs = makeService.fetchMakes();
        } catch (Exception ex) {
            LOG.error(ex.getMessage());
        }
        return makeVOs;
    }

    private List<String> populateStatus() {
        return Arrays.stream(TransactionStatus.values()).map(Enum::name).collect(Collectors.toList());
    }

    /**
     * add a new transaction.
     *
     * @param transactionForm TransactionForm
     * @return view
     */
    @PostMapping("/txs/AddTxn.htm")
    public ModelAndView addTxn(final TransactionForm transactionForm) {
        LOG.info(" Inside AddTxn method of TransactionController ");
        //get all the make list for displaying in search
        var makeVOs = getMakeVOS();
        List<MakeAndModelVO> makeAndModelVOs = null;
        if (makeVOs != null && !makeVOs.isEmpty()) {
            transactionForm.setMakeVOs(makeVOs);
            LOG.info("The selected make id is {}", makeVOs.get(0).getId());
            makeAndModelVOs = makeService.getAllModelsFromMakeId(makeVOs.get(0).getId());
        }
        if (makeAndModelVOs != null) {
            transactionForm.setMakeAndModelVOs(makeAndModelVOs);
            makeAndModelVOs.stream().map(makeAndModelVO -> "makeAndModel vo is" + makeAndModelVO)
                    .forEach(LOG::info);
        }
        transactionForm.setCurrentTransaction(new TransactionVO());
        transactionForm.setCustomerVO(new CustomerVO());
        return new ModelAndView("txs/TxnAdd", TRANSACTION_FORM, transactionForm);
    }

    /**
     * save the current transaction.
     *
     * @param transactionForm TransactionForm
     * @return view
     */
    @PostMapping("/txs/SaveTxn.htm")
    public ModelAndView saveTxn(final TransactionForm transactionForm) {
        LOG.info(" Inside SaveTxn method of TransactionController ");
        LOG.info(" form details are {} ", transactionForm);
        var transactionVO = transactionForm.getCurrentTransaction();
        if (transactionForm.getCurrentTransaction() != null) {
            transactionVO.setCreatedOn(OffsetDateTime.now(ZoneId.systemDefault()));
            transactionVO.setModifiedOn(OffsetDateTime.now(ZoneId.systemDefault()));
            transactionVO.setCreatedBy(transactionForm.getLoggedInUser());
            transactionVO.setModifiedBy(transactionForm.getLoggedInUser());
            transactionVO.setStatus("NEW");
        }
        if (hasValidCustomerId(transactionForm)) {
            transactionVO.setCustomerId(transactionForm.getCustomerVO().getCustomerId());
        }
        try {
            if (transactionVO != null && transactionVO.getCustomerId() == null) {
                transactionForm.getCustomerVO().setCreatedOn(OffsetDateTime.now(ZoneId.systemDefault()));
                transactionForm.getCustomerVO().setModifiedOn(OffsetDateTime.now(ZoneId.systemDefault()));
                transactionForm.getCustomerVO().setCreatedBy(transactionForm.getLoggedInUser());
                transactionForm.getCustomerVO().setModifiedBy(transactionForm.getLoggedInUser());
                long customerId = customerService.saveCustomer(transactionForm.getCustomerVO());
                transactionForm.getCustomerVO().setCustomerId(customerId);
                transactionVO.setCustomerId(customerId);
                LOG.info("the customer id from db is  {}", customerId);
            }
            String tagNo = transactionService.saveTransaction(transactionVO);
            transactionForm.setStatusMessage("Successfully added the transaction, Tag Number is " + tagNo);
            transactionForm.setStatusMessageType(SUCCESS);
        } catch (TransactionException | CustomerException ex) {
            transactionForm.setStatusMessage("Unable to create a new transaction due to a Data base error");
            transactionForm.setStatusMessageType(ERROR);
            LOG.error(ex.getLocalizedMessage());
        }
        transactionForm.setLoggedInUser(transactionForm.getLoggedInUser());
        transactionForm.setLoggedInRole(transactionForm.getLoggedInRole());
        transactionForm.setCurrentTransaction(new TransactionVO());
        return list(transactionForm);
    }

    private boolean hasValidCustomerId(final TransactionForm transactionForm) {
        return transactionForm.getCustomerVO() != null
                && transactionForm.getCustomerVO().getCustomerId() != null
                && transactionForm.getCustomerVO().getCustomerId() > 0;
    }

    /**
     * search transactions.
     *
     * @param transactionForm TransactionForm
     * @return view
     */
    @PostMapping("/txs/SearchTxn.htm")
    public ModelAndView searchTxn(final TransactionForm transactionForm) {
        LOG.info(" Inside SearchTxn method of TransactionController ");
        LOG.info(" form details are {}", transactionForm);
        LOG.info(" form search details are {}", transactionForm.getSearchTransaction());
        List<TransactionVO> transactionVOs = null;
        try {
            transactionVOs = transactionService.searchTransactions(transactionForm.getSearchTransaction());
            transactionForm.setStatusMessage("Found " + transactionVOs.size() + " Transactions ");
            transactionForm.setStatusMessageType("info");
        } catch (TransactionException ex) {
            transactionForm.setStatusMessage("Unable to search due to a data base error");
            transactionForm.setStatusMessageType(ERROR);
            LOG.error(ex.getLocalizedMessage());
        }
        if (transactionVOs != null) {
            transactionVOs.forEach(transactionVO -> LOG.debug(TRANSACTION_VO, transactionVO));
            transactionForm.setTransactionsList(transactionVOs);
        }
        transactionForm.setMakeVOs(getMakeVOS());
        transactionForm.setLoggedInRole(transactionForm.getLoggedInRole());
        transactionForm.setLoggedInUser(transactionForm.getLoggedInUser());
        transactionForm.setStatusList(populateStatus());
        return new ModelAndView(TRANSACTION_LIST, TRANSACTION_FORM, transactionForm);
    }

    /**
     * edit a transaction.
     *
     * @param transactionForm TransactionForm
     * @return view
     */
    @PostMapping("/txs/EditTxn.htm")
    public ModelAndView editTxn(final TransactionForm transactionForm) {
        LOG.info(" EditTxn method of TransactionController ");
        LOG.info(" transactionForm is {}", transactionForm);
        TransactionVO transactionVO = null;
        CustomerVO customerVO = null;
        try {
            transactionVO = transactionService.fetchTransactionFromId(transactionForm.getId());
            if (transactionVO != null && transactionVO.getCustomerId() != null && transactionVO.getCustomerId() > 0) {
                customerVO = customerService.getCustomerFromId(transactionVO.getCustomerId());
            }
            if (transactionVO != null && transactionVO.getMakeId() != null && transactionVO.getMakeId() > 0) {
                transactionForm.setMakeVOs(getMakeVOS());
                List<MakeAndModelVO> makeAndModelVOs;
                makeAndModelVOs = makeService.getAllModelsFromMakeId(transactionVO.getMakeId());
                if (makeAndModelVOs != null) {
                    transactionForm.setMakeAndModelVOs(makeAndModelVOs);
                    makeAndModelVOs.forEach(makeAndModelVO -> LOG.info("makeAndModel vo is {}", makeAndModelVO));
                }
            }
        } catch (TransactionException | CustomerException ex) {
            LOG.error(ex.getLocalizedMessage());
        }
        if (transactionVO != null) {
            LOG.info("transactionVO {}", transactionVO);
        }
        transactionForm.setCurrentTransaction(transactionVO);
        transactionForm.setCustomerVO(Objects.requireNonNullElseGet(customerVO, CustomerVO::new));
        transactionForm.setStatusList(populateStatus());
        transactionForm.setLoggedInRole(transactionForm.getLoggedInRole());
        transactionForm.setLoggedInUser(transactionForm.getLoggedInUser());
        return new ModelAndView("txs/TxnEdit", TRANSACTION_FORM, transactionForm);
    }

    /**
     * update transaction.
     *
     * @param transactionForm TransactionForm
     * @return view
     */
    @PostMapping("/txs/updateTxn.htm")
    public ModelAndView updateTxn(final TransactionForm transactionForm) {
        LOG.info(" updateTxn method of TransactionController ");
        LOG.info("TransactionForm values are {}", transactionForm);
        if (transactionForm.getCurrentTransaction() != null) {
            transactionForm.getCurrentTransaction().setModifiedBy(transactionForm.getLoggedInUser());
            transactionForm.getCurrentTransaction().setModifiedOn(OffsetDateTime.now(ZoneId.systemDefault()));
        }
        LOG.info("TransactionForm, current transactions are values are {}", transactionForm.getCurrentTransaction());
        try {
            transactionService.updateTransaction(transactionForm.getCurrentTransaction());
            transactionForm.setStatusMessage("Successfully updated the transaction");
            transactionForm.setStatusMessageType(SUCCESS);
        } catch (Exception ex) {
            transactionForm.setStatusMessage("Unable to update the selected transaction");
            transactionForm.setStatusMessageType(ERROR);
            LOG.error(ex.getLocalizedMessage());
            LOG.info(UNKNOWN_ERROR);
        }
        List<TransactionVO> transactionVOs = null;
        try {
            transactionVOs = transactionService.listTodaysTransactions();
        } catch (Exception ex) {
            LOG.error(ex.getLocalizedMessage());
        }
        if (transactionVOs != null) {
            transactionVOs.forEach(transactionVO -> LOG.info(TRANSACTION_VO, transactionVO));
            transactionForm.setTransactionsList(transactionVOs);
        }
        transactionForm.setMakeVOs(getMakeVOS());
        transactionForm.setSearchTransaction(new TransactionVO());
        transactionForm.setLoggedInRole(transactionForm.getLoggedInRole());
        transactionForm.setLoggedInUser(transactionForm.getLoggedInUser());
        transactionForm.setStatusList(populateStatus());
        return new ModelAndView(TRANSACTION_LIST, TRANSACTION_FORM, transactionForm);
    }

    /**
     * delete transaction.
     *
     * @param transactionForm TransactionForm
     * @return view
     */
    @PostMapping("/txs/DeleteTxn.htm")
    public ModelAndView deleteTxn(final TransactionForm transactionForm) {
        LOG.info(" DeleteTxn method of TransactionController ");
        LOG.info("TransactionForm values are {}", transactionForm);
        try {
            transactionService.deleteTransaction(transactionForm.getId());
            transactionForm.setStatusMessage("Successfully deleted the transaction");
            transactionForm.setStatusMessageType(SUCCESS);
        } catch (TransactionException ex) {
            transactionForm.setStatusMessage("Unable to delete the selected transaction due to a Data base error");
            transactionForm.setStatusMessageType(ERROR);
            LOG.error(ex.getLocalizedMessage());
            LOG.error(EXCEPTION_IN_CONTROLLER, ex.exceptionType);
            if (ex.getExceptionType().equalsIgnoreCase(TransactionException.DATABASE_ERROR)) {
                LOG.info(DATA_FROM_DATABASE);
            } else {
                LOG.info(UNKNOWN_ERROR);
            }
        } catch (Exception ex) {
            transactionForm.setStatusMessage("Unable to delete the selected transaction");
            transactionForm.setStatusMessageType(ERROR);
            LOG.error(ex.getLocalizedMessage());
            LOG.info(UNKNOWN_ERROR);
        }
        List<TransactionVO> transactionVOs = null;
        try {
            transactionVOs = transactionService.listTodaysTransactions();
        } catch (Exception ex) {
            LOG.error(ex.getLocalizedMessage());
        }
        if (transactionVOs != null) {
            transactionVOs.forEach(transactionVO -> LOG.info(TRANSACTION_VO, transactionVO));
            transactionForm.setTransactionsList(transactionVOs);
        }
        transactionForm.setMakeVOs(getMakeVOS());
        transactionForm.setSearchTransaction(new TransactionVO());
        transactionForm.setLoggedInRole(transactionForm.getLoggedInRole());
        transactionForm.setLoggedInUser(transactionForm.getLoggedInUser());
        transactionForm.setStatusList(populateStatus());
        return new ModelAndView(TRANSACTION_LIST, TRANSACTION_FORM, transactionForm);
    }

    /**
     * update model drop down via ajax.
     *
     * @param selectMakeId selectMakeId
     */
    @GetMapping(value = "/txs/UpdateModelAjax.htm")
    public @ResponseBody
    String updateModelAjax(@ModelAttribute("selectMakeId") final String selectMakeId) {
        String responseString = "";
        LOG.info(" At UpdateModelAjax, selectMakeId is : {}", selectMakeId);
        List<MakeAndModelVO> makeAndModelVOs;
        try {
            makeAndModelVOs = makeService.getAllModelsFromMakeId(Long.valueOf(selectMakeId));
            if (makeAndModelVOs != null && !makeAndModelVOs.isEmpty()) {
                responseString = makeAndModelJson(makeAndModelVOs);
            }
        } catch (Exception ex) {
            LOG.error(ex.getLocalizedMessage());
        }
        return responseString;
    }

    private String makeAndModelJson(final List<MakeAndModelVO> makeAndModelVOs) {
        String response;
        List<Map<String, String>> makeAndModelList = new ArrayList<>();
        for (MakeAndModelVO makeAndModelVO : makeAndModelVOs) {
            Map<String, String> mmMap = new HashMap<>();
            mmMap.put("id", String.valueOf(makeAndModelVO.getModelId()));
            mmMap.put("modelName", makeAndModelVO.getModelName());
            makeAndModelList.add(mmMap);
        }
        ObjectMapper mapper = new ObjectMapper();
        try {
            response = mapper.writeValueAsString(makeAndModelList);
        } catch (IOException ex) {
            response = ERROR;
            LOG.error("error parsing to json : " + ex.getMessage());
        }
        LOG.info("response json : " + response);
        return response;
    }
}
