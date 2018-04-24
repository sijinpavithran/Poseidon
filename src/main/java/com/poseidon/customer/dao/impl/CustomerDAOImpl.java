package com.poseidon.customer.dao.impl;

import com.poseidon.customer.dao.CustomerDAO;
import com.poseidon.customer.dao.entities.Customer;
import com.poseidon.customer.domain.CustomerVO;
import com.poseidon.customer.exception.CustomerException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * user: Suraj
 * Date: Jun 2, 2012
 * Time: 10:45:56 PM
 */
@Repository
@SuppressWarnings("unused")
public class CustomerDAOImpl implements CustomerDAO {

    private static final Logger LOG = LoggerFactory.getLogger(CustomerDAOImpl.class);

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Autowired
    private CustomerRepository customerRepository;

    public List<CustomerVO> listAllCustomerDetails() throws CustomerException {
        List<CustomerVO> customerVOs;
        try {
            customerVOs = convertToCustomerVO(customerRepository.findAll());
        } catch (DataAccessException e) {
            throw new CustomerException(CustomerException.DATABASE_ERROR);
        }
        return customerVOs;
    }

    public long saveCustomer(CustomerVO currentCustomerVO) throws CustomerException {
        Long id;
        Customer customer = convertToSingleCustomer(currentCustomerVO);
        try {
            Customer newCustomer = customerRepository.save(customer);
            id = newCustomer.getId().longValue();
        } catch (DataAccessException e) {
            LOG.error(e.getLocalizedMessage());
            throw new CustomerException(CustomerException.DATABASE_ERROR);
        }
        return id;
    }

    public CustomerVO getCustomerFromId(Long id) throws CustomerException {
        CustomerVO customerVO;
        try {
            Customer customer = customerRepository.getOne(id.intValue());
            customerVO = convertToSingleCustomerVO(customer);
        } catch (DataAccessException e) {
            LOG.error(e.getLocalizedMessage());
            throw new CustomerException(CustomerException.DATABASE_ERROR);
        }
        return customerVO;
    }

    private CustomerVO convertToSingleCustomerVO(Customer customer) {
        CustomerVO customerVO = new CustomerVO();
        customerVO.setCustomerId(Long.valueOf(customer.getId()));
        customerVO.setCustomerName(customer.getName());
        customerVO.setAddress1(customer.getAddress1());
        customerVO.setAddress2(customer.getAddress2());
        customerVO.setPhoneNo(customer.getPhone());
        customerVO.setMobile(customer.getMobile());
        customerVO.setEmail(customer.getEmail());
        customerVO.setContactPerson1(customer.getContactPerson1());
        customerVO.setContactMobile1(customer.getContactPhone1());
        customerVO.setContactPerson2(customer.getContactPerson2());
        customerVO.setContactMobile2(customer.getContactPhone2());
        customerVO.setNotes(customer.getNote());
        customerVO.setCreatedBy(customer.getCreatedBy());
        customerVO.setCreatedOn(customer.getCreatedOn());
        customerVO.setModifiedBy(customer.getModifiedBy());
        customerVO.setModifiedOn(customer.getModifiedOn());
        return customerVO;
    }

    public void deleteCustomerFromId(Long id) throws CustomerException {
        try {
            customerRepository.deleteById(id.intValue());
        } catch (DataAccessException e) {
            LOG.error(e.getLocalizedMessage());
            throw new CustomerException(CustomerException.DATABASE_ERROR);
        }
    }

    public void updateCustomer(CustomerVO currentCustomerVO) throws CustomerException {
        try {
            Optional<Customer> optionalCustomer = customerRepository.findById(
                    currentCustomerVO.getCustomerId().intValue());

            if (optionalCustomer.isPresent()) {
                Customer customer = optionalCustomer.get();
                customer.setName(currentCustomerVO.getCustomerName());
                customer.setAddress1(currentCustomerVO.getAddress1());
                customer.setAddress2(currentCustomerVO.getAddress2());
                customer.setPhone(currentCustomerVO.getPhoneNo());
                customer.setMobile(currentCustomerVO.getMobile());
                customer.setEmail(currentCustomerVO.getEmail());
                customer.setContactPerson1(currentCustomerVO.getContactPerson1());
                customer.setContactPhone1(currentCustomerVO.getContactMobile1());
                customer.setContactPerson2(currentCustomerVO.getContactPerson2());
                customer.setContactPhone2(currentCustomerVO.getContactMobile2());
                customer.setNote(currentCustomerVO.getNotes());
                customer.setModifiedOn(currentCustomerVO.getModifiedOn());
                customer.setModifiedBy(currentCustomerVO.getModifiedBy());
                customerRepository.save(customer);
            }
        } catch (DataAccessException e) {
            LOG.error(e.getLocalizedMessage());
            throw new CustomerException(CustomerException.DATABASE_ERROR);
        }
    }

    public List<CustomerVO> searchCustomer(CustomerVO searchCustomerVO) throws CustomerException {
        List<CustomerVO> customerVOs;
        try {
            customerVOs = searchCustomerInDetail(searchCustomerVO);
        } catch (DataAccessException e) {
            LOG.error(e.getLocalizedMessage());
            throw new CustomerException(CustomerException.DATABASE_ERROR);
        }
        return customerVOs;
    }

