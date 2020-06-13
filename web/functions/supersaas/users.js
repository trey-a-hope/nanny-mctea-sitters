const functions = require('firebase-functions');
const env = functions.config();
const supersaas = require('supersaas-api-client');
const Client = supersaas.Client;
const client = new Client({ accountName: env.supersaas.account_name, api_key: env.supersaas.api_key, });

exports.create = functions.https.onRequest((request, response) => {
    var name = request.body.name;
    var full_name = request.body.full_name;
    var userID = request.body.userID;

    // name: validation.validatePresent(attributes['name']),
    // email: attributes['email'],
    // password: attributes['password'],
    // full_name: attributes['full_name'],
    // address: attributes['address'],
    // mobile: attributes['mobile'],
    // phone: attributes['phone'],
    // country: attributes['country'],
    // field_1: attributes['field_1'],
    // field_2: attributes['field_2'],
    // super_field: attributes['super_field'],
    // credit: attributes['credit'],
    // role: attributes['role']

    client.users.create({
        'name': name,
        'full_name': full_name,
    }, userID, true, (err, data) => {
        if (err) {
            response.send(err)
        } else {
            response.send(data)
        }
    });
});

exports.update = functions.https.onRequest((request, response) => {
    var userID = request.body.userID;
    var name = request.body.name;

    client.users.update(userID, {
        'name': name,
    }, null, (err, data) => {
        if (err) {
            response.send(err)
        } else {
            response.send(data)
        }
    });
});

exports.get = functions.https.onRequest((request, response) => {
    var userID = request.body.userID;

    client.users.get(userID, (err, data) => {
        if (err) {
            response.send(err)
        } else {
            response.send(data)
        }
    });
});

exports.list = functions.https.onRequest((request, response) => {
    client.users.list(false, null, null, (err, data) => {
        if (err) {
            response.send(err)
        } else {
            response.send(data)
        }
    });
});

exports.delete = functions.https.onRequest((request, response) => {
    var userID = request.body.userID;

    client.users.delete(userID, (err, data) => {
        if (err) {
            response.send(err)
        } else {
            response.send(data)
        }
    });
});
