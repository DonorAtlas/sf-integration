import { LightningElement, api } from 'lwc';
import startSingle from '@salesforce/apex/DonorAtlasService.startSingle';

export default class EnhanceContact extends LightningElement {
    @api recordId;

    handleClick() {
        startSingle({ contactId: this.recordId })
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'DonorAtlas',
                        message: 'Enrichment started',
                        variant: 'success'
                    })
                );
            })
            .catch(err => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: err.body ? err.body.message : err,
                        variant: 'error'
                    })
                );
            });
    }
}