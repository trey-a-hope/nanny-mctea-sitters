const stripe = require('stripe');
const functions = require('firebase-functions');
const env = functions.config();
const stripeService = stripe(env.stripe.test_secret_api_key);

/*
    RETRIEVE A PLAN
    https://stripe.com/docs/api/plans/retrieve
*/

exports.retrieve = functions.https.onRequest((request, response) => {
    const id = request.body.id;

    return stripeService.plans.retrieve(id, (err, plan) => {
            if (err) {
                response.send(err);
            } else {
                response.send(plan);
            }
        });

});