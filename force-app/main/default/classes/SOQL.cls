/**
* The SOQL class serves as a primer into the Salesforce Object Query Language in Apex.
* It covers fundamental aspects such as SELECT statements, WHERE clauses, Relationship queries, and LIMIT keyword.
*
* This class introduces developers to the concept of retrieving data from Salesforce using SOQL. It provides
* a step-by-step guide on how to construct SOQL queries, filter results using WHERE clause, retrieve related
* records, and manage data volume using the LIMIT keyword.
* 
* Topics covered in this class include:
* - Understanding the structure of a SOQL query.
* - Crafting basic SELECT statements in SOQL.
* - Applying filters using the WHERE clause in SOQL.
* - Fetching related records using Relationship queries.
* - Controlling the amount of data retrieved using the LIMIT keyword.
* 
* Users of this class can expect to gain a solid understanding of SOQL in Apex and
* be prepared to handle data retrieval tasks in Salesforce development.
* 
* @author Anthony Belano
*/

public with sharing class SOQL {
    
    /**
     * Question 1
     * Update/Uncomment the template code to create a method
     * Returns all leads from Salesforce Org
     * @return List of all leads with Id, LastName, Company, Phone, Email
     * Update the corresponding test class and testGetAllLeads method to cover this method
     */
    public static List<Lead> getAllLeads() {
    //  The body of the method
    if (!Schema.sObjectType.Lead.isAccessible()) {
        System.debug('You do not have access to this Object.  Please contact your Salesforce Administrator.');
    }

    return [SELECT Id, LastName, Company, Phone, Email FROM Lead];
    }

    /**
     * Question 2
     * Update/Uncomment the template code to create a method
     * Returns all contacts with first name of John.
     * @return A list of Contact records.
     * Update the corresponding test class and testGetContactsByFirstName method to cover this method
     */
    public static List<Contact> getContactsByFirstName() {
    //  The body of the method
    String firstNameFilter = 'John';

    if (!Schema.sObjectType.Contact.isAccessible()) {
        System.debug('You do not have access to this Object.  Please contact your Salesforce Administrator.');
    }

    return [SELECT Id, FirstName, LastName, Name FROM Contact WHERE FirstName = :firstNameFilter];
    }

    /**
     * Question 3
     * Update/Uncomment the template code to create a method
     * Returns the Contact Id for all contacts with last name of Smith or Jones
     * @return A list of Contact Ids.
     * Update the corresponding test class and testGetContactIdsByLastName method to cover this method
     */
    public static List<Id> getContactIdsByLastName() {
    //  The body of the method
    List<String> lastNameFilter = new List<String>{'Smith', 'Jones'};

    if (!Schema.sObjectType.Contact.isAccessible()) {
        System.debug('You do not have access to this Object.  Please contact your Salesforce Administrator.');
    }

    List<Contact> contactsFilteredByLastName = [SELECT Id FROM Contact WHERE LastName IN :lastNameFilter];
    List<Id> filteredContactIds = new List<Id>();
    for (Contact contactsToAddToList : contactsFilteredByLastName) {
        filteredContactIds.add(contactsToAddToList.Id);
    }

    return filteredContactIds;
    }

    /**
     * Question 4
     * Update/Uncomment the template code to create a method
     * Returns List of closed won opportunities for a specific Account.
     * Example: yourMethodName('001XXXXXXXXXXXX') should return the list of closed won opportunities for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A list of Opportunities with important opportunities fields
     * Update the corresponding test class and testGetClosedWonOpportunityCountByAccount method to cover this method
     */
    public static List<Opportunity> getOpportunitiesByAccount(String accountId) {
    //  The body of the method
    String stageNameFilter = 'Closed Won';

    if (!Schema.sObjectType.Opportunity.isAccessible()) {
        System.debug('You do not have access to this Object.  Please contact your Salesforce Administrator.');
    }

    return [SELECT Id, Name, StageName, CloseDate, AccountId, Amount 
            FROM Opportunity 
            WHERE StageName = :stageNameFilter
            AND AccountId = :accountId];
    }

    /**
     * Question 5
     * Update/Uncomment the template code to create a method
     * Returns the total count of Account records.
     * @return The Integer count of Account records.
     * Update the corresponding test class and testGetAccountCount method to cover this method
     */
    public static Integer getTotalCountOfAccounts() {
    //  The body of the method
    if (!Schema.sObjectType.Account.isAccessible()) {
        System.debug('You do not have access to this Object.  Please contact your Salesforce Administrator.');
    }

    AggregateResult[] groupedResults = [SELECT COUNT(Id) totalCount FROM Account];
    Integer accountTotalCount = (Integer)groupedResults[0].get('totalCount');
    return accountTotalCount;
    }

    /**
     * Question 6
     * Update/Uncomment the template code to create a method
     * Return Key Value pair of Task Id and Task records for any tasks due date within the next 7 days.
     * @return A map of Task Ids to Task records.
     * Update the corresponding test class and testGetTasksDueNextWeek method to cover this method
     */
    public static Map<Id, Task> getTasksDueNextWeek() {
    //  The body of the method
    if (!Schema.sObjectType.Task.isAccessible()) {
        System.debug('You do not have access to this Object.  Please contact your Salesforce Administrator.');
    }

    Map<Id, Task> tasksDueNextWeek = new Map<Id, Task>([SELECT Id, ActivityDate FROM Task WHERE ActivityDate = NEXT_N_DAYS:7]);
    return tasksDueNextWeek;

    }

    /**
     * Question 7
     * Update/Uncomment the template code to create a method
     * Retrieves all Contacts that have a example.com domain in their Email.
     * @return A list of Contact records.
     * Update the corresponding test class and testGetContactsByEmailDomain method to cover this method
     */
    public static List<Contact> getContactsByEmailDomain() {
    //  The body of the method
    if (!Schema.sObjectType.Contact.isAccessible()) {
        System.debug('You do not have access to this Object.  Please contact your Salesforce Administrator.');
    }

    return [SELECT FirstName, LastName, Name, Email FROM Contact WHERE Email LIKE '%example.com%'];
    }

    /**
     * Question 8
     * Retrieves all Opportunities that have a specific keyword in their Name.
     * Example: getOpportunitiesByNameKeyword('keyword') should return all Opportunities that have 'keyword' in their Name.
     * @param keyword The keyword to search for in the Opportunity Name.
     * @return A list of Opportunity records.
     */
    public static List<Opportunity> getOpportunitiesByNameKeyword(String keyword) {
        if (!Schema.sObjectType.Opportunity.isAccessible()) {
            System.debug('You do not have access to this Object.  Please contact your Salesforce Administrator.');
        }

        return [SELECT Id, Name, StageName, CloseDate, AccountId FROM Opportunity WHERE Name LIKE : '%' + keyword + '%']; // Replace null with the variable you used to store the result
    }

    /**
     * Question 9
     * Retrieves all Cases that Case Origin is not Web or Email or Blank
     * @return A list of Case records.
     */
    public static List<Case> getFilterCaseOrigins() {
        List<String> caseOriginFilter = new List<String>{'Web', 'Email', ''};

        if (!Schema.sObjectType.Case.isAccessible()) {
            System.debug('You do not have access to this Object.  Please contact your Salesforce Administrator.');
        }

        return [SELECT Id, Status, AccountId, Origin FROM Case WHERE Origin != :caseOriginFilter]; // Replace null with the variable you used to store the result
    }

    /**
     * Question 10
     * Update/Uncomment the template code to create a method
     * Retrieves all Leads that have a specific Lead Source or contain a specific keyword in their Title.
     * Example: yourMethodName('Web', 'Engineer') should return all Leads that have 'Web' in their Lead Source or 'Engineer' in their Title.
     * @param leadSource The Lead Source to search for.
     * @param keyword The keyword to search for in the Lead Title.
     * @return A list of Lead records.
     * Update the corresponding test class and testGetLeadsBySourceOrTitle method to cover this method
     */
    public static List<Lead> getLeadsBySourceOrTitle(String leadSource, String keyword) {
    //  The body of the method
    if (!Schema.sObjectType.Lead.isAccessible()) {
        System.debug('You do not have access to this Object.  Please contact your Salesforce Administrator.');
    }

    return [SELECT Id, LastName, Company, Phone, Email, LeadSource, Title FROM Lead WHERE LeadSource LIKE : '%' + leadSource + '%' OR Title LIKE : '%' + keyword + '%'];
    }    

    /**
     * Question 11
     * Returns the names of all Contacts associated with an Account.
     * Example: getContactNamesByAccount('001XXXXXXXXXXXX') should return the list of Contact LastNames for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A list of Contact LastName.
     */
    public static List<String> getContactNamesByAccount(Id accountId) {
        // Create a list to hold the Contact LastNames
        List<String> contactLastNames = new List<String>();
        // Query the Contacts
        List<Contact> contactsFilteredByAccountId = new List<Contact>([SELECT Id, LastName FROM Contact WHERE AccountId = :accountId]);

        // Loop through each Contact and add the LastName to the list
        for (Contact contactsToAddToList : contactsFilteredByAccountId) {
            contactLastNames.add(contactsToAddToList.LastName);
        }

        // Return the list of Contact LastNames
        return contactLastNames; // Replace null with the variable you used to store the result
    }

    /**
     * Question 12
     * Returns the total revenue for all Opportunities in a specific Stage or if the amount is greater than 10000.
     * Example: getTotalRevenueByStage('Closed Won') should return the total revenue for the found opportunities
     * @param stage The Stage value to filter Opportunities.
     * @return The total revenue.
     */
    public static Decimal getTotalRevenueByStage(String stage) {
        // Use AggregateQuery to get the total revenue
        AggregateResult[] groupedResults = [SELECT SUM(ExpectedRevenue) totalRevenue FROM Opportunity WHERE StageName = :stage];
        Decimal opportunityTotalRevenue = (Decimal)groupedResults[0].get('totalRevenue');

        // Return the total revenue
        return opportunityTotalRevenue; // Replace null with the variable you used to store the result
    }

    /**
     * Question 13
     * Retrieves the first 10 Accounts ordered by Name.
     * @return A list of the first 10 Accounts ordered by Name.
     */
    public static List<Account> getFirstTenAccounts() {
        return [SELECT Name FROM Account ORDER BY Name ASC LIMIT 10]; // Replace null with the variable you used to store the result
    }
    
    /**
     * Question 14
     * Retrieves the Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
     * @return A list of Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
     */
    public static List<Opportunity> getHighValueOpportunities() {
        return [SELECT Amount, CloseDate FROM Opportunity WHERE Amount > 100000 ORDER BY CloseDate LIMIT 5]; // Replace null with the variable you used to store the result
    }
    
    /**
     * Question 15
     * Retrieves the Contacts with the most recent Birthdate, ordered by Birthdate, and limited to 3 records.
     * @return A list of Contacts
     */
    public static List<Contact> getBirthdateContacts() {
        return [SELECT Birthdate FROM Contact ORDER BY Birthdate DESC NULLS LAST LIMIT 3]; // Replace null with the variable you used to store the result
    }
    
    /**
     * Question 16
     * Retrieves the Cases in the Open Status, ordered by CreatedDate, and limited to 10 records with an offset of 5.
     * @return A list of Cases
     */
    public static List<Case> getCasesWithStatus() {
        return [SELECT Id, CaseNumber, CreatedDate FROM Case WHERE Status = 'Open' ORDER BY CreatedDate ASC LIMIT 10 OFFSET 5]; // Replace null with the variable you used to store the result
    }

    /**
     * Question 17
     * Returns Set of Case Ids for a specific Account.
     * Example: getCaseIdsByAccount('001XXXXXXXXXXXX') should return the set of Case Ids for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A set of Case Ids.
     */
    public static Set<Id> getCaseIdsByAccount(Id accountId) {
        // Create a set to hold the Case Ids
        Set<Id> caseIds = new Set<Id>();

        // Query the Cases
        List<Case> casesFilteredByAccountId = new List<Case>([SELECT Id FROM Case WHERE AccountId = :accountId]);

        // Loop through each Case and add the Id to the set
        for (Case caseIdsToAddToSet : casesFilteredByAccountId) {
            caseIds.add(caseIdsToAddToSet.Id);
        }

        return caseIds; // Replace null with the variable you used to store the result
    }

    /**
     * Question 18
     * Return Map of Account Ids to Account Names Not in a specific Country.
     * Example: getAccountIdsToNamesNotInCountry('United States') should return the map of Account Ids to Account Names for Accounts that are not in the United States.
     * @param country The country to filter Accounts.
     * @return A map of Account Ids to Account Names.
     */
    public static Map<Id, String> getAccountIdsToNamesNotInCountry(String country) {
        // Create a map to hold the Account Ids to Account Names
        Map<Id, String> accountIdsToNames = new Map<Id, String>();

        // Query the Accounts
        List<Account> accountsFilteredByCountry = new List<Account>([SELECT Id, Name, BillingCountry FROM Account WHERE BillingCountry !=:country]);
        
        // Loop through each Account and add the Id and Name to the map
        for (Account accountsToAddToMap : accountsFilteredByCountry) {
            accountIdsToNames.put(accountsToAddToMap.Id, accountsToAddToMap.name);
        }

        return accountIdsToNames; // Replace null with the variable you used to store the result
    }

    /**
     * Question 19
     * Retrieves the Account Name for a given Contact.
     * Example: getAccountNameForContact('003XXXXXXXXXXXX') should return the Account Name for the Contact with the Id
     * @param contactId The Id of the Contact.
     * @return The Account Name of the Contact.
     */
    public static String getAccountNameForContact(String contactId) {
        Contact contactQuerywithAccount = [SELECT Id, Account.Name FROM Contact WHERE Id =: contactId];
        return contactQuerywithAccount.Account.Name; // Replace null with the variable you used to store the result
    }    

    /**
     * Question 20
     * Returns single Account that has related opportunities in the same query
     * Example: getAccountAndOpportunitiesFromAccountId('001XXXXXXXXXXXX') should return the Account Name for the Account with the Id and all related Opportunities
     * @param accountId The ID of the Account.
     * @return An Account record with related Opportunities.
     */
    public static Account getAccountAndOpportunitiesFromAccountId(Id accountId) {
        if (!Schema.sObjectType.Account.isAccessible() || !Schema.sObjectType.Opportunity.isAccessible()) {
            System.debug('You do not have access to the Account or Opportunity objects. Please contact your Salesforce Administrator.');
        }
        Account accountQueryWithOpportunity = [SELECT Id, Name, (SELECT Id, Name, StageName, Amount FROM Opportunities) FROM Account WHERE Id =: accountId LIMIT 1];
        return accountQueryWithOpportunity; // Replace null with the variable you used to store the result
    }

    /**
     * Question 21
     * Retrieves all contacts that have the Mailing State similar to the Account Billing State.
     * Example: getAccountsWithContactsByState('001XXXXXXXXXXXX') should return a list of Contacts that have the same Mailing State as the Account with the Id
     * @param Account Id
     * @return List of contacts with the same Mailing State as the Account Billing State
     */
    public static List<Contact> getAccountsWithContactsByState(Id accountId) {
        // Query the Account
        // Store the Account's BillingState
        Account accountToQuery = ([SELECT Id, BillingState FROM Account WHERE Id =:accountId]);
        // Query the Contacts
        if (accountToQuery.BillingState == null) {
            System.debug('The account does not have a BillingState');
        }
        List<Contact> contactsWithSameMailingStateAsAccountBillingState = [SELECT Id, Name, MailingState FROM Contact WHERE MailingState =:accountToQuery.BillingState];
        return contactsWithSameMailingStateAsAccountBillingState; // Replace null with the variable you used to store the result
    }

    /**
     * Question 22
     * Extracts email domains from the leads, then finds Accounts with matching website domains
     * If Lead Email = test@test.com return account with website = www.test.com
     * Example: findAccountsByLeadEmailDomains([set of lead ids]) should return a list of Accounts with matching email domains
     * @param leadIds set of Lead Ids.
     * @return A list of Accounts with matching email domains.
     */
    public static List<Account> findAccountsByLeadEmailDomains(Set<Id> leadIds) {
        // Query the Leads
        // Create a set of email domains from the Leads
        Set<String> emailDomainsFromLeads = new Set<String>();
        // Loop through each Lead
        // Get the email from the Lead
        for (Lead leadsToQuery : [SELECT Id, Email FROM Lead WHERE Id =:leadIds]) {
            // Check if the email is not null
            if (leadsToQuery.Email != null){
                String leadDomain = leadsToQuery.Email.split('@').get(1);
                // Add the email domain to the set
                emailDomainsFromLeads.add(leadDomain);
            }
        }
        // Query the Accounts
        List<Account> matchingAccounts = new List<Account>();
        for (Account accountsToQuery : [SELECT Id, Website FROM Account WHERE Website != null]) {
            String accountDomain = accountsToQuery.Website.split('www.').get(1);
            if (emailDomainsFromLeads.contains(accountDomain)) {
                matchingAccounts.add(accountsToQuery);
            }
        }
        return matchingAccounts; // Replace null with the variable you used to store the result
    }

    /**
     * Question 23
     * Clones and Inserts Opportunity Line Items from an original Opportunity to a list of cloned Opportunities.
     * Adds a randomized number between 1 to 3 to the quantity of each line item.
     * Example: cloneLineItems('001XXXXXXXXXXXX', [list of opportunity ids]) should clone the line items from the Opportunity with the Id to each Opportunity in the list
     * @param Original Opportunity Id
     * @param List of cloned Opportunity Ids
     */
    public static void cloneLineItems(Id origOppId, List<Id> cloneOppIds) {
        if (!Schema.sObjectType.Opportunity.isAccessible() || !Schema.sObjectType.Opportunity.isCreateable() || !Schema.sObjectType.OpportunityLineItem.isAccessible() || !Schema.sObjectType.OpportunityLineItem.isCreateable()) {
            System.debug('You do not have access to the Opportunity or Opportunity Line Item object. Please contact your Salesforce Administrator.');
        }
        // Query the original Opportunity Line Items
        List<OpportunityLineItem> origOppLineItems = [SELECT Id, Name, Quantity, UnitPrice, PricebookEntryId, OpportunityId FROM OpportunityLineItem WHERE OpportunityId =:origOppId];
        // Create a list to hold the new line items
        List<OpportunityLineItem> oppLineItemsToInsert = new List<OpportunityLineItem>();
        // Generate a random number between 1 and 3
        Integer randomNumber = (Integer)Math.random() * 3 + 1;
        // Loop through each cloned Opportunity Id
        for (Id cloneOppId : cloneOppIds) {
            // Loop through each original line item
            for (OpportunityLineItem oppLineItem : origOppLineItems) {
                OpportunityLineItem newOppLineItem = new OpportunityLineItem();
                // Clone the original line item and add the random number to the quantity
                newOppLineItem.OpportunityId = cloneOppId;
                newOppLineItem.Quantity = oppLineItem.Quantity + randomNumber;
                newOppLineItem.UnitPrice = oppLineItem.UnitPrice;
                newOppLineItem.PricebookEntryId = oppLineItem.PricebookEntryId;
                oppLineItemsToInsert.add(newOppLineItem);
        }
    }
        // Insert the new line items
        insert oppLineItemsToInsert;
    }
    
    /**
     * Question 24
     * Retrieves the Opportunity Name, Account Name, and Owner Name for Opportunities that have a Stage of 'Closed Won'.
     * Example: getOpportunityDetailsForClosedWon()
     * @return A list of filtered Opportunity
     */
    public static List<Opportunity> getOpportunityDetailsForClosedWon() {        
        return [SELECT Id, Name, StageName, Primary_Contact__c, AccountId, OwnerId FROM Opportunity WHERE StageName = 'Closed Won']; // Replace null with the variable you used to store the result
    }

    /**
     * Question 25
     * Sets the 'Primary_Contact__c' field for all Closed Won Opportunities to first Contact on the Account.
     * Example: setPrimaryContact() should set the 'Primary_Contact__c' field for every Opportunity in the org
     */
    public static void setPrimaryContact() {
        //Use the getOpportunityDetailsForClosedWon() method to get the Opportunities
        List<Opportunity> opportunities = SOQL.getOpportunityDetailsForClosedWon();
        // Create a set of Account Ids from the Opportunities
        Set<Id> oppAccountIds = new Set<Id>();
        for (Opportunity oppAccountIdsToAddToSet : opportunities) {
            oppAccountIds.add(oppAccountIdsToAddToSet.AccountId);
        }
        // Query the Contacts
        Map<Id, Contact> accountToContactMap = new Map<Id, Contact>();
        // Loop through each Contact and add the Account Id and Contact to the map
        for (Contact contactQuery : [SELECT AccountId, Id, FirstName, LastName FROM Contact WHERE AccountId =: oppAccountIds]) {
            accountToContactMap.put(contactQuery.AccountId, contactQuery);
        }
        // Loop through each Opportunity
            // Update the Opportunity primary contact from accountToContactMap
        List<Opportunity> opportunitesToUpdate = new List<Opportunity>();
        for (Opportunity opp : opportunities) {
            if (accountToContactMap.containsKey(opp.AccountId)) {
                opp.Primary_Contact__c = accountToContactMap.get(opp.AccountId).Id;
                opportunitesToUpdate.add(opp);
            }
        }

        // Update the Opportunities
        update opportunitesToUpdate;
    }
}