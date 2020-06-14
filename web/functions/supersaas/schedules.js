const functions = require('firebase-functions');
const env = functions.config();
const supersaas = require('supersaas-api-client');
const Client = supersaas.Client;
const client = new Client({ accountName: env.supersaas.account_name, api_key: env.supersaas.api_key, });


exports.list = functions.https.onRequest((request, response) => {

    client.schedules.list((err, data) => {
        if (err) {
            response.send(err)
        } else {
            response.send(data)
        }
    });
});
