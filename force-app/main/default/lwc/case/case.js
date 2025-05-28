// @ts-nocheck
/**
 * Created by patryk.witkowski_bri on 5/19/2025.
 */

import { LightningElement, api } from 'lwc';
import { CloseActionScreenEvent } from 'lightning/actions';
import createCaseAndPublishEvent from '@salesforce/apex/CaseController.createCaseAndPublishEvent'
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import {
    subscribe,
    unsubscribe,
    onError
} from 'lightning/empApi';

import LWC_Case_Created from '@salesforce/label/c.LWC_Case_Created'
import LWC_Case_Complaint from '@salesforce/label/c.LWC_Case_Complaint'
import LWC_Case_Description from '@salesforce/label/c.LWC_Case_Description'
import LWC_Case_Subject from '@salesforce/label/c.LWC_Case_Subject'
import LWC_Case_Priority from '@salesforce/label/c.LWC_Case_Priority'
import LWC_Case_ChoosePriority from '@salesforce/label/c.LWC_Case_ChoosePriority'
import Save from '@salesforce/label/c.Save'
import Cancel from '@salesforce/label/c.Cancel'

export default class Case extends NavigationMixin(LightningElement) {

    label = {
        LWC_Case_Created,
        LWC_Case_Complaint,
        LWC_Case_Description,
        LWC_Case_Subject,
        LWC_Case_Priority,
        LWC_Case_ChoosePriority,
        Cancel,
        Save
    }
    @api recordId;
    selectedItems = [];
    isLoading = false;
    channelName = '/event/Case_Response__e';
    subscription = {};

    data = {}
    message = '';
    subject = '';
    description = '';
    priority = '';
    disableButton = true;

    handleSubject(event) {
        this.subject = event.target.value;
    }

    handleDescription(event) {
        this.description = event.target.value;
    }

    handleChannelName(event) {
        this.channelName = event.target.value;
    }

    handleData(event) {
        const {name} = event.target;
        this.data = {
            ...this.data,
            [name]: event.target.value,
        };
    }

    connectedCallback() {
        this.handleSubscribe();
        this.registerErrorListener();
    }

    disconnectedCallback() {
        this.handleUnsubscribe();
    }
    handleSubscribe() {
        const messageCallback = (response) => {
            console.log('New message received: ', JSON.stringify(response));
            this.message = response.data.payload.Status__c;
            this.isLoading = false;
            if (response.data.payload.Status__c === 'Succeed' && this.customObject.caseId === response.data.payload.ExternalId__c) {
                this.showToast('Success', response.data.payload.Status__c, 'success');
                this.dispatchEvent(new CloseActionScreenEvent());
            } else {
                this.showToast('Error', response.data.payload.Status__c, 'error');
            }
        };

        subscribe(this.channelName, -1, messageCallback).then((response) => {
            console.log(
                'Subscription request sent to: ',
                JSON.stringify(response.channel)
            );
            this.subscription = response;
        });
    }

    handleUnsubscribe() {
        unsubscribe(this.subscription, (messageCallback) => {
            console.log(messageCallback);
            console.log('unsubscribe event succeed: ' + messageCallback.successful);
        })
        this.subscription = {};
    }

    registerErrorListener() {
        onError((error) => {
            console.log('Received error from server: ', JSON.stringify(error));
        });
    }
    handleCancel() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }
    async handleSave() {
        const caseData = {
            ...this.data,
            "orderId": this.recordId,
            "selectedItems": this.selectedItems
        }
        this.isLoading = true;
        try {
            const response = await createCaseAndPublishEvent({caseData});
            this.customObject = response;
            if (response.containsExternal == false) {
                this.isLoading = false;
                this.showToast('Success', LWC_Case_Created, 'success');
                    this[NavigationMixin.Navigate]({
                        type: 'standard__recordPage',
                        attributes: {
                            recordId: response.caseId,
                            objectApiName: 'Case',
                            actionName: 'view'
                        },
                    });
            }
        } catch (error) {
            console.log(error);
            this.showToast('Error', error.body.message, 'error');
            this.isLoading = false;
        }
    }

    handleSelected(event) {
        this.selectedItems = event.detail;
        this.disableButton = this.selectedItems.length === 0;
    }

    handlePriority(event) {
        this.priority = event.detail.value;
    }

    get options() {
        return [
            { label: 'Low', value: 'Low' },
            { label: 'Medium', value: 'Medium' },
            { label: 'High', value: 'High' },
        ];
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