/**
 * Created by patryk.witkowski_bri on 4/24/2025.
 */

import {LightningElement, wire, track, api} from 'lwc';
import getDiscounts from "@salesforce/apex/DiscountController.getDiscounts";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import LWC_Discount_FetchError from "@salesforce/label/c.LWC_Discount_FetchError";
import Error from "@salesforce/label/c.Error";

const actions = [
    { label: 'Edit', name: 'edit_details' },
];

const columns = [
    { label: 'Discount Name', fieldName: 'Name', type: 'text' },
    { label: 'Discount Type', fieldName: 'Discount_Type__c',type: 'text' },
    { label: 'Amount', fieldName: 'Amount__c', type: 'text' },
    { label: 'Start Date', fieldName: 'Start_Date__c', type: 'date'},
    { label: 'End Date', fieldName: 'End_Date__c', type: 'date'},
    { label: 'Active', fieldName: 'Active__c', type: 'boolean'},
    { type: 'action', typeAttributes: { rowActions: actions, menuAlignment: 'right' } }
];
export default class DiscountList extends LightningElement {
    label = {
        LWC_Discount_FetchError
    }
    @track discountsData = [];
    discountError;
    columns = columns;

    /*
    @wire(getDiscounts)
    discounts({data, error}) {
        if (data) {
            const formattedData = data.map((obj) => {
                let amount = '';
                if (obj.Discount_Type__c === "Percentage") amount = (obj.Discount_Percentage__c || 0) + '%'
                if (obj.Discount_Type__c === "Fixed Amount") amount = (obj.Discount_Amount__c || 0) + '$'
                    //console.log(amount)
                return {
                    Name: obj.Name,
                    Discount_Type__c: obj.Discount_Type__c,
                    Amount__c: amount,
                    Start_Date__c: obj.Start_Date__c,
                    End_Date__c: obj.End_Date__c,
                    Active__c: obj.Active__c
                }
            })
            this.discountsData = formattedData;
        } else {
            console.error(error);
            this.discountError = error;
            this.showToast('Error', 'Error during discount fetch. Please try again.', 'error');
        }
    }
    */

    connectedCallback() {
        this.getDiscounts();
    }

    @api
    async getDiscounts() {
        try {
            const data = await getDiscounts();
            const formattedData = data.map((obj) => {
                let amount = '';
                if (obj.Discount_Type__c === "Percentage") amount = (obj.Discount_Percentage__c || 0) + '%';
                if (obj.Discount_Type__c === "Fixed Amount") amount = (obj.Discount_Amount__c || 0) + '$';
                return {
                    Id: obj.Id,
                    Name: obj.Name,
                    Discount_Type__c: obj.Discount_Type__c,
                    Amount__c: amount,
                    Start_Date__c: obj.Start_Date__c,
                    End_Date__c: obj.End_Date__c,
                    Active__c: obj.Active__c
                };
            });
            this.discountsData = formattedData;
        } catch(error) {
            this.discountError = error;
            this.showToast(Error, LWC_Discount_FetchError, 'error');
        }
    }
    handleRowAction(event) {
        const { name } = event.detail.action;
        const { row } = event.detail;
        console.log(row.Id)
        if (name === 'edit_details') {
            this.dispatchEvent(
                new CustomEvent('edit', {
                    detail: row.Id
                })
            );
        }
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