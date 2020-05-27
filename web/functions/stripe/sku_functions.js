const stripe = require('stripe');
const functions = require('firebase-functions');
const env = functions.config();
const stripeService = stripe(env.stripe.test_secret_api_key);

/*
    RETRIEVE A SKU
    https://stripe.com/docs/api/coupons/retrieve
*/

exports.retrieve = functions.https.onRequest((request, response) => {
    const skuID = request.body.skuID;

    return stripeService.skus.retrieve(
        skuID,
        (err, sku) => {
            if (err) {
                response.send(err);
            } else {
                response.send(sku);
            }
        }
    );
});