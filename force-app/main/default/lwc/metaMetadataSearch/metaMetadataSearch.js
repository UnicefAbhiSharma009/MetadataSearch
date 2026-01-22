import { LightningElement, track } from 'lwc';
import searchMetadata from '@salesforce/apex/META_MetadataSearchController.searchMetadata';

const TYPE_OPTIONS = [
    { label: 'Apex Class', value: 'ApexClass' },
    { label: 'Apex Trigger', value: 'ApexTrigger' },
    { label: 'Visualforce Page', value: 'ApexPage' },
    { label: 'Apex Component', value: 'ApexComponent' },
    { label: 'Profile', value: 'Profile' },
    { label: 'Permission Set', value: 'PermissionSet' },
    { label: 'Permission Set Group', value: 'PermissionSetGroup' },
    { label: 'Static Resource', value: 'StaticResource' },
    { label: 'Report', value: 'Report' },
    { label: 'Dashboard', value: 'Dashboard' },
    { label: 'Email Template', value: 'EmailTemplate' },
    { label: 'Object', value: 'Object' },
    { label: 'Field', value: 'Field' },
    { label: 'Custom Metadata Type', value: 'CustomMetadataType' }
];

export default class MetaMetadataSearch extends LightningElement {
    @track searchTerm = '';
    @track type = null;
    @track results = [];
    @track loading = false;
    @track error;
    @track resultLimit = 50; // Configurable in code only

    // Returns true if the type should show Folder column instead of API Version
    // Used for conditional column header
    get showFolderColumn() {
        // If any result is a folder type, show Folder column header
        return (this.results || []).some(r => r.isFolderType);
    }

    get typeOptions() {
        return [
            { label: '-- Select Type --', value: null },
            ...TYPE_OPTIONS
        ];
    }

    handleSearchTermChange(event) {
        this.searchTerm = event.target.value;
        this.handleSearch();
    }

    handleClear() {
        this.searchTerm = '';
        this.type = null;
        this.results = [];
        this.error = undefined;
    }

    // To change the result limit, update resultLimit property above.

    handleTypeChange(event) {
        this.type = event.detail.value === '' || event.detail.value === null ? null : event.detail.value;
        this.handleSearch();
    }

    handleSearch() {
        this.loading = true;
        this.error = undefined;
        this.results = []; // Always clear results before new search
        const limit = this.resultLimit;
        // If type is null, pass undefined to Apex to trigger all types search
        const typeParam = this.type === null ? undefined : this.type;
        searchMetadata({ searchTerm: this.searchTerm, type: typeParam, limit })
            .then((data) => {
                this.results = (data || []).slice(0, limit).map(item => ({
                    ...item,
                    recordUrl: this.computeRecordUrl(item),
                    isFolderType: item.type === 'Report' || item.type === 'Dashboard' || item.type === 'EmailTemplate'
                }));
                this.loading = false;
            })
            .catch((err) => {
                this.error = err.body ? err.body.message : err.message;
                this.results = [];
                this.loading = false;
            });
    }

    computeRecordUrl(item) {
        if (item.type === 'ApexClass') {
            return `/lightning/setup/ApexClasses/page?address=%2F${item.id}`;
        } else if (item.type === 'ApexTrigger') {
            return `/lightning/setup/ApexTriggers/page?address=%2F${item.id}`;
        } else if (item.type === 'ApexPage') {
            return `/lightning/setup/ApexPages/page?address=%2F${item.id}`;
        } else if (item.type === 'ApexComponent') {
            return `/lightning/setup/ApexComponents/page?address=%2F${item.id}`;
        } else if (item.type === 'Profile') {
            return `/lightning/setup/Profiles/page?address=%2F${item.id}`;
        } else if (item.type === 'PermissionSet') {
            return `/lightning/setup/PermSets/page?address=%2F${item.id}`;
        } else if (item.type === 'PermissionSetGroup') {
            return `/lightning/setup/PermSetGroups/page?address=%2F${item.id}`;
        } else if (item.type === 'StaticResource') {
            return `/lightning/setup/StaticResources/page?address=%2F${item.id}`;
        } else if (item.type === 'Report') {
            return `/lightning/r/Report/${item.id}/view`;
        } else if (item.type === 'Dashboard') {
            return `/lightning/r/Dashboard/${item.id}/view`;
        } else if (item.type === 'EmailTemplate') {
            return `/lightning/setup/CommunicationTemplatesEmail/page?address=%2F${item.id}`;
        } else if (item.type === 'Object') {
            return `/lightning/setup/ObjectManager/${item.name}/Details/view`;
        } else if (item.type === 'Field') {
            return `/lightning/setup/ObjectManager/${item.objectName}/FieldsAndRelationships/${item.id}/view`;
        } else if (item.type === 'CustomMetadataType') {
            return `/lightning/setup/CustomMetadata/page?address=%2F${item.id}%3Fsetupid%3DCustomMetadata`;
        }
        return '#';
    }
}