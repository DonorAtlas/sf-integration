import { LightningElement, api } from 'lwc';
import startSingle from '@salesforce/apex/DonorAtlasService.startSingle';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class EnhanceContact extends LightningElement {
    @api recordId;

    /** Called automatically for headless quick-actions */
    @api invoke() {
        startSingle({ contactId: this.recordId })
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'DonorAtlas',
                        message: 'Enrichment job queued',
                        variant: 'success'
                    })
                );
                this.dispatchEvent(new CloseActionScreenEvent());
            })
            .catch(err => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message:
                            err && err.body ? err.body.message : err.message,
                        variant: 'error'
                    })
                );
                this.dispatchEvent(new CloseActionScreenEvent());
            });
    }
}