/**
 * Created by patryk.witkowski_bri on 4/29/2025.
 */

import { LightningElement } from 'lwc';
import LWC_Discount_AddDiscount from "@salesforce/label/c.LWC_Discount_AddDiscount";
import LWC_Discount_Global from "@salesforce/label/c.LWC_Discount_Global";


export default class DiscountMenu extends LightningElement {
    label = {
        LWC_Discount_AddDiscount,
        LWC_Discount_Global
    }
    handleOpenAddDiscount() {
        this.dispatchEvent(
            new CustomEvent('opendiscountadd')
        );
    }

    handleOpenGlobalState() {
        this.dispatchEvent(
            new CustomEvent('openglobalstate')
        );
    }
}