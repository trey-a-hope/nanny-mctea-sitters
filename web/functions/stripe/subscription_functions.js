const stripe = require('stripe');
const functions = require('firebase-functions');
const env = functions.config();
const stripeService = stripe(env.stripe.test_secret_api_key);

/*
    CREATE A SUBSCRIPTION
    https://stripe.com/docs/api/subscriptions/create
*/

exports.create = functions.https.onRequest((request, response) => {
    const customerID = request.body.customerID;
    const plan = request.body.plan;

    return stripeService.subscriptions.create(
        {
            customer: customerID,
            items: [
                {
                    plan: plan,
                },
            ],
            billing_cycle_anchor: Math.floor(new Date(Date.now() + 1000 /*sec*/ * 60 /*min*/ * 60 /*hour*/ * 24 /*day*/ * 1) / 1000)
        }, (err, subscription) => {
            if (err) {
                response.send(err);
            } else {
                response.send(subscription);
            }
        });

});

exports.retrieve = functions.https.onRequest((request, response) => {
    const subscriptionID = request.body.subscriptionID;

    return stripeService.subscriptions.retrieve(subscriptionID, (err, subscription) => {
        if (err) {
            response.send(err);
        } else {
            response.send(subscription);
        }
    });
});

exports.cancel = functions.https.onRequest((request, response) => {
    const subscriptionID = request.body.subscriptionID;
    const invoice_now = request.body.invoice_now;
    const prorate = request.body.prorate;

    return stripeService.subscriptions.del(subscriptionID, {
        invoice_now: invoice_now,
        prorate: prorate
    }, (err, confirmation) => {
        if (err) {
            response.send(err);
        } else {
            response.send(confirmation);
        }
    });
});