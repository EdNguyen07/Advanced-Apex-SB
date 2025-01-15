public class Constants {
	public static final Integer DEFAULT_ROWS = 5;
    public static final String SELECT_ONE = Label.Select_One;
    public static final String INVENTORY_LEVEL_LOW = Label.Inventory_Level_Low;
    public static final List<Schema.PicklistEntry> PRODUCT_FAMILY = Product2.Family.getDescribe().getPicklistValues();
    public static final String DRAFT_ORDER_STATUS = 'Draft';
    public static final String ACTIVATED_ORDER_STATUS = 'Activated';
    
    public static final String INVENTORY_ANNOUNCEMENTS = 'Inventory Announcements';
    public static final String ERROR_MESSAGE = 'An error has occurred, please take a screenshot with the URL and send it to IT.';
    public static final String STANDARD_PRICEBOOK_ID = '01saj000005YTMUAA4';
	//Delete 01saj000005YTMUAA4 from the STANDARD_PRICEBOOK_ID after pasting
	//Then on the query editor tab paste: SELECT Id FROM PriceBook2 WHERE Name = 'standard Price Book'
	//Execute query, copy the generated Id and paste in the TANDARD_PRICEBOOK_ID
}
