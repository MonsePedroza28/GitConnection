/**
 * @author Arcode.
 * @description This class serves as a wrapper for Transactions feature.
 * <p /><p /> 
 */
global class gitHubConnectionWrapperClass {

	//Public variables.
	@AuraEnabled
	public Boolean boolHasException {get; set;}
	@AuraEnabled
	public Boolean boolExecuteInFuture {get; set;}
	@AuraEnabled
	public Integer intStatusCode {get; set;}
	@AuraEnabled
	public String strCorrelationId {get; set;}
	@AuraEnabled
	public String strLabel {get; set;}
	@AuraEnabled
	public String strBody {get; set;}
	@AuraEnabled
	public String strClientId {get; set;}
	@AuraEnabled
	public String strClientSecret {get; set;}
	@AuraEnabled
	public String strEndpoint {get; set;}
	@AuraEnabled
	public String strMethod {get; set;}
	@AuraEnabled
	public String strRedirectURI {get; set;}
	@AuraEnabled
	public Blob objBody {get; set;}
	@AuraEnabled
	public Exception objException {get; set;}
	@AuraEnabled
	public Map<String, String> mapHeaders {get; set;}
	@AuraEnabled
	public Map<String, String> mapPathVariables {get; set;}
}