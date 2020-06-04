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
    var resource = request.body.resource;
    var limit = parseInt(request.body.limit);
    var fromTime = request.body.fromTime;

    client.appointments.available(scheduleID, fromTime, 60, resource, false, limit, (err, data) => {
        if (err) {
            response.send(err)
        } else {
            response.send(data)
        }
    });
});

exports.create = functions.https.onRequest((request, response) => {
    var scheduleID = parseInt(request.body.scheduleID);
    var userID = request.body.userID;
    var email = request.body.email;
    var fullName = request.body.fullName;
    var start = request.body.start;
    var finish = request.body.finish;
    var phone = request.body.phone;
    var address = request.body.address;
    var resourceID = request.body.resourceID;

    // user_id: attributes['user_id'],
    // booking: {
    //   start: attributes['start'],
    //   finish: attributes['finish'],
    //   name: attributes['name'],
    //   email: attributes['email'],
    //   full_name: attributes['full_name'],
    //   address: attributes['address'],
    //   mobile: attributes['mobile'],
    //   phone: attributes['phone'],
    //   country: attributes['country'],
    //   field_1: attributes['field_1'],
    //   field_2: attributes['field_2'],
    //   field_1_r: attributes['field_1_r'],
    //   field_2_r: attributes['field_2_r'],
    //   super_field: attributes['super_field'],
    //   resource_id: attributes['resource_id'],
    //   slot_id: attributes['slot_id']
    // }

    var attributes = { 'email': email, 'start': start, 'finish': finish, 'full_name': fullName, 'phone': phone, 'address': address, 'resource_id': resourceID, }

    client.appointments.create(scheduleID, userID, attributes, true, true, (err, data) => {
        if (err) {
            response.send(err)
        } else {
            response.send(data)
        }
    });
});