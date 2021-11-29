/**
 * @author Arcode.
 * @description This class manages connections with GitHub.
 * <p /><p /> 
 */
global with sharing class gitHubConnectionController {
    
    public static String strClientId;
    public static String strAuthorizationUrl;
    public static String strScope;
    public static String strState;
    public static String strRedirectUri;
    public static String strCode;
    public static String strUrl;
    public static String strToken;
    
    /**
     * This method generates the authentication url.
     * @return get url for user authorization.
     */
    @AuraEnabled(cacheable = false)
    public static String getAuthentication() {
		String strEnvironmentId = UserInfo.getOrganizationId();
		String strEnvironmentId15Digits = strEnvironmentId.substring(0, 15);
        integrationApp__mdt objIntegrateApp = [SELECT ClientId__c, Scope__c, RedirectURI__c, State__c, AuthorizationURL__c FROM integrationApp__mdt];
        strRedirectUri = objIntegrateApp.RedirectURI__c;
        strState = objIntegrateApp.State__c;
        strAuthorizationUrl = objIntegrateApp.AuthorizationURL__c;
        strScope = objIntegrateApp.Scope__c;
        strClientId = objIntegrateApp.ClientId__c;
        strUrl = strAuthorizationUrl + '?scope=' + strScope + '&client_id=' + strClientId + '&redirect_uri=' + strRedirectUri + '&state=' + strState;
        return strUrl;
    }

    /**
     * This method generates and saves a token.
     */
    @AuraEnabled(cacheable = true)
    public static void getToken() {
        Boolean boolResult;
        String strResults;
        String strAccesToken = 'access_token=[a-zA-Z0-9_]{40}';
        strCode = ApexPages.currentPage().getParameters().get('code');
        Matcher objMatcher;
        //We prepare the Access Token.
        strResults = getHttpResponse(getHttpRequest('Token', 'POST', 'Content-Type', 'application/x-www-form-urlencoded', '', '', 'https://github.com/login/oauth/access_token', '',
         'ef4d84387f76e7af6d66', '064f883ee558e11b5c84ded4ec546fd0ceabcee1', strCode, 'https://arcode--monsedev--c.visualforce.com/apex/succesLoginPageGitHub', 'state'));

        //We obtain only alphanumeric part from Access Token.
        objMatcher = Pattern.compile(strAccesToken).matcher(strResults);
        boolResult = objMatcher.find();

        //If the Token exists, we save token.
        if(boolResult) {
            strResults = objMatcher.group(0).substring(13, 53);
    
            //We save Token in Token__c field.
            User objUser = [SELECT Id, Token__c FROM User WHERE Id = :UserInfo.getUserId()];
            objUser.Token__c = strResults;
            update objUser;
        }
    }

    /**
     * This method connects with GitHub and obtains repositories.
     * @return get the list of repositories.
     */
    @AuraEnabled(cacheable = false)
    public static List<Object> getRepositories() {
        User objUser = [SELECT Token__c FROM User WHERE Id = :UserInfo.getUserId()];
        String strResults;

        //We prepare user's repositories.
        strResults = getHttpResponse(getHttpRequest('Repository', 'GET', 'Authorization', '', '', 'MonsePedroza28', 'https://api.github.com/users/', '/repos', '', '', '', '', ''));

        //We obtain user's repositories.
        List<Object> lstRepositories = (List<Object>)JSON.deserializeUntyped(strResults);
        return lstRepositories;
    }   

    /**
     * This method obtains the branches from the GitHub user.
     * @return get the list of branches.
     * Monse create pull request.
     */
    @AuraEnabled(cacheable = false)
    public static List<Object> getBranches() {
        User objUser = [SELECT Token__c FROM User WHERE Id = :UserInfo.getUserId()];
        String strResults;
       
        //We prepare user's branches.
        strResults = getHttpResponse(getHttpRequest('Branch', 'GET', 'Authorization', '', '/GitConnection', 'MonsePedroza28', 'https://api.github.com/repos/', '/branches', '', '', '', '', ''));

        List<Object> lstBranches = (List<Object>)JSON.deserializeUntyped(strResults);
        System.debug(LoggingLevel.INFO, lstBranches);
        return lstBranches;
    }

    /**
     * This method obtains the token Id.
     * @return get user's token.
     */
    @AuraEnabled(cacheable = false)
    public static String getTokenId() {
        User objUser = [SELECT Id, Token__c FROM User WHERE Id = :UserInfo.getUserId()];
        strToken = objUser.Token__c;
        return strToken;
    }

    /**
     * This method connects with GitHub and obtains repositories.
     * @return get the list of repositories.
     */
    @AuraEnabled(cacheable = false)
    public static List<Object> getRepositories() {
        User objUser = [SELECT Token__c FROM User WHERE Id = :UserInfo.getUserId()];
        String strResults;

        //We prepare user's repositories.
        strResults = getHttpResponse(getHttpRequest('Repository', 'GET', 'Authorization', '', '', 'MonsePedroza28', 'https://api.github.com/users/', '/repos', '', '', '', '', ''));

        //We obtain user's repositories.
        List<Object> lstRepositories = (List<Object>)JSON.deserializeUntyped(strResults);
        return lstRepositories;
    }   

    /**
     * This method obtains the branches from the GitHub user.
     * @return get the list of branches.
     */
    @AuraEnabled(cacheable = false)
    public static List<Object> getBranches() {
        User objUser = [SELECT Token__c FROM User WHERE Id = :UserInfo.getUserId()];
        String strResults;
       
        //We prepare user's branches.
        strResults = getHttpResponse(getHttpRequest('Branch', 'GET', 'Authorization', '', '/GitConnection', 'MonsePedroza28', 'https://api.github.com/repos/', '/git', '', '', '', '', ''));

        List<Object> lstBranches = (List<Object>)JSON.deserializeUntyped(strResults);
        System.debug(LoggingLevel.INFO, lstBranches);
        return lstBranches;
    }

    /**
     * This method obtains the branches from the GitHub user.
     * @return get the list of branches.
     */
    @AuraEnabled(cacheable = false)
    public static void getFiles() {
        User objUser = [SELECT Token__c FROM User WHERE Id = :UserInfo.getUserId()];
        String strResults;
       
        //We prepare user's branches.
        strResults = getHttpResponse(getHttpRequest('ObtainFile', 'PUT', 'Authorization', '', '/GitConnection', 'MonsePedroza28', 'https://api.github.com/repos/', '/contents/notes', '', '', '', '', ''));

    }

        /**
     * This method obtains the branches from the GitHub user.
     * @return get the list of branches.
     */
    @AuraEnabled(cacheable = false)
    public static List<Object> createPull() {
        User objUser = [SELECT Token__c FROM User WHERE Id = :UserInfo.getUserId()];
        String strResults;
       
        //We prepare user's branches.
        strResults = getHttpResponse(getHttpRequest('CreatePull', 'POST', '', '', '/GitConnection', 'MonsePedroza28', 'https://api.github.com/repos/', '/git/blobs', '', '', '', '', ''));
        List<Object> lstBranches = (List<Object>)JSON.deserializeUntyped(strResults);
        System.debug(LoggingLevel.INFO, lstBranches);
        return lstBranches;
    }


    /**
     * This method obtains the branches from the GitHub user.
     * @return get the list of branches.
     */
    @AuraEnabled(cacheable = false)
    public static List<Object> createCommits() {
        User objUser = [SELECT Token__c FROM User WHERE Id = :UserInfo.getUserId()];
        String strResults;
       
        //We prepare user's branches.
        strResults = getHttpResponse(getHttpRequest('CreateCommit', 'POST', '', '', '/GitConnection', 'MonsePedroza28', 'https://api.github.com/repos/', '/git/commits', '', '', '', '', ''));
        List<Object> lstBranches = (List<Object>)JSON.deserializeUntyped(strResults);
        System.debug(LoggingLevel.INFO, lstBranches);
        return lstBranches;
    }

    /**
     * This method prepares HttpsRequest for differents Version Controllers.
     * @param strType Type of Version Controller.
     * @param strMethod Method to execute.
     * @param strAuthorization Authorization of htppRequest.
     * @param strApplication 
     * @param strRepositoryName Name of repository.
     * @param strUserName User's name.
     * @param strRequest API link.
     * @param strVersionController Type of Version Controller.
     * @param strClientId User's Id
     * @param strClientSecret Id Client Secret
     * @param strCode Code generate for GitHub
     * @param strRedirectUri Redirect link.
     * @param strState Security word.
     */
    public static HttpRequest getHttpRequest(String strType, String strMethod, String strAuthorization, String strApplication, String strRepositoryName, String strUserName, 
    String strRequest, String strVersionController, String strClientId, String strClientSecret, String strCode, String strRedirectUri, String strState){

        //We get Access Token of user.
        User objUser = [SELECT Id, Token__c FROM User WHERE Id = :UserInfo.getUserId()];
        HttpRequest objRequest = new HttpRequest();
        if(strType != null && strType != 'undefined' && strType != ''){
            switch on strType{

                //We prepared access token from user.
                when 'Token' {
                    objRequest.setBody('client_id=' + strClientId + '&client_secret=' + strClientSecret + '&code=' + strCode + '&redirect_uri=' + strRedirectUri + '&state=' + strState);
                    objRequest.setCompressed(false);
                    objRequest.setHeader(strAuthorization, strApplication);
                    objRequest.setEndpoint(strRequest);
                    objRequest.setMethod(strMethod);
                }

                //We prepared user's branch.
                when 'Branch' {
                    objRequest.setEndpoint(strRequest + strUserName + strRepositoryName + strVersionController);
                    objRequest.setHeader(strAuthorization, objUser.Token__c);
                    objRequest.setmethod(strMethod);
                }

                //We prepared user's repositories.
                when 'Repository' {
                    objRequest.setEndpoint(strRequest + strUserName + strVersionController);
                    objRequest.setHeader(strAuthorization, objUser.Token__c);
                    objRequest.setmethod(strMethod);
                }

                                //We prepared user's repositories.
                                when 'CreatePull' {
                                    objRequest.setBody(payload);
                                    objRequest.setEndpoint(strRequest + strUserName + strRepositoryName + strVersionController);
                                    objRequest.setHeader('Authorization','token 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');
                                    objRequest.setHeader('Content-Type', 'application/json');
                                    objRequest.setmethod(strMethod);
                                }
            }
        }
        return objRequest;
    }

   /**
     * This method obtain the HttpResponse.
     * @return get HttpResponse's body.
     */
    public static String getHttpResponse(HttpRequest objRequest){
        String strResults;
        HTTP objHttp = new HTTP();
        HTTPResponse objResponse = objHttp.send(objRequest);
        strResults = objResponse.getBody();
        return strResults;
    }
    /**
     * This method prepares HttpsRequest for differents Version Controllers.
     * @param strType Type of Version Controller.
     * @param strMethod Method to execute.
     * @param strAuthorization Authorization of htppRequest.
     * @param strApplication 
     * @param strRepositoryName Name of repository.
     * @param strUserName User's name.
     * @param strRequest API link.
     * @param strVersionController Type of Version Controller.
     * @param strClientId User's Id
     * @param strClientSecret Id Client Secret
     * @param strCode Code generate for GitHub
     * @param strRedirectUri Redirect link.
     * @param strState Security word.
     */
    public static HttpRequest getHttpRequest(String strType, String strMethod, String strAuthorization, String strApplication, String strRepositoryName, String strUserName, 
    String strRequest, String strVersionController, String strClientId, String strClientSecret, String strCode, String strRedirectUri, String strState){

        //We get Access Token of user.
        User objUser = [SELECT Id, Token__c FROM User WHERE Id = :UserInfo.getUserId()];
        HttpRequest objRequest = new HttpRequest();
        String payload = JSON.serialize(new Map<String,Object>{
            'title' => 'Test2 Pull',
            'body' => 'Please pull this in!',
            'head' => 'Test3',
            'base' => 'master'
        });
        System.debug(payload);
        System.debug('Map');

        String payload2 = JSON.serialize(new Map<String,Object>{
            'message' => 'my commit message',
            'tree'=> '13044c65969013aa3d9eedea027d9734be0020e7'
        });
        System.debug(payload2);
        System.debug('Map2');

        String payload3 = JSON.serialize(new Map<String,Object>{
            'content' => 'Content of the blob',
            'encoding' => 'utf-8'
        });
        System.debug(payload3);
        System.debug('Map3');

        Blob value = Blob.valueOf('Holaaaa');
        String content = EncodingUtil.base64Encode(value);

        String payload4 = JSON.serialize(new Map<String,Object>{
            'message' => 'Ready',
            'content' => content,
            'name' => 'notes',
            'sha' => 'e38d7f6166c0658c5019b23a0f05a057b5fe7eb4',
            'branch' => 'master'
        });

        if(strType != null && strType != 'undefined' && strType != ''){
            switch on strType{

                //We prepared access token from user.
                when 'Token' {
                    objRequest.setBody('client_id=' + strClientId + '&client_secret=' + strClientSecret + '&code=' + strCode + '&redirect_uri=' + strRedirectUri + '&state=' + strState);
                    objRequest.setCompressed(false);
                    objRequest.setHeader(strAuthorization, strApplication);
                    objRequest.setEndpoint(strRequest);
                    objRequest.setMethod(strMethod);
                }

                //We prepared user's branch.
                when 'Branch' {
                    objRequest.setEndpoint(strRequest + strUserName + strRepositoryName + strVersionController);
                    objRequest.setHeader(strAuthorization, objUser.Token__c);
                    objRequest.setmethod(strMethod);
                }

                //We prepared user's repositories.
                when 'Repository' {
                    objRequest.setEndpoint(strRequest + strUserName + strVersionController);
                    objRequest.setHeader(strAuthorization, objUser.Token__c);
                    objRequest.setmethod(strMethod);
                }

                //We prepared user's repositories.
                when 'CreatePull' {
                    objRequest.setBody(payload3);
                    objRequest.setEndpoint(strRequest + strUserName + strRepositoryName + strVersionController);
                    objRequest.setHeader('Authorization','token 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');
                    objRequest.setmethod(strMethod);
                }

                //We prepared user's repositories.
                when 'CreateCommit' {
                    objRequest.setBody(payload2);
                    objRequest.setEndpoint(strRequest + strUserName + strRepositoryName + strVersionController);
                    objRequest.setHeader('Authorization','token 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');
                    objRequest.setmethod(strMethod);
                }

                //We prepared user's repositories.
                when 'ObtainFile' {
                    objRequest.setBody(payload4);
                    objRequest.setEndpoint(strRequest + strUserName + strRepositoryName + strVersionController);
                    objRequest.setHeader('Authorization','token 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');
                    objRequest.setmethod(strMethod);
                }
            }
        }
        return objRequest;
    }


}