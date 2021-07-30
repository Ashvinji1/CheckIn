import { LightningElement,api } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent' ;
import createCheckInRecord from '@salesforce/apex/SaveCheckIn.createCheckInRecord';
import validateOTP from '@salesforce/apex/SaveCheckIn.validateOTP';


export default class OTPComponent extends LightningElement {
    @api recordId;
    cardLabel = 'Click on the button to generate OTP';
    showGenerateOtpButton = true;
    showFormPanel = false;
    otp ;
    purpose ;
    inputError = '';
    isError = false;
    isOtpMatched ;
    isRegenerateOtpButtonDisabled = true;
    otpGeneratedTime;
    otpSubmittedTime;
    countDown;
    timeDiff;
    
    
    generateOTP(){
        this.cardLabel="Please enter details and submit";
        this.otp = null;
        this.purpose = null;
        this.showFormPanel = true;
        this.showGenerateOtpButton = false;
        this.isRegenerateOtpButtonDisabled = true;
        this.isError=false;
        this.inputError = null;
        // Set the date we're counting down to
        var countDownDate = new Date().getTime()+120000;

        // Update the count down every 1 second
        var x = setInterval(function() {

        // Get today's date and time
        var now = new Date().getTime();
            
        // Find the distance between now and the count down date
        var distance = countDownDate - now;
            
        // Time calculations for minutes and seconds
        var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
        var seconds = Math.floor((distance % (1000 * 60)) / 1000);
            
        // Output the result in an element with id="demo"
        this.countDown =minutes + "m " + seconds + "s ";
            
        // If the count down is over, write some text 
        if (distance < 0) {
            clearInterval(x);
            this.countDown = "";
        }
        }.bind(this), 1000);


        setTimeout(function(){
            this.isRegenerateOtpButtonDisabled = false;
        }.bind(this), 120000);

        createCheckInRecord({contactId: this.recordId })
            .then(result => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'OTP Email Sent.',
                        message: 'We have sent a OTP to visitors registered email address',
                        variant: 'info',
                        mode: 'dismissable'
                    }),
                );
                this.otpGeneratedTime = new Date();              
            })
            .catch(error => {
                
            });

    }    
    handleOtpChange(event){
        this.isError=false;
        this.inputError = null;
        const re = /^[0-9\b]+$/;
        if (event.target.value === '' || re.test(event.target.value))  {
                this.isError=false;
                this.inputError = '';
                this.otp = event.target.value;
            }
        else{
                this.isError=true;
                this.inputError = 'Only numbers(0-9) are allowed in OTP';
                return null;
             }
    }
    handlePurposeChange(event){
        this.isError=false;
        this.inputError = null;
        this.purpose = event.target.value;

    }
    handleSuccess(event) {
        if(this.otp=='' || this.otp==null){
            this.isError=true;
            this.inputError = 'Please enter OTP';
            return null;
 
        }
        else if(this.purpose=='' || this.purpose==null||this.purpose=='--None--'){
             this.isError=true;
             this.inputError = 'Please select Purpose';
             return null;
         }
         this.otpSubmittedTime = new Date();
         this.timeDiff = (this.otpSubmittedTime.getTime() - this.otpGeneratedTime.getTime()) / 1000;
         if(this.timeDiff<=120){
            validateOTP({contactId: this.recordId, enteredOTP: this.otp, enteredPurpose: this.purpose })
            .then(result => {
                this.isOtpMatched = result;
                if(this.isOtpMatched=='true'){
                   
                    this.showGenerateOtpButton = true;
                    this.showFormPanel = false;
                    this.otp = null;
                    this.purpose = null; 
                    this.isRegenerateOtpButtonDisabled = false;
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Successfully checked in.',
                            variant: 'success',
                            mode: 'dismissable'
                        }),
                    );
                    
                }
                else {
                    this.isError=true;
                    this.inputError = this.isOtpMatched;
                    return null;
                }
            
            })
            .catch(error => {
                
            });
    }
      else{
        this.isError=true;
        this.inputError = 'OTP is expired. Please regenerate it.';
      }       
    }
}