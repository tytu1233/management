/**
 * Created by patryk.witkowski_bri on 4/23/2025.
 */

import { LightningElement, wire } from 'lwc';
import getDiscounts from "@salesforce/apex/DiscountController.getDiscounts";

export default class Discount extends LightningElement {
    @wire(getDiscounts) discounts;
}