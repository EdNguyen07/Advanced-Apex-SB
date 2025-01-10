public class Product2Extension {
    
    public List<ProductWrapper> productsToInsert {get;set;}
    
    public Product2Extension(ApexPages.StandardController controller){
        productsToInsert = new List<ProductWrapper>();
        addRows();
    }
    
    public void AddRows(){
        for ( Integer i=0; i<Constants.DEFAULT_ROWS; i++ ){
            productsToInsert.add( new ProductWrapper() );
        }
    }
    
    public List<ChartHelper.ChartData> GetInventory(){
        return ChartHelper.GetInventory();
    }
    
    public List<SelectOption> GetFamilyOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(Constants.SELECT_ONE, Constants.SELECT_ONE));
        for(PickListEntry eachPicklistValue : Constants.PRODUCT_FAMILY) {
            options.add(new SelectOption(eachPicklistValue.getValue(), eachPicklistValue.getLabel()));
        }
        return options;
    }
    
    public PageReference Save(){
        SavePoint sp = Database.setSavepoint();
        Integer insertedCount = 0;
        try {
            List<Product2> newProducts = new List<Product2>();
            List<PriceBookEntry> pbeList = new List<PriceBookEntry>();
            List<ProductWrapper> filteredProductWrappers = new List<ProductWrapper>();
            for(ProductWrapper eachPW : productsToInsert) {
                 filteredProductWrappers.add(eachPW);
            }
            for(ProductWrapper eachPW : filteredProductWrappers) {
                newProducts.add(eachPW.productRecord);
            }
            Database.SaveResult[] productSaveResults = Database.insert(newProducts, false);
            
            for(Integer i = 0; i < productSaveResults.size(); i++) {
                if(productSaveResults[i].isSuccess()) {
                    PriceBookEntry pbe = filteredProductWrappers[i].pricebookEntryRecord;
                    pbe.Product2Id = productSaveResults[i].getId();
                    pbe.IsActive = true;
                    pbe.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
                    pbeList.add(pbe);
                    insertedCount++;
                }
            }
            Database.SaveResult[] pbeSaveResults = Database.insert(pbeList, false);
            //If successful clear the list and display an informational message
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,productsToInsert.size()+' Inserted'));
            productsToInsert.clear();   //Do not remove
            addRows();  //Do not remove
        } catch (Exception e){
            System.debug('Exception occured:'+e.getMessage());
            Database.rollback(sp);
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, Constants.ERROR_MESSAGE));
        }
        return null;
    }
    
    public class ProductWrapper{
        public Product2 productRecord {get; set;}
        public PriceBookEntry pricebookEntryRecord {get; set;}
        public ProductWrapper() {
            productRecord = new product2(Initial_Inventory__c =0);
            pricebookEntryRecord = new pricebookEntry(Unitprice=0.0);
        }
    }
    
}
