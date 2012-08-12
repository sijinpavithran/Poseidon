package com.poseidon.CompanyTerms.dao.impl;

import com.poseidon.CompanyTerms.dao.CompanyTermsDAO;
import com.poseidon.CompanyTerms.domain.CompanyTermsVO;
import com.poseidon.CompanyTerms.exception.CompanyTermsException;

import java.util.List;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.support.JdbcDaoSupport;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.dao.DataAccessException;

/**
 * User: Suraj
 * Date: Jun 2, 2012
 * Time: 10:00:05 PM
 */
public class CompanyTermsDAOImpl extends JdbcDaoSupport implements CompanyTermsDAO {

    private final String GET_COMPANY_TERMS_SQL = "SELECT id, terms, companyName, companyAddress, companyPhone, " +
            " companyEmail,companyWebsite FROM companyterms ;";
    private final String UPDATE_TERMS_SQL = "update companyterms set terms = ?,companyAddress = ?, companyName = ?, " +
            " companyPhone = ?, companyEmail = ? , companyWebsite = ?, modifiedOn = ?, modifiedBy = ?  where id = 1 ;";


    public CompanyTermsVO listCompanyTerms() throws CompanyTermsException {
        CompanyTermsVO companyTermsVO = null;
        try {
            List<CompanyTermsVO> companyTermsVOs = fetchCompanyTerms();
            if (companyTermsVOs != null && companyTermsVOs.size() > 0) {
                companyTermsVO = companyTermsVOs.get(0);
            }
        } catch (DataAccessException e) {
            throw new CompanyTermsException(CompanyTermsException.DATABASE_ERROR);
        }
        return companyTermsVO;
    }

    public void updateCompanyDetails(CompanyTermsVO companyTermsVO) throws CompanyTermsException {

        Object[] parameters = new Object[]{companyTermsVO.getCompanyTerms(),
                companyTermsVO.getCompanyAddress(),
                companyTermsVO.getCompanyName(),
                companyTermsVO.getCompanyPhoneNumber(),
                companyTermsVO.getCompanyEmail(),
                companyTermsVO.getCompanyWebsite(),
                companyTermsVO.getModifiedDate(),
                companyTermsVO.getModifiedBy()};

        try {
            getJdbcTemplate().update(UPDATE_TERMS_SQL, parameters);
        } catch (DataAccessException e) {
            e.printStackTrace();
            throw new CompanyTermsException(CompanyTermsException.DATABASE_ERROR);
        }
    }

    private List<CompanyTermsVO> fetchCompanyTerms() {
        return (List<CompanyTermsVO>) getJdbcTemplate().query(GET_COMPANY_TERMS_SQL, new CompanyTermsRowMapper());
    }

    private class CompanyTermsRowMapper implements RowMapper {
        /**
         * method to map the result to vo
         *
         * @param resultSet resultSet instance
         * @param i         i instance
         * @return UserVO as Object
         * @throws java.sql.SQLException on error
         */
        public Object mapRow(ResultSet resultSet, int i) throws SQLException {
            CompanyTermsVO companyTermsVO = new CompanyTermsVO();
            companyTermsVO.setId(resultSet.getLong("id"));
            companyTermsVO.setCompanyName(resultSet.getString("companyName"));
            companyTermsVO.setCompanyAddress(resultSet.getString("companyAddress"));
            companyTermsVO.setCompanyPhoneNumber(resultSet.getString("companyPhone"));
            companyTermsVO.setCompanyEmail(resultSet.getString("companyEmail"));
            companyTermsVO.setCompanyWebsite(resultSet.getString("companyWebsite"));
            companyTermsVO.setCompanyTerms(resultSet.getString("terms"));
            return companyTermsVO;
        }
    }

}
