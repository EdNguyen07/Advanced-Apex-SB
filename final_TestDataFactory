/**
 * @name TestDataFactory
 * @description Contains methods to construct and/or validate commonly used records
**/
public with sharing class TestDataFactory {

    /**
     * @name ConstructCollaborationGroup
     * @description
    **/
    public static CollaborationGroup ConstructCollaborationGroup(){
        //ToDo: Ensure this method returns a single Chatter CollaborationGroup
        //    whose Name starts with 'TEST' followed by the INVENTORY_ANNOUNCEMENTS constant
        //    and configured so anyone can join, see and post updates.
        CollaborationGroup cllgroup = new CollaborationGroup();
        cllgroup.Name = 'TEST' + Constants.INVENTORY_ANNOUNCEMENTS;
        cllgroup.CanHaveGuests = false;
        cllgroup.IsAutoArchiveDisabled = false;
        cllgroup.CollaborationType = 'Public';
        cllgroup.IsArchived = false;
        
        return cllgroup;
    }

    /**
     * @name CreateProducts
     * @description Constructs a list of Product2 records for unit tests
    **/
    public static List<Product2> ConstructProducts(Integer cnt){
        //ToDo: Ensure this method returns a list, of size cnt, of uniquely named Product2 records
        //  with all the required fields populated
        //  and IsActive = true
        //  an Initial Inventory set to 10
        //  and iterating through the product family picklist values throughout the list.
        List<Schema.PickListEntry> familyValueList = Product2.Family.getDescribe().getPickListValues();
        Integer listSize = familyValueList.size();
        
        List<Product2> productList = new List<Product2>();
        for (Integer i = 0; i < cnt; i++) {
            Product2 p = new Product2();
            p.Name = 'Product ' + i;
            p.Family = familyValueList[Math.mod(i, listSize)].getValue();
            p.Initial_Inventory__c = 10;
            p.IsActive = true;
            productList.add(p);
        }
        return productList; 
      
    }

    /**
     * @name CreatePricebookEntries
     * @description Constructs a list of PricebookEntry records for unit tests
    **/
    public static list<PricebookEntry> ConstructPricebookEntries(List<Product2> prods){
        //ToDo: Ensure this method returns a corresponding list of PricebookEntries records
        //  related to the provided Products
        //  with all the required fields populated
        //  and IsActive = true
        //  and belonging to the standard Pricebook
        List<PricebookEntry> pbeslist = new List<PricebookEntry>();
        for (Product2 product: prods) {
            PricebookEntry pbe = new PricebookEntry();
            pbe.IsActive = true;
            pbe.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
            pbe.Product2Id = product.Id;
            pbe.UnitPrice = 1;
            pbeslist.add(pbe);
        }
        return pbeslist;
    }

    /**
     * @name CreateAccounts
     * @description Constructs a list of Account records for unit tests
    **/
    public static List<Account> ConstructAccounts(Integer cnt){
        //ToDo: Ensure this method returns a list of size cnt of uniquely named Account records
        //  with all of the required fields populated.
        List<Account> acctList = new List<Account>();
        for (Integer i = 0; i < cnt; i++) {
            Account acct = new Account();
            acct.Name = 'Account ' + i;
            acctList.add(acct);
        }
        return acctList;
    }

    /**
     * @name CreateContacts
     * @description Constructs a list of Contacxt records for unit tests
    **/
    public static List<Contact> ConstructContacts(Integer cnt, List<Account> accts){
        //ToDo: Ensure this method returns a list, of size cnt, of uniquely named Contact records
        //  related to the provided Accounts
        //  with all of the required fields populated.
        Integer listSize = accts.size();
        
        List<Contact> contactList = new List<Contact>();
        for (Integer i = 0; i < cnt; i++) {
            Contact c = new Contact();
            c.LastName = 'Contact ' + i;
            c.AccountId = accts[Math.mod(i, listSize)].Id;
            contactList.add(c);
        }
        
        return contactList;
    }
    /**
     * @name CreateOrders
     * @description Constructs a list of Order records for unit tests
    **/
    public static List<Order> ConstructOrders(Integer cnt, List<Account> accts){
        //ToDo: Ensure this method returns a list of size cnt of uniquely named Order records
        //  related to the provided Accounts
        //  with all of the required fields populated.
        Integer listSize = accts.size();
        List<Order> orders = new List<Order>();
        for (Integer i = 0; i < cnt; i++) {
            Order o = new Order();
            o.Name = 'Order ' + i;
            o.AccountId = accts[Math.mod(i, listSize)].Id;
            o.EffectiveDate = Date.today();
            o.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
            o.Status = 'Draft';
            orders.add(o);
        }
        
        return orders;
    }

    /**
     * @name CreateOrderItems
     * @description Constructs a list of OrderItem records for unit tests
    **/
    public static List<OrderItem> ConstructOrderItems(integer cnt, list<pricebookentry> pbes, list<order> ords){
        //ToDo: Ensure this method returns a list of size cnt of OrderItem records
        //  related to the provided Pricebook Entries
        //  and related to the provided Orders
        //  with all of the required fields populated.
        //  Hint: Use the DEFAULT_ROWS constant for Quantity as it will be used in the next challenge
        Integer pbeListSize = pbes.size();
        Integer orderListSize = ords.size();
        
        List<OrderItem> orderItemList = new List<OrderItem>();
        
        for (Integer i = 0; i < cnt; i++) {
            OrderItem oi = new OrderItem();
            oi.OrderId = ords[Math.mod(i, orderListSize)].Id;
            oi.PriceBookEntryId = pbes[Math.mod(i, pbeListSize)].Id;
            oi.Quantity = Constants.DEFAULT_ROWS;
            oi.UnitPrice = 1;
            orderItemList.add(oi);
        }
        
        return orderItemList;
    }

    /**
     * @name SetupTestData
     * @description Inserts accounts, contacts, Products, PricebookEntries, Orders, and OrderItems.
    **/
    public static void InsertTestData(Integer cnt){
        //ToDo: Ensure this method calls each of the construct methods
        //  and inserts the results for use as test data.
        insert constructCollaborationGroup();
        
        List<Product2> productList = constructProducts(cnt);
        insert productList;
        
        List<PricebookEntry> pbes = constructPricebookEntries(productList);
        insert pbes;
        
        List<Account> accts = constructAccounts(cnt);
        insert accts;
        insert constructContacts(cnt, accts);
        
        List<Order> ords = constructOrders(cnt, accts);
        insert ords;
        
        insert constructOrderItems(cnt, pbes, ords);  

    }

}
