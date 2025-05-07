/**
 * Created by patryk.witkowski_bri on 4/23/2025.
 */

import { LightningElement } from 'lwc';

export default class Discount extends LightningElement {

    discountId;
    handleEdit(event) {
        this.discountId = event.detail;
        const childComponent = this.template.querySelector('c-discount-edit');
        if (childComponent) {
            childComponent.handleOpen();
        }
    }

    handleCreate() {
        const childComponent = this.template.querySelector('c-discount-create');
        if (childComponent) {
            childComponent.handleOpen();
        }
    }

    handleReload() {
        const childComponent = this.template.querySelector('c-discount-list');
        if (childComponent) {
            childComponent.getDiscounts();
        }
    }

    handleState() {
        const childComponent = this.template.querySelector('c-discount-global-state');
        if (childComponent) {
            childComponent.handleOpen();
        }
    }
}