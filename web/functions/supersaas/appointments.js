const functions = require('firebase-functions');
const env = functions.config();
const supersaas = require('supersaas-api-client');
const Client = supersaas.Client;
const client = new Client({ accountName: env.supersaas.account_name, api_key: env.supersaas.api_key, });

/*
    GET AVAILABLE APPOINTMENTS
    ...
    PARAMS 
    ?
*/

exports.getAvailable = functions.https.onRequest((request, response) => {
    var scheduleID = parseInt(request.body.scheduleID);

    client.appointments.available(scheduleID, '2018-01-31 00:00:00', 60, 'Trey Hope', (err, data) => {
        if (err) {
            response.send(err)
        } else {
            response.send(data)
        }
    });
});