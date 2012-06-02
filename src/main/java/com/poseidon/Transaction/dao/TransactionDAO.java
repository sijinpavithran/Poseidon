package com.poseidon.Transaction.dao;

import com.poseidon.Transaction.domain.TransactionVO;
import com.poseidon.Transaction.exception.TransactionException;

import java.util.List;

/**
 * User: Suraj
 * Date: Jun 2, 2012
 * Time: 3:45:52 PM
 */
public interface TransactionDAO {
    public List<TransactionVO> listTodaysTransactions() throws TransactionException;
}
