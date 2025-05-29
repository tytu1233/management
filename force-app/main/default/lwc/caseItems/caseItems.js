/**
 * Created by patryk.witkowski_bri on 5/19/2025.
 */

import getOrderProducts from '@salesforce/apex/OrderController.getOrderProducts';
import {LightningElement, api, wire} from 'lwc';
import LWC_Case_NoOrderItems from '@salesforce/label/c.LWC_Case_NoOrderItems';
import LWC_Case_Table_Price from '@salesforce/label/c.LWC_Case_Table_Price';
import LWC_Case_Table_ProductName from '@salesforce/label/c.LWC_Case_Table_ProductName';
import LWC_Case_Table_External from '@salesforce/label/c.LWC_Case_Table_External';

const columns = [
    { label: LWC_Case_Table_ProductName, fieldName: 'Name', type: 'text' },
    { label: LWC_Case_Table_Price, fieldName: 'Base_Price__c',type: 'decimal' },
    { label: LWC_Case_Table_External, fieldName: 'IsExternal__c',type: 'boolean' },
];

export default class CaseItems extends LightningElement {

    label = {
        LWC_Case_NoOrderItems
    }
    @api orderId;
    orderItems = []
    selectedItems = []
    columns = columns;

    @wire(getOrderProducts, { orderId: '$orderId'})
    items({data, error}) {
        if (data) {
            this.orderItems = data;
        } else {
            console.log(error);
        }
    }

    handleRowSelection(event) {
        this.selectedRows = event.detail.selectedRows;
        this.dispatchEvent(
            new CustomEvent('selection', {
                detail: this.selectedRows
            })
        );
    }
}