const stripe = require('stripe');
const functions = require('firebase-functions');
const env = functions.config();
const stripeService = stripe(env.stripe.test_secret_api_key);

/*
    RETRIEVE A COUPON
    https://stripe.com/docs/api/coupons/retrieve
*/

exports.retrieve = functions.https.onRequest((request, response) => {
    const couponID = request.body.couponID;

    return stripeService.coupons.retrieve(
        couponID,
        (err, coupon) => {
            if (err) {
                response.send(err);
            } else {
                response.send(coupon);
            }
        }
    );
});