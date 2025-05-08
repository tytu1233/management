/**
 * Created by patryk.witkowski_bri on 4/23/2025.
 */

import {api, LightningElement, wire} from 'lwc';
import getDiscountsSettings from "@salesforce/apex/DiscountSettings.getDiscountsSettings";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import updateStrategyType from '@salesforce/apex/DiscountSettings.updateDiscountSetting';
import LWC_Discount_EditSettings from "@salesforce/label/c.LWC_Discount_EditSettings";
import LWC_Discount_GlobalSettings from "@salesforce/label/c.LWC_Discount_GlobalSettings";
import LWC_Discount_Choose from "@salesforce/label/c.LWC_Discount_Choose";
import LWC_Discount_Cancel from "@salesforce/label/c.LWC_Discount_Cancel";
import LWC_Discount_Update from "@salesforce/label/c.LWC_Discount_Update";
import Success from "@salesforce/label/c.Success";
import Error from "@salesforce/label/c.Error";
import LWC_Discount_ErrorEditingSettings from "@salesforce/label/c.LWC_Discount_ErrorEditingSettings";
import Discount_LWC_MetadataUpdated from "@salesforce/label/c.Discount_LWC_MetadataUpdated";
export default class DiscountGlobalState extends LightningElement {
    label = {
        LWC_Discount_EditSettings,
        LWC_Discount_GlobalSettings,
        LWC_Discount_Choose,
        LWC_Discount_Cancel,
        LWC_Discount_Update
    }
    globalSetting = '';
    disabledButton = true;
    isOpen = false;

    @wire(getDiscountsSettings)
    setting({data, error}) {
        if (data) {
            this.globalSetting = data[0].value;
        }
        if (error) {
            this.showToast(Error, error.body.message | LWC_Discount_ErrorEditingSettings, 'error')
        }
    }

    get options() {
        return [
            { label: 'Combine', value: 'Combine' },
            { label: 'Minimum', value: 'Minimum' },
            { label: 'Maximum', value: 'Maximum' },
        ];
    }

    handleSettingChange(event) {
        this.globalSetting = event.detail.value;
        this.disabledButton = false;
    }

    async handleUpdateSetting() {
        try {
            await updateStrategyType({
                "metadataType": this.globalSetting
            });
            this.showToast(Success, Discount_LWC_MetadataUpdated, 'success');
            this.isOpen = false;
        } catch (error) {
            this.showToast(Error, error.body.message, 'error');
        }
    }

    @api
    handleOpen() {
        this.isOpen = true;
    }

    handleClose() {
        this.isOpen = false;
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