const stripe = require('stripe');
const functions = require('firebase-functions');
const env = functions.config();
const stripeService = stripe(env.stripe.test_secret_api_key);

/*
    CREATE A PRODUCT
    https://stripe.com/docs/api/service_products/create
*/

exports.create = functions.https.onRequest((request, response) => {
    const name = request.body.name;
    const type = request.body.type;

    return stripeService.products.create(
        {
            name: name,
            type: type,
        }, (err, product) => {
            if (err) {
                response.send(err);
            } else {
                response.send(product);
            }
        });

});