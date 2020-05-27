const stripe = require('stripe');
const functions = require('firebase-functions');
const env = functions.config();
const stripeService = stripe(env.stripe.test_secret_api_key);

/*
    RETRIEVE A CHARGE
    Retreives a charge.
    PARAMS
    String chargeID;
*/
exports.retrieve = functions.https.onRequest((request, response) => {
    const chargeID = request.body.chargeID;

    return stripeService.charges.retrieve(chargeID, (err, charge) => {
        if (err) {
            response.send(err);
        } else {
            response.send(charge);
        }
    });

});

/*
    CREATE A CHARGE
    Creates a new charge.
    PARAMS
    String chargeID;
*/
exports.create = functions.https.onRequest((request, response) => {
    const amount = request.body.amount;
    const description = request.body.description;
    const customerID = request.body.customerID;

    return stripeService.charges.create({
        amount: amount,
        currency: "usd",
        customer: customerID,
        description: description
    }, (err, charge) => {
        if (err) {
            response.send(err);
        } else {
            response.send(charge);
        }
    });

});

/*
    LIST CHARGES
    List all charges to a customer.
    PARAMS
    String chargeID;
*/
exports.listAll = functions.https.onRequest((request, response) => {
    const customerID = request.body.customerID;

    return stripeService.charges.list({ customer: customerID }, (err, charge) => {
        if (err) {
            response.send(err);
        } else {
            response.send(charge);
        }
    });

});