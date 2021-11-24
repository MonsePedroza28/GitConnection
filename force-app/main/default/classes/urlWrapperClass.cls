/**
 * @author Arcode.
 * @description This class manages connections with GitHub.
 * <p /><p /> 
 */
global class urlWrapperClass {

    @AuraEnabled
	public String strClientId {get; set;}
	@AuraEnabled
	public String strScope {get; set;}
	@AuraEnabled
	public String strRedirectUri {get; set;}
	@AuraEnabled
	public String strState {get; set;}
	@AuraEnabled
	public String strAuthorizationUrl {get; set;}
	@AuraEnabled
	public String strClientSecret {get; set;}
	@AuraEnabled
	public String strAuthorization {get; set;}
	@AuraEnabled
	public String strApplication {get; set;}
	@AuraEnabled
	public String strRepositoryName {get; set;}
	@AuraEnabled
	public String strUserName {get; set;}
	@AuraEnabled
	public String strVersionController {get; set;}
	@AuraEnabled
	public String strEndpoint {get; set;}
	@AuraEnabled
	public String strEndpointLogin {get; set;}
}


