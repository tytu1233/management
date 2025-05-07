/**
 * Created by patryk.witkowski_bri on 4/24/2025.
 */

import {LightningElement, track, api} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createDiscount from "@salesforce/apex/DiscountController.createDiscount";
import NAME_FIELD from "@salesforce/schema/Discount__c.Name";
import START_DATE_FIELD from "@salesforce/schema/Discount__c.Start_Date__c";
import END_DATE_FIELD from "@salesforce/schema/Discount__c.End_Date__c";
import ACTIVE_FIELD from "@salesforce/schema/Discount__c.Active__c";
import TYPE_FIELD from "@salesforce/schema/Discount__c.Discount_Type__c";
import FIXED_AMOUNT_FIELD from "@salesforce/schema/Discount__c.Discount_Amount__c";
import PERCENTAGE_FIELD from "@salesforce/schema/Discount__c.Discount_Percentage__c";
import LWC_Discount_AddDiscount from "@salesforce/label/c.LWC_Discount_AddDiscount";
import LWC_Discount_CreatedSuccessfully from "@salesforce/label/c.LWC_Discount_CreatedSuccessfully";
import LWC_Discount_ErrorCreating from "@salesforce/label/c.LWC_Discount_ErrorCreating";
import Error from "@salesforce/label/c.Error";
import Success from "@salesforce/label/c.Success";

export default class DiscountCreate extends LightningElement {

    label = {
        LWC_Discount_AddDiscount
    }
    fields = [NAME_FIELD, TYPE_FIELD, FIXED_AMOUNT_FIELD, PERCENTAGE_FIELD, START_DATE_FIELD, END_DATE_FIELD, ACTIVE_FIELD]

    isOpen = false;
    isLoading = true;
    disableButton = false;

    get options() {
        return [
            {label: 'Percentage', value: 'Percentage'},
            {label: 'Fixed Amount', value: 'Fixed Amount'},
        ];
    }

    handleSave(event) {
        event.preventDefault();
        this.disableButton = true;
        const {Name, Active__c, Discount_Percentage__c, Discount_Amount__c, Discount_Type__c, Start_Date__c, End_Date__c} = event.detail.fields;
        let numberDiscount = 0;
        if (Discount_Type__c === 'Percentage') {
            numberDiscount = Discount_Percentage__c;
        }

        if (Discount_Type__c === 'Fixed Amount') {
            numberDiscount = Discount_Amount__c;
        }

        const discountData = {
            "discountName": Name,
            "startDate": Start_Date__c,
            "endDate": End_Date__c,
            "discountType": Discount_Type__c,
            "numberDiscount": numberDiscount
        };
        createDiscount({discountData})
            .then(() => {
                this.showToast(Success, LWC_Discount_CreatedSuccessfully, 'success');
                this.disableButton = false;
                this.dispatchEvent(new CustomEvent('created'));
            })
            .catch((err) => {
                this.showToast(Error, err.body.message || LWC_Discount_ErrorCreating, 'error');
                this.disableButton = false;
            });
    }

    @api
    handleOpen() {
        this.isOpen = true;
    }

    handleLoad() {
        this.isLoading = false;
    }

    handleClose() {
        this.isOpen = false;
        this.isLoading = true;
    }

    handleSuccess() {
        this.showToast(Success, LWC_Discount_CreatedSuccessfully, 'success');
        this.dispatchEvent(
            new CustomEvent('reload')
        );
        this.isOpen = false;
        this.isLoading = true;
    }

    handleError() {
        this.showToast(Error, LWC_Discount_ErrorCreating, 'error');
    }


    showToast(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title,
                message,
                variant
            })
        );
    }
}