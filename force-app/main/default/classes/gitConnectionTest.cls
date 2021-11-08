/**
 * @author Arcode.
 * @description This class serves as a Test Class for gitConnection.
 * <p /><p /> 
 */
@isTest(seeAllData = false)
public with sharing class gitConnectionTest {
    
        /**
     * Testing history records.
     */
    @isTest
    public static void testUserId() {
        System.runAs(createTestUser('System Administrator', true)) {
        }
    }

        /**
     * This method serves as a Utility method to create Test users.
     *
     * @param strProfileName Profile to be assigned to user.
     * @param boolInsertUser Boolean to indicate if the User must be inserted or not.
     * @return Test user.
     */
    private static User createTestUser(String strProfileName, Boolean boolInsertUser) {
        Integer intRandomNumber = Integer.valueOf(DateTime.now().getTime());
        String strRandomValue = String.valueOf(DateTime.now().getTime());
        String strOrgId = UserInfo.getOrganizationId();
        String strUniqueName = strOrgId + intRandomNumber;
        User objTestUser = new User();
        Profile objProfile;

        //First we get the existing profile.
        objProfile = [SELECT Id FROM Profile WHERE Name = :strProfileName];

        //Now we set the user data.
        objTestUser.FirstName = 'TestData' + DateTime.now().getTime();
        objTestUser.LastName = 'TestData' + DateTime.now().getTime();
        objTestUser.Email = strUniqueName + 'TestData' + strOrgId + '@test.com';
        objTestUser.Username = objTestUser.Email;
        objTestUser.EmailEncodingKey = 'ISO-8859-1';
        objTestUser.Alias = strRandomValue.subString(strRandomValue.length() - 9, strRandomValue.length() - 1);
        objTestUser.TimeZoneSidKey = 'America/Los_Angeles';
        objTestUser.LocaleSidKey = 'en_US';
        objTestUser.LanguageLocaleKey = objTestUser.LocaleSidKey;
        objTestUser.ProfileId = objProfile.Id;
        
        //Now we insert the user, if required.
        if (boolInsertUser) {
            insert objTestUser;
        }
        return objTestUser;
    }
}