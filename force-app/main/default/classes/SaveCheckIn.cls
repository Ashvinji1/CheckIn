/*
Author: Ashvin Bhatt
class: SaveCheckIn
Description: This class holds methods to create check-in records and validate the OTP.
*/
public class SaveCheckIn {

    /*
        Method: createCheckInRecord
        Param: contactId of the parent contact
        Description: This method consumes contact Id as paramter and create check in record.
    */
    @AuraEnabled
    public static void createCheckInRecord(String contactId) {
        System.debug(contactId);
        Integer len = 6;
        String otp = string.valueof(Math.round(Math.random()*(900000)+100000)).substring(0, len);       
        Contact con=[Select Email from Contact where Id=:contactId LIMIT 1];
        Check_In__c ci= new Check_In__c();
        ci.OTP__c = otp;
        ci.Contact__c = contactId;
		ci.Email__c = con.Email;  
        try{
            insert ci;
        } catch (DMLException dmle) {
            system.debug('DML exception--> '+dmle);
            //Handle the exception here
        }
        catch (Exception e) {
            system.debug('General exception--> '+e);
            //Handle the exception here
        }
    }
    
    /*
        Method: createCheckInRecord
        Param:  enteredOTP is the OTP entered by the User.
                enteredPurpose is the purpose selected by the user.
        Description: This method checks the OTP validity with last created check-in record against the supplied Contact.
                It also stores the checkin time and purpose.
    */
    @AuraEnabled
    public static String validateOTP(String contactId, String enteredOTP,String enteredPurpose){
        Check_In__c ci = [SELECT Id,OTP__c,purpose__c,Check_in_Time__c,CreatedDate 
                            FROM Check_In__c 
                            WHERE Contact__c =: contactId 
                           LIMIT 1];
        /*  
            ORDER BY CreatedDate desc 
                            
            Check 120 second validity at server end.
                DateTime createdDate = ci.CreatedDate;
                DateTime systemDate = DateTime.now();
                Long createdTime = createdDate.getTime();
                Long systemTime = systemDate.getTime();
                System.debug('time difference'+(systemTime-createdTime));
        */
        System.debug('enteredOTP == >'+enteredOTP);
        System.debug('ci.OTP__c == >'+ci.OTP__c);
        DateTime systemDate = DateTime.now();
        
        if(enteredOTP!=ci.OTP__c ){
            return 'Error! invalid OTP';
        }
        else if(ci.purpose__c!=null||ci.Check_in_Time__c!=null){
            return 'Already Checked in';
        }
        else{
            ci.OTP__c = enteredOTP;
            ci.Purpose__c = enteredPurpose;
            ci.Check_in_Time__c=systemDate;
            update ci;
            //Database.update(ci);
            return 'true';
        }
        
    }
}