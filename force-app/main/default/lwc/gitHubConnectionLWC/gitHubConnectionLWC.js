/**
 * This JavaScript component controls the GitHub Connection LWC.
 * <p /><p />
 * @author Arcode.
 */

//Standard Imports.
import {LightningElement, track, api, wire} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

//Apex Imports.
import getAuthentication from '@salesforce/apex/gitHubConnectionController.getAuthentication';
import getRepositories from '@salesforce/apex/gitHubConnectionController.getRepositories';
import getBranches from '@salesforce/apex/gitHubConnectionController.getBranches';
import getTokenId from '@salesforce/apex/gitHubConnectionController.getTokenId';
import getToken from '@salesforce/apex/gitHubConnectionController.getToken';

const objColumnsRepositories = [
  {label: 'id', fieldName: 'id'},
  {label: 'name', fieldName: 'name'}
];

const objColumnsBranches = [
  {label: 'id', fieldName: 'key'},
  {label: 'name', fieldName: 'name'}
];

export default class gitHubConnectionLWC extends LightningElement {

  //Private variables.
  strUrl = '';
  strToken = '';
  objStatus = '';
  objColumnsRepositories = objColumnsRepositories;
  objColumnsBranches = objColumnsBranches;
  boolRepositories = false;
  boolBranches = false;
  boolAuthetication = true;

    /**
   * Constructor of the component.
   */
  constructor() {
    super();
		let objParent = this;
    
    getTokenId().then((strToken)=> {
      if(typeof strToken !== "undefined" && strToken !== null && strToken !== "") {
        objParent.boolAuthetication = false;
        objParent.boolButtons = true;
      }
    });
  }

  /**
   * This method sends the user to authenticate.
   */
  handleGetAuthentication() {
    getAuthentication().then((strUrl) => {
    let objParent = this;

      //The url opens in a new window.
      window.open(strUrl);

      //We wait for the token to be generated.
      let objTimeOut = setTimeout(function evaluateAuthentication() {
        getTokenId().then((strToken)=> {
          //Obtain token and if the token exists and is valid.
          if(typeof strToken !== "undefined" && strToken !== null && strToken !== "") {
            objParent.showSuccessToast();
            clearTimeout(objTimeOut);
            objParent.boolAuthetication = false;
            objParent.boolButtons = true;

          } else {
            objParent.boolAuthetication = true;
            objParent.boolButtons = false;
            setTimeout(evaluateAuthentication, 1000);
          }
        });
      }, 1000);
    });
  }

  /**
   * This method displays user's repositories.
   */
   handleGetRepositories() {
    getRepositories().then((lstRepositories) => {
      this.boolRepositories = lstRepositories;
    });
  }

  /**
   * This method display user's branches.
   */
  handleGetBranches() {
    getBranches().then((lstBranches) => {
      this.boolBranches = lstBranches;
    });
  }

  /**
   * This method display succesful alert.
   */
  showSuccessToast() {
    const objEvent = new ShowToastEvent({
        title: 'Successful authentication',
        message: 'Connect with GitHub',
        variant: 'success',
        mode: 'dismissable'
    });
    this.dispatchEvent(objEvent);
}
}