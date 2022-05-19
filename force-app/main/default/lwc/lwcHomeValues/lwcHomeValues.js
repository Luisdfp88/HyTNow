import { LightningElement, track } from 'lwc';
import { subscribe, unsubscribe, onError, setDebugFlag, isEmpEnabled } from 'lightning/empApi';
import getLastReport from '@salesforce/apex/ReportController.getLastReport';
import getHighestTemperature from '@salesforce/apex/ReportController.getHighestTemperature';
import getLowestTemperature from '@salesforce/apex/ReportController.getLowestTemperature';
import getHighestHumidity from '@salesforce/apex/ReportController.getHighestHumidity';
import getLowestHumidity from '@salesforce/apex/ReportController.getLowestHumidity';
import countReports from '@salesforce/apex/ReportController.countReports';

export default class LwcHomeValues extends LightningElement {
    channelName = '/event/Update_Values__e';
    isSubscribeDisabled = false;
    isUnsubscribeDisabled = !this.isSubscribeDisabled;
    @track homeValues = [];
    @track humidity = '';
    @track temperature = '';
    @track highestTemperature = '';
    @track lowestTemperature  = '';
    @track highestHumidity  = '';
    @track lowestHumidity  = '';
    now = new Date();
    days = ['Lunes','Martes','Miercoles','Jueves','Viernes','Sábado','Domingo'];
    months = ['Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'];
    day = this.days[ this.now.getDay() ];
    month = this.months[ this.now.getMonth() ];
    fechaHoy = this.day + ', ' + this.now.getDate() + ' de ' + this.month
    fechaAyer = 'Reporte dia ' + (this.now.getDate() - 1) + ' de ' + this.month

    connectedCallback() {
        this.handleSubscribe();
        this.setValues();
    }

    disconnectedCallback() {
        this.handleUnsubscribe();
    }

    handleSubscribe() {
        subscribe(this.channelName, -1, this.messageCallback).then(response => {
            console.log('Subscribed to ' + response.channel);
        });
    }

    handleUnsubscribe() {
        unsubscribe(this.subscription, response => {
            console.log('Unsubscribed from ' + response.channel);
        });
    }

    messageCallback = (response) => {
        this.humidity = response.data.payload.Humedad__c + '%';
        this.temperature = response.data.payload.Temperatura__c + ' °C';
        this.setDefaults();
        if(this.temperature > this.highestTemperature) {
            this.highestTemperature = this.temperature;
        }
        if(this.temperature < this.lowestTemperature) {
            this.lowestTemperature = this.temperature;
        }
        if(this.humidity > this.highestHumidity) {
            this.highestHumidity = this.humidity;
        }
        if(this.humidity < this.lowestHumidity) {
            this.lowestHumidity = this.humidity;
        }
    }

    setDefaults(){
        if(this.highestTemperature == '' && this.lowestTemperature == '' && this.highestHumidity == '' && this.lowestHumidity == '') {
            this.highestTemperature = this.temperature;
            this.lowestTemperature = this.temperature;
            this.highestHumidity = this.humidity;
            this.lowestHumidity = this.humidity;
        }
    }
    async setValues() {
        if(await countReports() === 0){
            this.humidity = '';
            this.temperature = '';
            this.highestTemperature = '';
            this.lowestTemperature  = '';
            this.highestHumidity  = '';
            this.lowestHumidity  = '';
        }else{
            this.humidity = (await getLastReport()).Humidity__c + '%';
            this.temperature = (await getLastReport()).Temperature__c + ' °C';
            this.highestTemperature = (await getHighestTemperature()).Temperature__c +' ºC'
            this.lowestTemperature = (await getLowestTemperature()).Temperature__c +' ºC'
            this.highestHumidity = (await getHighestHumidity()).Humidity__c +'%'
            this.lowestHumidity = (await getLowestHumidity()).Humidity__c +'%'
        }
    }
}