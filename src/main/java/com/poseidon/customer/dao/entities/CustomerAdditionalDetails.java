package com.poseidon.customer.dao.entities;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.PrePersist;
import javax.persistence.PreUpdate;
import javax.persistence.Table;
import java.time.OffsetDateTime;
import java.time.ZoneId;

@Entity
//todo : add schema
@Table(name = "customer_additional_details")
public class CustomerAdditionalDetails {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "customerId")
    private Long customerId;

    @Column(name = "contactPerson1")
    private String contactPerson1;

    @Column(name = "contactPhone1")
    private String contactPhone1;

    @Column(name = "contactPerson2")
    private String contactPerson2;

    @Column(name = "contactPhone2")
    private String contactPhone2;

    @Column(name = "note")
    private String note;

    @Column(name = "createdOn")
    private OffsetDateTime createdOn;

    @Column(name = "modifiedOn")
    private OffsetDateTime modifiedOn;

    @Column(name = "createdBy")
    private String createdBy;

    @Column(name = "modifiedBy")
    private String modifiedBy;

    public Long getId() {
        return id;
    }

    public void setId(final Long id) {
        this.id = id;
    }

    public Long getCustomerId() {
        return customerId;
    }

    public void setCustomerId(final Long customerId) {
        this.customerId = customerId;
    }

    public String getContactPerson1() {
        return contactPerson1;
    }

    public void setContactPerson1(final String contactPerson1) {
        this.contactPerson1 = contactPerson1;
    }

    public String getContactPhone1() {
        return contactPhone1;
    }

    public void setContactPhone1(final String contactPhone1) {
        this.contactPhone1 = contactPhone1;
    }

    public String getContactPerson2() {
        return contactPerson2;
    }

    public void setContactPerson2(final String contactPerson2) {
        this.contactPerson2 = contactPerson2;
    }

    public String getContactPhone2() {
        return contactPhone2;
    }

    public void setContactPhone2(final String contactPhone2) {
        this.contactPhone2 = contactPhone2;
    }

    public String getNote() {
        return note;
    }

    public void setNote(final String note) {
        this.note = note;
    }

    public OffsetDateTime getCreatedOn() {
        return createdOn;
    }

    public void setCreatedOn(final OffsetDateTime createdOn) {
        this.createdOn = createdOn;
    }

    public OffsetDateTime getModifiedOn() {
        return modifiedOn;
    }

    public void setModifiedOn(final OffsetDateTime modifiedOn) {
        this.modifiedOn = modifiedOn;
    }

    public String getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(final String createdBy) {
        this.createdBy = createdBy;
    }

    public String getModifiedBy() {
        return modifiedBy;
    }

    public void setModifiedBy(final String modifiedBy) {
        this.modifiedBy = modifiedBy;
    }

    /**
     * initialize / update date fields.
     */
    @PrePersist
    @PreUpdate
    public void initializeDate() {
        if (this.getId() == null) {
            createdOn = OffsetDateTime.now(ZoneId.systemDefault());
        }
        modifiedOn = OffsetDateTime.now(ZoneId.systemDefault());
    }
}