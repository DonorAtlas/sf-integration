import { LightningElement, api, wire } from 'lwc';
import enhanceContact from '@salesforce/apex/DonorAtlasService.enhanceContact';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import ENHANCED_FIELD from '@salesforce/schema/Contact.DonorAtlasEnhanced__c';

const FIELDS = [ENHANCED_FIELD];

export default class EnhanceContact extends LightningElement {
    @api recordId;
    isEnhanced;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredContact({ data }) {
        if (data) {
            this.isEnhanced = getFieldValue(data, ENHANCED_FIELD);
        }
    }

    handleEnhance() {
        enhanceContact({ contactId: this.recordId })
            .then(() => {
                this.isEnhanced = true;
            })
            .catch(error => {
                // surface error to user if desired
                console.error(error);
            });
    }
}