    private Customer convertToSingleCustomer(CustomerVO currentCustomerVO) {
        Customer customer = new Customer();
        customer.setName(currentCustomerVO.getCustomerName());
        customer.setAddress1(currentCustomerVO.getAddress1());
        customer.setAddress2(currentCustomerVO.getAddress2());
        customer.setPhone(currentCustomerVO.getPhoneNo());
        customer.setMobile(currentCustomerVO.getMobile());
        customer.setEmail(currentCustomerVO.getEmail());
        customer.setContactPerson1(currentCustomerVO.getContactPerson1());
        customer.setContactPhone1(currentCustomerVO.getContactMobile1());
        customer.setContactPerson2(currentCustomerVO.getContactPerson2());
        customer.setContactPhone2(currentCustomerVO.getContactMobile2());
        customer.setNote(currentCustomerVO.getNotes());
        customer.setCreatedOn(currentCustomerVO.getCreatedOn());
        customer.setCreatedBy(currentCustomerVO.getCreatedBy());
        customer.setModifiedOn(currentCustomerVO.getModifiedOn());
        customer.setModifiedBy(currentCustomerVO.getModifiedBy());
        return customer;
    }

    private List<CustomerVO> convertToCustomerVO(List<Customer> customers) {
        List<CustomerVO> customerVOS = new ArrayList<>();
        for (Customer customer : customers) {
            CustomerVO customerVO = new CustomerVO();
            customerVO.setCustomerId(Long.valueOf(customer.getId()));
            customerVO.setCustomerName(customer.getName());
            customerVO.setAddress1(customer.getAddress1());
            customerVO.setAddress2(customer.getAddress2());
            customerVO.setPhoneNo(customer.getPhone());
            customerVO.setMobile(customer.getMobile());
            customerVO.setEmail(customer.getEmail());
            customerVO.setContactPerson1(customer.getContactPerson1());
            customerVO.setContactMobile1(customer.getContactPhone1());
            customerVO.setContactPerson2(customer.getContactPerson2());
            customerVO.setContactMobile2(customer.getContactPhone2());
            customerVO.setNotes(customer.getNote());
            customerVO.setCreatedBy(customer.getCreatedBy());
            customerVO.setCreatedOn(customer.getCreatedOn());
            customerVO.setModifiedBy(customer.getModifiedBy());
            customerVO.setModifiedOn(customer.getModifiedOn());
            customerVOS.add(customerVO);
        }
        return customerVOS;
    }

    private List<CustomerVO> searchCustomerInDetail(CustomerVO searchVO) {
        StringBuilder SEARCH_QUERY = new StringBuilder();
        SEARCH_QUERY.append(" SELECT id, name, address1, address2, phone, mobile, email, contactPerson1,")
                .append(" contactPhone1, contactPerson2, ContactPhone2, note FROM customer ");
        Boolean isWhereAdded = Boolean.FALSE;
        if (searchVO.getCustomerId() != null && searchVO.getCustomerId() > 0) {
            SEARCH_QUERY.append(" where ");
            isWhereAdded = Boolean.TRUE;
            SEARCH_QUERY.append(" id = ").append(searchVO.getCustomerId());
        }
        if (searchVO.getCustomerName() != null && searchVO.getCustomerName().trim().length() > 0) {
            if (!isWhereAdded) {
                SEARCH_QUERY.append(" where ");
                isWhereAdded = Boolean.TRUE;
            } else {
                SEARCH_QUERY.append(" and ");
            }
            if (searchVO.getIncludes()) {
                SEARCH_QUERY.append(" name like '%").append(searchVO.getCustomerName()).append("%'");
            } else if (searchVO.getStartsWith()) {
                SEARCH_QUERY.append(" name like '").append(searchVO.getCustomerName()).append("%'");
            } else {
                SEARCH_QUERY.append(" name like '").append(searchVO.getCustomerName()).append("'");
            }
        }
        if (searchVO.getMobile() != null && searchVO.getMobile().trim().length() > 0) {
            if (!isWhereAdded) {
                SEARCH_QUERY.append(" where ");
                isWhereAdded = Boolean.TRUE;
            } else {
                SEARCH_QUERY.append(" and ");
            }
            if (searchVO.getIncludes()) {
                SEARCH_QUERY.append(" mobile like '%").append(searchVO.getMobile()).append("%'");
            } else if (searchVO.getStartsWith()) {
                SEARCH_QUERY.append(" mobile like '").append(searchVO.getMobile()).append("%'");
            } else {
                SEARCH_QUERY.append(" mobile like '").append(searchVO.getMobile()).append("'");
            }
        }
        LOG.info("Search query is " + SEARCH_QUERY.toString());
        return (List<CustomerVO>) jdbcTemplate.query(SEARCH_QUERY.toString(), new CustomerListRowMapper());
    }

    private class CustomerListRowMapper implements RowMapper {
        /**
         * method to map the result to vo
         *
         * @param resultSet resultSet instance
         * @param i         i instance
         * @return UserVO as Object
         * @throws java.sql.SQLException on error
         */
        public Object mapRow(ResultSet resultSet, int i) throws SQLException {
            CustomerVO customerVO = new CustomerVO();
            customerVO.setCustomerId(resultSet.getLong("id"));
            customerVO.setCustomerName(resultSet.getString("name"));
            customerVO.setAddress1(resultSet.getString("address1"));
            customerVO.setAddress2(resultSet.getString("address2"));
            customerVO.setPhoneNo(resultSet.getString("phone"));
            customerVO.setMobile(resultSet.getString("mobile"));
            customerVO.setEmail(resultSet.getString("email"));
            customerVO.setContactPerson1(resultSet.getString("contactPerson1"));
            customerVO.setContactMobile1(resultSet.getString("contactPhone1"));
            customerVO.setContactPerson2(resultSet.getString("contactPerson2"));
            customerVO.setContactMobile2(resultSet.getString("contactPhone2"));
            customerVO.setNotes(resultSet.getString("note"));
            return customerVO;
        }
    }
}
