/**
 * @name orderTrigger
 * @description
**/
trigger orderTrigger on Order (after insert, after update) {
  if(Trigger.New != null){
        OrderHelper.AfterUpdate(Trigger.new, Trigger.old);
    }
}
