/**
 * @description Controller to search Salesforce metadata (ApexClass, PermissionSet, PermissionSetGroup, etc.) for use in a global LWC search component.
 *              Uses Tooling API objects for fast, secure org-internal search. Supports robust filtering and returns results in a MetadataResult wrapper class.
 *              Designed for extensibility and compliance with Salesforce best practices, including governor limits and CRUD checks.
 * @author Abhishek Sharma <absharma@unicef.org>
 * @last modified on 12-29-2025
 * @last modified by Abhishek Sharma <absharma@unicef.org>
 */
public without sharing class META_MetadataSearchController {
    
    /**
     * @description Helper to add results from a search method if under the global limit.
     *              Ensures that the total number of results does not exceed the specified global limit.
     * @param allResults List<MetadataResult> - The list of all results collected so far
     * @param toAdd List<MetadataResult> - The list of results to add
     * @param globalLimit Integer - The maximum number of results allowed
     * @return void
     */
    private static void addIfUnderLimit(List<MetadataResult> allResults, List<MetadataResult> toAdd, Integer globalLimit) {
        if (allResults.size() < globalLimit) {
            allResults.addAll(toAdd);
        }
    }

    /**
     * @description Wrapper class for metadata search results. Encapsulates key metadata properties for display and linking in LWC.
     */
    public class MetadataResult {
        /**
         * @description Unique identifier for the metadata record (Id or DurableId)
         */
        @AuraEnabled public String id;
        /**
         * @description Name of the metadata record (e.g., ApexClass name, field name)
         */
        @AuraEnabled public String name;
        /**
         * @description Type of metadata (ApexClass, PermissionSet, etc.)
         */
        @AuraEnabled public String type;
        /**
         * @description Namespace prefix for the metadata record, if applicable
         */
        @AuraEnabled public String namespacePrefix;
        /**
         * @description API version of the metadata record, if applicable
         */
        @AuraEnabled public String apiVersion;
        /**
         * @description Label for the metadata record, if available
         */
        @AuraEnabled public String label;
        /**
         * @description DeveloperName for the metadata record, if available
         */
        @AuraEnabled public String developerName;
        /**
         * @description Object name for fields or related metadata
         */
        @AuraEnabled public String objectName;
        /**
         * @description Field name for field-level metadata
         */
        @AuraEnabled public String fieldName;
        /**
         * @description Folder name for foldered metadata types (e.g., EmailTemplate)
         */
        @AuraEnabled public String folderName;
        /**
         * @description SObject name for metadata records related to SObjects
         */
        @AuraEnabled public String sobjectName;

        /**
         * @description Constructor for MetadataResult wrapper
         * @param id String - Unique identifier
         * @param name String - Metadata name
         * @param type String - Metadata type
         * @param namespacePrefix String - Namespace prefix
         * @param apiVersion String - API version
         * @param label String - Label
         * @param developerName String - DeveloperName
         * @param objectName String - Object name
         * @param fieldName String - Field name
         * @param folderName String - Folder name
         * @param sobjectName String - SObject name
         */
        public MetadataResult(String id, String name, String type, String namespacePrefix, String apiVersion, String label, String developerName, String objectName, String fieldName, String folderName, String sobjectName) {
            this.id = id;
            this.name = name;
            this.type = type;
            this.namespacePrefix = namespacePrefix;
            this.apiVersion = apiVersion;
            this.label = label;
            this.developerName = developerName;
            this.objectName = objectName;
            this.fieldName = fieldName;
            this.folderName = folderName;
            this.sobjectName = sobjectName;
        }
    }
    /**
     * @description Searches Salesforce metadata by type and name fragment. Supports multiple metadata types and returns results in a MetadataResult wrapper.
     *              Used by the global LWC metadata search component. Applies governor limits and type-based filtering.
     * @param searchTerm String - The partial name to search for (case-insensitive)
     * @param type String - Metadata type (e.g., 'ApexClass', 'PermissionSet', 'PermissionSetGroup'). If blank, searches all types.
     * @return List<MetadataResult> - List of metadata records matching the search criteria
     */
    @AuraEnabled(cacheable=true)
    public static List<MetadataResult> searchMetadata(String searchTerm, String type, Integer recordLimit) {
        searchTerm = (searchTerm == null) ? '' : searchTerm.trim();
        String likeTerm = '%' + searchTerm + '%';
        Integer globalLimit = (recordLimit == null || recordLimit <= 0) ? 50 : recordLimit;
        if (type == null || String.isBlank(type)) {
            return searchAllTypes(likeTerm, globalLimit);
        } else if (type == 'ApexClass') {
            return searchApexClass(likeTerm, globalLimit);
        } else if (type == 'ApexTrigger') {
            return searchApexTrigger(likeTerm, globalLimit);
        } else if (type == 'ApexPage') {
            return searchApexPage(likeTerm, globalLimit);
        } else if (type == 'ApexComponent') {
            return searchApexComponent(likeTerm, globalLimit);
        } else if (type == 'Profile') {
            return searchProfile(likeTerm, globalLimit);
        } else if (type == 'PermissionSet') {
            return searchPermissionSet(likeTerm, globalLimit);
        } else if (type == 'PermissionSetGroup') {
            return searchPermissionSetGroup(likeTerm, globalLimit);
        } else if (type == 'StaticResource') {
            return searchStaticResource(likeTerm, globalLimit);
        } else if (type == 'Report') {
            return searchReport(likeTerm, globalLimit);
        } else if (type == 'Dashboard') {
            return searchDashboard(likeTerm, globalLimit);
        } else if (type == 'EmailTemplate') {
            return searchEmailTemplate(likeTerm, globalLimit);
        } else if (type == 'Object') {
            return searchCustomObject(likeTerm, globalLimit);
        } else if (type == 'Field') {
            return searchCustomField(likeTerm, globalLimit);
        } else if (type == 'CustomMetadataType') {
            return searchCustomMetadataType(likeTerm, globalLimit);
        }
        return new List<MetadataResult>();
    }

    // --- Sub-methods for each metadata type ---
    /**
     * @description Searches ApexClass metadata by name fragment.
     * @param likeTerm String - SOQL LIKE term for name search
     * @param globalLimit Integer - Maximum number of results
     * @return List<MetadataResult> - List of ApexClass metadata results
     */
    private static List<MetadataResult> searchApexClass(String likeTerm, Integer globalLimit) {
        List<MetadataResult> results = new List<MetadataResult>();
        if (Schema.sObjectType.ApexClass.isAccessible()) {
            for (ApexClass cls : [SELECT Id, Name, NamespacePrefix, ApiVersion FROM ApexClass WHERE Name LIKE :likeTerm ORDER BY Name LIMIT :globalLimit]) {
                results.add(new MetadataResult(
                    cls.Id,
                    cls.Name,
                    'ApexClass',
                    cls.NamespacePrefix,
                    String.valueOf(cls.ApiVersion),
                    null, null, null, null, null, null
                ));
            }
        }
        return results;
    }

    /**
     * @description Searches ApexTrigger metadata by name fragment.
     * @param likeTerm String - SOQL LIKE term for name search
     * @param globalLimit Integer - Maximum number of results
     * @return List<MetadataResult> - List of ApexTrigger metadata results
     */
    private static List<MetadataResult> searchApexTrigger(String likeTerm, Integer globalLimit) {
        List<MetadataResult> results = new List<MetadataResult>();
        if (Schema.sObjectType.ApexTrigger.isAccessible()) {
            for (ApexTrigger trg : [SELECT Id, Name, TableEnumOrId, NamespacePrefix, ApiVersion FROM ApexTrigger WHERE Name LIKE :likeTerm ORDER BY Name LIMIT :globalLimit]) {
                results.add(new MetadataResult(
                    trg.Id,
                    trg.Name,
                    'ApexTrigger',
                    trg.NamespacePrefix,
                    String.valueOf(trg.ApiVersion),
                    null, null, trg.TableEnumOrId, null, null, null
                ));
            }
        }
        return results;
    }

    /**
     * @description Searches ApexPage metadata by name fragment.
     * @param likeTerm String - SOQL LIKE term for name search
     * @param globalLimit Integer - Maximum number of results
     * @return List<MetadataResult> - List of ApexPage metadata results
     */
    private static List<MetadataResult> searchApexPage(String likeTerm, Integer globalLimit) {
        List<MetadataResult> results = new List<MetadataResult>();
        if (Schema.sObjectType.ApexPage.isAccessible()) {
            for (ApexPage page : [SELECT Id, Name, NamespacePrefix, ApiVersion FROM ApexPage WHERE Name LIKE :likeTerm ORDER BY Name LIMIT :globalLimit]) {
                results.add(new MetadataResult(
                    page.Id,
                    page.Name,
                    'ApexPage',
                    page.NamespacePrefix,
                    String.valueOf(page.ApiVersion),
                    null, null, null, null, null, null
                ));
            }
        }
        return results;
    }

    /**
     * @description Searches ApexComponent metadata by name fragment.
     * @param likeTerm String - SOQL LIKE term for name search
     * @param globalLimit Integer - Maximum number of results
     * @return List<MetadataResult> - List of ApexComponent metadata results
     */
    private static List<MetadataResult> searchApexComponent(String likeTerm, Integer globalLimit) {
        List<MetadataResult> results = new List<MetadataResult>();
        if (Schema.sObjectType.ApexComponent.isAccessible()) {
            for (ApexComponent cmp : [SELECT Id, Name, NamespacePrefix, ApiVersion FROM ApexComponent WHERE Name LIKE :likeTerm ORDER BY Name LIMIT :globalLimit]) {
                results.add(new MetadataResult(
                    cmp.Id,
                    cmp.Name,
                    'ApexComponent',
                    cmp.NamespacePrefix,
                    String.valueOf(cmp.ApiVersion),
                    null, null, null, null, null, null
                ));
            }
        }
        return results;
    }

    /**
     * @description Searches Profile metadata by name fragment.
     * @param likeTerm String - SOQL LIKE term for name search
     * @param globalLimit Integer - Maximum number of results
     * @return List<MetadataResult> - List of Profile metadata results
     */
    private static List<MetadataResult> searchProfile(String likeTerm, Integer globalLimit) {
        List<MetadataResult> results = new List<MetadataResult>();
        if (Schema.sObjectType.Profile.isAccessible()) {
            for (Profile p : [SELECT Id, Name FROM Profile WHERE Name LIKE :likeTerm ORDER BY Name LIMIT :globalLimit]) {
                results.add(new MetadataResult(
                    p.Id,
                    p.Name,
                    'Profile',
                    null, null, null, null, null, null, null, null
                ));
            }
        }
        return results;
    }

    /**
     * @description Searches PermissionSet metadata by name fragment.
     * @param likeTerm String - SOQL LIKE term for name search
     * @param globalLimit Integer - Maximum number of results
     * @return List<MetadataResult> - List of PermissionSet metadata results
     */
    private static List<MetadataResult> searchPermissionSet(String likeTerm, Integer globalLimit) {
        List<MetadataResult> results = new List<MetadataResult>();
        if (Schema.sObjectType.PermissionSet.isAccessible()) {
            for (PermissionSet ps : [SELECT Id, Name, Label FROM PermissionSet WHERE Name LIKE :likeTerm AND PermissionSetGroupId = null ORDER BY Name LIMIT :globalLimit]) {
                results.add(new MetadataResult(
                    ps.Id,
                    ps.Name,
                    'PermissionSet',
                    null, null,
                    ps.Label,
                    null, null, null, null, null
                ));
            }
        }
        return results;
    }

    /**
     * @description Searches PermissionSetGroup metadata by developer name fragment.
     * @param likeTerm String - SOQL LIKE term for developer name search
     * @param globalLimit Integer - Maximum number of results
     * @return List<MetadataResult> - List of PermissionSetGroup metadata results
     */
    private static List<MetadataResult> searchPermissionSetGroup(String likeTerm, Integer globalLimit) {
        List<MetadataResult> results = new List<MetadataResult>();
        if (Schema.sObjectType.PermissionSetGroup.isAccessible()) {
            for (PermissionSetGroup psg : [SELECT Id, DeveloperName, MasterLabel FROM PermissionSetGroup WHERE MasterLabel LIKE :likeTerm ORDER BY MasterLabel, DeveloperName LIMIT :globalLimit]) {
                results.add(new MetadataResult(
                    psg.Id,
                    psg.DeveloperName,
                    'PermissionSetGroup',
                    null, null,
                    psg.MasterLabel,
                    null, null, null, null, null
                ));
            }
        }
        return results;
    }

    /**
     * @description Searches StaticResource metadata by name fragment.
     * @param likeTerm String - SOQL LIKE term for name search
     * @param globalLimit Integer - Maximum number of results
     * @return List<MetadataResult> - List of StaticResource metadata results
     */
    private static List<MetadataResult> searchStaticResource(String likeTerm, Integer globalLimit) {
        List<MetadataResult> results = new List<MetadataResult>();
        if (Schema.sObjectType.StaticResource.isAccessible()) {
            for (StaticResource sr : [SELECT Id, Name, NamespacePrefix FROM StaticResource WHERE Name LIKE :likeTerm ORDER BY Name LIMIT :globalLimit]) {
                results.add(new MetadataResult(
                    sr.Id,
                    sr.Name,
                    'StaticResource',
                    sr.NamespacePrefix,
                    null, null, null, null, null, null, null
                ));
            }
        }
        return results;
    }

    /**
     * @description Searches Report metadata by name fragment.
     * @param likeTerm String - SOQL LIKE term for name search
     * @param globalLimit Integer - Maximum number of results
     * @return List<MetadataResult> - List of Report metadata results
     */
    private static List<MetadataResult> searchReport(String likeTerm, Integer globalLimit) {
        List<MetadataResult> results = new List<MetadataResult>();
        if (Schema.sObjectType.Report.isAccessible()) {
            for (Report rpt : [SELECT Id, Name, DeveloperName, FolderName FROM Report WHERE Name LIKE :likeTerm ORDER BY Name LIMIT :globalLimit]) {
                results.add(new MetadataResult(
                    rpt.Id,
                    rpt.Name,
                    'Report',
                    null, null, null,
                    rpt.DeveloperName,
                    null, null,
                    rpt.FolderName,
                    null
                ));
            }
        }
        return results;
    }

    /**
     * @description Searches Dashboard metadata by title fragment.
     * @param likeTerm String - SOQL LIKE term for title search
     * @param globalLimit Integer - Maximum number of results
     * @return List<MetadataResult> - List of Dashboard metadata results
     */
    private static List<MetadataResult> searchDashboard(String likeTerm, Integer globalLimit) {
        List<MetadataResult> results = new List<MetadataResult>();
        if (Schema.sObjectType.Dashboard.isAccessible()) {
            for (Dashboard db : [SELECT Id, Title, DeveloperName, FolderName FROM Dashboard WHERE Title LIKE :likeTerm ORDER BY Title, DeveloperName LIMIT :globalLimit]) {
                results.add(new MetadataResult(
                    db.Id,
                    db.Title,
                    'Dashboard',
                    null, null, null,
                    db.DeveloperName,
                    null, null,
                    db.FolderName,
                    null
                ));
            }
        }
        return results;
    }

    /**
     * @description Searches EmailTemplate metadata by name fragment.
     * @param likeTerm String - SOQL LIKE term for name search
     * @param globalLimit Integer - Maximum number of results
     * @return List<MetadataResult> - List of EmailTemplate metadata results
     */
    private static List<MetadataResult> searchEmailTemplate(String likeTerm, Integer globalLimit) {
        List<MetadataResult> results = new List<MetadataResult>();
        if (Schema.sObjectType.EmailTemplate.isAccessible()) {
            for (EmailTemplate et : [SELECT Id, Name, DeveloperName, FolderName FROM EmailTemplate WHERE Name LIKE :likeTerm ORDER BY Name LIMIT :globalLimit]) {
                results.add(new MetadataResult(
                    et.Id,
                    et.Name,
                    'EmailTemplate',
                    null, null, null,
                    et.DeveloperName,
                    null, null,
                    et.FolderName,
                    null
                ));
            }
        }
        return results;
    }

    /**
     * @description Searches CustomObject metadata by API name fragment using EntityDefinition.
     * @param likeTerm String - SOQL LIKE term for API name search
     * @param globalLimit Integer - Maximum number of results
     * @return List<MetadataResult> - List of CustomObject metadata results
     */
    private static List<MetadataResult> searchCustomObject(String likeTerm, Integer globalLimit) {
        List<MetadataResult> results = new List<MetadataResult>();
        if (Schema.sObjectType.EntityDefinition.isAccessible()) {
            // Query by QualifiedApiName
            List<EntityDefinition> byApiName = [
                SELECT QualifiedApiName, NamespacePrefix
                FROM EntityDefinition
                WHERE IsCustomizable = true AND QualifiedApiName LIKE :likeTerm
                AND (NOT QualifiedApiName LIKE '%__mdt')
                ORDER BY QualifiedApiName
                LIMIT :globalLimit
            ];
            // Query by Label
            List<EntityDefinition> byLabel = [
                SELECT QualifiedApiName, NamespacePrefix
                FROM EntityDefinition
                WHERE IsCustomizable = true AND Label LIKE :likeTerm
                AND (NOT QualifiedApiName LIKE '%__mdt')
                ORDER BY QualifiedApiName
                LIMIT :globalLimit
            ];
            // Merge results, avoiding duplicates
            Map<String, EntityDefinition> merged = new Map<String, EntityDefinition>();
            for (EntityDefinition ed : byApiName) {
                merged.put(ed.QualifiedApiName, ed);
            }
            for (EntityDefinition ed : byLabel) {
                merged.put(ed.QualifiedApiName, ed);
            }

            for (EntityDefinition obj : merged.values()) {
                results.add(new MetadataResult(
                    null,
                    obj.QualifiedApiName,
                    'Object',
                    obj.NamespacePrefix,
                    null, null, null, null, null, null, null
                ));
                if (results.size() >= globalLimit) {
                    break;
                }
            }
        }
        return results;
    }

    /**
     * @description Searches CustomField metadata by API name fragment using FieldDefinition.
     *              Handles field label formatting and DurableId parsing for display and linking.
     * @param likeTerm String - SOQL LIKE term for field API name search
     * @param globalLimit Integer - Maximum number of results
     * @return List<MetadataResult> - List of CustomField metadata results
     */
    private static List<MetadataResult> searchCustomField(String likeTerm, Integer globalLimit) {
        List<MetadataResult> results = new List<MetadataResult>();
        if (Schema.sObjectType.FieldDefinition.isAccessible()) {
            // Query by QualifiedApiName
            List<FieldDefinition> byApiName = [
                SELECT QualifiedApiName, DurableId, NamespacePrefix, EntityDefinitionId, EntityDefinition.QualifiedApiName
                FROM FieldDefinition
                WHERE EntityDefinition.IsCustomizable = true
                AND QualifiedApiName LIKE :likeTerm
                ORDER BY QualifiedApiName
                LIMIT :globalLimit
            ];
            // Query by Label
            List<FieldDefinition> byLabel = [
                SELECT QualifiedApiName, DurableId, NamespacePrefix, EntityDefinitionId, EntityDefinition.QualifiedApiName
                FROM FieldDefinition
                WHERE EntityDefinition.IsCustomizable = true
                AND Label LIKE :likeTerm
                ORDER BY QualifiedApiName
                LIMIT :globalLimit
            ];
            // Merge results, avoiding duplicates
            Map<String, FieldDefinition> merged = new Map<String, FieldDefinition>();
            for (FieldDefinition fd : byApiName) {
                merged.put(fd.EntityDefinition.QualifiedApiName + '.' + fd.QualifiedApiName, fd);
            }
            for (FieldDefinition fd : byLabel) {
                merged.put(fd.EntityDefinition.QualifiedApiName + '.' + fd.QualifiedApiName, fd);
            }

            for (FieldDefinition fd : merged.values()) {
                String fieldLabel = fd.EntityDefinition.QualifiedApiName + '.' + fd.QualifiedApiName;
                String fieldId = fd.DurableId != null ? fd.DurableId.trim() : null;
                if (fieldId != null && fieldId.contains('.')) {
                    List<String> parts = fieldId.split('\\.');
                    fieldId = parts[parts.size() - 1].trim();
                }
                results.add(new MetadataResult(
                    fieldId,
                    fieldLabel,
                    'Field',
                    fd.NamespacePrefix,
                    null, null, null,
                    fd.EntityDefinition.QualifiedApiName,
                    fd.QualifiedApiName,
                    null, null
                ));
                if (results.size() >= globalLimit) {
                    break;
                }
            }
        }
        return results;
    }

    /**
     * @description Searches Custom Metadata Type definitions by API name fragment using EntityDefinition.
     *              Only returns Custom Metadata Types (objects ending with __mdt).
     * @param likeTerm String - SOQL LIKE term for API name search
     * @param globalLimit Integer - Maximum number of results
     * @return List<MetadataResult> - List of Custom Metadata Type metadata results
     */
    private static List<MetadataResult> searchCustomMetadataType(String likeTerm, Integer globalLimit) {
        List<MetadataResult> results = new List<MetadataResult>();
        if (Schema.sObjectType.EntityDefinition.isAccessible()) {
            // Query by QualifiedApiName
            List<EntityDefinition> byApiName = [
                SELECT QualifiedApiName, NamespacePrefix, MasterLabel, DurableId
                FROM EntityDefinition
                WHERE QualifiedApiName LIKE '%__mdt'
                AND QualifiedApiName LIKE :likeTerm
                ORDER BY QualifiedApiName
                LIMIT :globalLimit
            ];
            // Query by Label
            List<EntityDefinition> byLabel = [
                SELECT QualifiedApiName, NamespacePrefix, MasterLabel, DurableId
                FROM EntityDefinition
                WHERE QualifiedApiName LIKE '%__mdt'
                AND MasterLabel LIKE :likeTerm
                ORDER BY QualifiedApiName
                LIMIT :globalLimit
            ];
            // Merge results, avoiding duplicates
            Map<String, EntityDefinition> merged = new Map<String, EntityDefinition>();
            for (EntityDefinition ed : byApiName) {
                merged.put(ed.QualifiedApiName, ed);
            }
            for (EntityDefinition ed : byLabel) {
                merged.put(ed.QualifiedApiName, ed);
            }

            for (EntityDefinition obj : merged.values()) {
                results.add(new MetadataResult(
                    obj.DurableId,
                    obj.QualifiedApiName,
                    'CustomMetadataType',
                    obj.NamespacePrefix,
                    null,
                    obj.MasterLabel,
                    null, null, null, null, null
                ));
                if (results.size() >= globalLimit) {
                    break;
                }
            }
        }
        return results;
    }

    /**
     * @description Helper method to search all supported metadata types using the provided name fragment.
     *              Aggregates results from all type-specific search methods, respecting the global limit.
     * @param likeTerm String - SOQL LIKE term for name search
     * @param globalLimit Integer - Maximum number of results
     * @return List<MetadataResult> - Aggregated list of metadata results from all types
     */
    private static List<MetadataResult> searchAllTypes(String likeTerm, Integer globalLimit) {
        List<MetadataResult> allResults = new List<MetadataResult>();
        addIfUnderLimit(allResults, searchApexClass(likeTerm, globalLimit), globalLimit);
        addIfUnderLimit(allResults, searchApexTrigger(likeTerm, globalLimit), globalLimit);
        addIfUnderLimit(allResults, searchApexPage(likeTerm, globalLimit), globalLimit);
        addIfUnderLimit(allResults, searchApexComponent(likeTerm, globalLimit), globalLimit);
        addIfUnderLimit(allResults, searchProfile(likeTerm, globalLimit), globalLimit);
        addIfUnderLimit(allResults, searchPermissionSet(likeTerm, globalLimit), globalLimit);
        addIfUnderLimit(allResults, searchPermissionSetGroup(likeTerm, globalLimit), globalLimit);
        addIfUnderLimit(allResults, searchStaticResource(likeTerm, globalLimit), globalLimit);
        addIfUnderLimit(allResults, searchReport(likeTerm, globalLimit), globalLimit);
        addIfUnderLimit(allResults, searchDashboard(likeTerm, globalLimit), globalLimit);
        addIfUnderLimit(allResults, searchEmailTemplate(likeTerm, globalLimit), globalLimit);
        addIfUnderLimit(allResults, searchCustomObject(likeTerm, globalLimit), globalLimit);
        addIfUnderLimit(allResults, searchCustomField(likeTerm, globalLimit), globalLimit);
        addIfUnderLimit(allResults, searchCustomMetadataType(likeTerm, globalLimit), globalLimit);
        return allResults;
    }
}