global class scheduledBatchable implements Schedulable {
   global void execute(SchedulableContext sc) {
      EmailToInstructorBatch b = new EmailToInstructorBatch(); 
      database.executebatch(b);
   }
}