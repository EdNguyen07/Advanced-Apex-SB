/**
 * @name OrderExtension
 * @description This class is provided for you to facilitate the Super Badge
**/
public class OrderExtension {

    public Order orderRecord {get;set;}
    public List<OrderItem> orderItemList {get;set;}
    public String selectedFamily {get;set;}
    public List<chartHelper.chartData> pieData {get;set;}
    public Decimal total {get;set;}

    public Map<Id,OrderItem> orderItemMap;
    ApexPages.StandardSetController standardSetController;

    public OrderExtension(ApexPages.StandardController standardController){
        orderRecord = (Order)standardController.getRecord();
        orderItemMap = new Map<id,OrderItem>();
        if ( orderRecord.Id != null ){
            orderRecord = queryOrderRecord(orderRecord.Id);
        }
        refreshStandardSetController();
        total = 0;

        for(orderItem ot : orderRecord.OrderItems){
            orderItemMap.put(ot.Product2Id, ot);
            if(ot.Quantity > 0){
                if(pieData == null){
                    pieData = new List<ChartHelper.ChartData>();
                }
                pieData.add(new ChartHelper.ChartData(ot.Product2.Name, ot.Quantity * ot.UnitPrice));
                total += ot.Quantity * ot.UnitPrice;
            }
        }
        loadData();
    }

    void refreshStandardSetController(){
        String query = 'SELECT Name, Product2.Family, Product2.Name, Product2Id, UnitPrice, Product2.Quantity_Remaining__c FROM PricebookEntry WHERE IsActive = TRUE';

        if(selectedFamily != null && selectedFamily != Constants.SELECT_ONE){
            query += ' AND Product2.Family = \'' + selectedFamily + '\'';
        }
        query += ' ORDER BY Name';
        standardSetController = new Apexpages.StandardSetController(Database.getQueryLocator(query));
        standardSetController.setPageSize(Constants.DEFAULT_ROWS);
    }

    //ToDo: Implement your own method to populate orderItemList
    //  that you will call after pagination and/or family selection
    void loadData(){
        orderItemList = new List<orderItem>();
        for(SObject obj : standardSetController.getRecords()){
            PricebookEntry pbe = (PricebookEntry)obj;

            if(orderItemMap.containsKey(pbe.Product2Id)){
                orderItemList.add(orderItemMap.get(pbe.Product2Id));
            }else{
                OrderItem oi = new OrderItem(
                    PricebookEntryId = pbe.Id,
                    Product2Id = pbe.Product2Id,
                    UnitPrice = pbe.UnitPrice,
                    Quantity = 0,
                    Product2 = pbe.Product2
                );
                orderItemList.add(oi);
                orderItemMap.put(pbe.Product2Id, oi);
            }
        }     
    }


    /**
     * @name OnFieldChange
     * @description
    **/
    public void OnFieldChange(){
        //ToDo: Implement logic to store the values changed on the page
        //      and populate pieData
        //      and populate total
        for(orderItem oi : orderItemList){
            orderItemMap.put(oi.Product2Id, oi);
        }

        pieData = null;
        total = 0;
        for(orderItem oi : orderItemMap.values()){
            if(oi.Quantity > 0){
                if(pieData == null){
                    pieData = new List<ChartHelper.ChartData>();
                }
                pieData.add(new ChartHelper.ChartData(oi.Product2.Name, oi.Quantity * oi.UnitPrice));
                total += oi.Quantity * oi.UnitPrice;
            }
        }
    }

    /**
     * @name SelectFamily
     * @description
    **/
    public void SelectFamily(){
        //ToDo: Implement logic to filter based on the selected product family
        refreshStandardSetController();
        loadData();
    }

    /**
     * @name Save
     * @description
    **/
    public void Save(){
        //ToDo: Implement logic to save the Order and populated OrderItems
        System.Savepoint sp = Database.setSavepoint();

        try {
            if(orderRecord.Pricebook2Id == null){
                orderRecord.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
            }
            upsert orderRecord;

            List<orderItem> orderItemsToUpsert = new List<ORderItem>();
            List<orderItem> orderItemsToDelete = new List<ORderItem>();

            for(OrderItem oi : orderItemMap.values()){
                if(oi.Quantity > 0){
                    if(oi.OrderId == null){
                        oi.OrderId = orderRecord.Id;
                    }
                    orderItemsToUpsert.add(oi);
                }else if(oi.Id != null){
                    orderItemsToDelete.add(new OrderItem(id=oi.Id));
                    oi.Id = null;
                }
            }

            upsert orderItemsToUpsert;
            delete orderItemsToDelete;

        } catch (Exception e) {
            Database.rollback(sp);
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.INFO, Constants.ERROR_MESSAGE));
        }
    }

    /**
     * @name First
     * @description
    **/
    public void First(){
        standardSetController.first();
        loadData();
    }


    /**
     * @name Next
     * @description
    **/
    public void Next(){
        standardSetController.next();
        loadData();
    }


    /**
     * @name Previous
     * @description
    **/
    public void Previous(){
        standardSetController.previous();
        loadData();
    }

    /**
     * @name Last
     * @description
    **/
    public void Last(){
        standardSetController.last();
        loadData();
    }

    /**
     * @name GetHasPrevious
     * @description
    **/
    public Boolean GetHasPrevious(){
        return standardSetController.getHasPrevious();
    }

    /**
     * @name GetHasNext
     * @description
    **/
    public Boolean GetHasNext(){
        return standardSetController.getHasNext();
    }

    /**
     * @name GetTotalPages
     * @description
    **/
    public Integer GetTotalPages(){
        return (Integer)Math.ceil(standardSetController.getResultSize() / (Decimal)Constants.DEFAULT_ROWS);
    }

    /**
     * @name GetPageNumber
     * @description
    **/
    public Integer GetPageNumber(){
        return standardSetController.getPageNumber();
    }

    /**
     * @name GetFamilyOptions
     * @description
    **/
    public List<SelectOption> GetFamilyOptions(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(Constants.SELECT_ONE, Constants.SELECT_ONE));
        for(PicklistEntry indvPickValue : Constants.PRODUCT_FAMILY){
        options.add(new SelectOption(indvPickValue.getValue(), indvPIckValue.getLabel()));

        }
        return options;
    }

    /**
     * @name QueryOrderRecord
     * @description
    **/
    public static Order QueryOrderRecord(Id orderId){
        return [
            SELECT Id, AccountId, EffectiveDate, Name, Status, Pricebook2Id,
                (
                    SELECT Id, OrderId, Quantity, UnitPrice, PricebookEntryId, Product2Id,
                         Product2.Name, Product2.Family, Product2.Quantity_Remaining__c
                    FROM OrderItems
                )
            FROM Order
            WHERE Id = :orderId
        ];
    }

}
