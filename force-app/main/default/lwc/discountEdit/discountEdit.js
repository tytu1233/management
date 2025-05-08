/**
 * Created by patryk.witkowski_bri on 4/30/2025.
 */

import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import LWC_Discount_Update from "@salesforce/label/c.LWC_Discount_Update";
import LWC_Discount_Close from "@salesforce/label/c.LWC_Discount_Close";
import LWC_Discount_EditDiscount from "@salesforce/label/c.LWC_Discount_Edit";
import Success from "@salesforce/label/c.Success";
import Error from "@salesforce/label/c.Error";
import LWC_Discount_ErrorEditing from "@salesforce/label/c.LWC_Discount_ErrorEditing";
import LWC_Discount_EditedSuccessfully from "@salesforce/label/c.LWC_Discount_EditedSuccessfully";

export default class DiscountEdit extends LightningElement {

    label = {
        LWC_Discount_Update,
        LWC_Discount_Close,
        LWC_Discount_EditDiscount
    }
    @api discountId;
    isOpen = false;
    isLoading = true;
    displayForm = false;
    @api
    handleOpen() {
        this.isOpen = true;
    }

    handleLoading(event) {
        this.isLoading = false;
        this.displayForm = true;
    }

    handleLoadingDisable() {
        this.isLoading = false;
    }
    handleClose() {
        this.isOpen = false;
    }

    handleSuccess() {
      this.dispatchEvent(
          new ShowToastEvent({
              title: Success,
              message: LWC_Discount_EditedSuccessfully,
              variant: 'success'
          })
      )

      this.dispatchEvent(
          new CustomEvent('reload')
      )
      this.isOpen = false;
    }

    handleError() {
      this.dispatchEvent(
          new ShowToastEvent({
              title: Error,
              message: LWC_Discount_ErrorEditing,
              variant: 'error'
          })
      )
    }
}