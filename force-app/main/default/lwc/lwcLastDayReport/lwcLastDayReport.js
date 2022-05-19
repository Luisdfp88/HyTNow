import { LightningElement, track } from 'lwc';
import getLastReport from '@salesforce/apex/DailyAvgController.getLastReport';

export default class LwcLastDayReport extends LightningElement {
    @track lastReport = {}

    @track avgTemp

    @track avgHumidity

    @track maxTemp

    @track minTemp

    @track maxHumidity

    @track minHumidity

    now = new Date();
    days = ['Lunes','Martes','Miercoles','Jueves','Viernes','Sábado','Domingo'];
    months = ['Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre'];
    day = this.days[ this.now.getDay() ];
    month = this.months[ this.now.getMonth() ];
    fechaAyer = 'Reporte dia ' + (this.now.getDate() - 1) + ' de ' + this.month

    async getLastReport() {
        getLastReport()
        .then(result => {
            this.lastReport = result[0];
            this.avgTemp = result[0].Avg_Temperature__c + ' °C';
            this.avgHumidity = result[0].Avg_Humidity__c + ' %';
            this.maxTemp = result[0].Highest_Temperature__c + ' °C';
            this.minTemp = result[0].Lowest_Temperature__c + ' °C';
            this.maxHumidity = result[0].Highest_Humidity__c + ' %';
            this.minHumidity = result[0].Lowest_Humidity__c + ' %';

        })
        .catch(error => {
            console.error(error);
        })
        

    }

    connectedCallback() {
        this.getLastReport()
    }
}