@isTest
private class OrderTests {
  
    @testSetup static void SetupTestData(){
        TestDataFactory.InsertTestData(1);
    }

    @isTest private static void OrderUpdate_UnitTest() {
        Test.startTest();
        
        Order o = [SELECT Id, Status FROM Order LIMIT 1];
        Product2 p = [SELECT Id, Family, Name, Quantity_Ordered__c, Quantity_Remaining__c FROM Product2 LIMIT 1];
        
        o.status = Constants.ACTIVATED_ORDER_STATUS;
        update o;
        
        Product2 p2 =  [SELECT Id, Family, Name, Quantity_Ordered__c, Quantity_Remaining__c FROM Product2 LIMIT 1];      
        
        TestDataFactory.VerifyQuantityOrdered(p, p2, Constants.DEFAULT_ROWS);
        
        Test.stopTest();
    }
    
    
    static testmethod void OrderExtension_UnitTest() {
        PageReference reference = Page.OrderEdit;
        Test.setCurrentPage(reference);
        Order CurOrder = [Select Id,Status from Order limit 1];
        ApexPages.StandardController controller = new Apexpages.StandardController(CurOrder);
        OrderExtension extension = new OrderExtension(controller);
        System.assertEquals(1, extension.orderItemList.size());
        extension.selectedFamily = 'Dessert';
        extension.SelectFamily();
        extension.OnFieldChange();
        extension.First();
        extension.Next();
        extension.Previous();
        extension.Last();
        extension.GetHasNext();
        extension.GetPageNumber();
        extension.GetHasPrevious();
        extension.GetTotalPages();
        extension.GetFamilyOptions();
        extension.Save();
        ChartHelper.GetInventory();
    } 
}
