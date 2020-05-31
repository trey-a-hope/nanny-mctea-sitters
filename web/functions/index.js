const functions = require('firebase-functions');
const admin = require('firebase-admin');
const StripeCard = require('./stripe/card_functions');
const StripeToken = require('./stripe/token_functions');
const StripeCustomer = require('./stripe/customer_functions');
const StripeCoupon = require('./stripe/coupon_functions');
const StripeCharge = require('./stripe/charge_functions');
const StripeSubscription = require('./stripe/subscription_functions');
const StripeOrder = require('./stripe/order_functions');
const StripeProduct = require('./stripe/product_functions');
const StripeSku = require('./stripe/sku_functions');
const StripePlan = require('./stripe/plan_functions');
const SuperSaasAppointments = require('./supersaas/appointments');

admin.initializeApp(functions.config().firebase);

//Stripe Cards
exports.StripeCreateCard = StripeCard.create;
exports.StripeDeleteCard = StripeCard.delete;

//Stripe Charges
exports.StripeCreateCharge = StripeCharge.create;
exports.StripeListAllCharges = StripeCharge.listAll;
exports.StripeRetrieveCharge = StripeCharge.retrieve;

//Stripe Customers
exports.StripeCreateCustomer = StripeCustomer.create;
exports.StripeUpdateCustomer = StripeCustomer.update;
exports.StripeRetrieveCustomer = StripeCustomer.retrieve;
exports.StripeDeleteCustomer = StripeCustomer.delete;

//Stripe Coupons
exports.StripeRetrieveCoupon = StripeCoupon.retrieve;

//Stripe Orders
exports.StripeCreateOrder = StripeOrder.create;
exports.StripeListOrders = StripeOrder.list;
exports.StripeUpdateOrder = StripeOrder.update;
exports.StripePayOrder = StripeOrder.pay;

//Stripe Plans
exports.StripeRetrievePlan = StripePlan.retrieve;

//Stripe Products
exports.StripeCreateProduct = StripeProduct.create;

//Stripe Skus
exports.StripeRetrieveSku = StripeSku.retrieve;

//Stripe Subscriptions
exports.StripeCreateSubscription = StripeSubscription.create;
exports.StripeRetrieveSubscription = StripeSubscription.retrieve;
exports.StripeCancelSubscription = StripeSubscription.cancel;

//Stripe Tokens
exports.StripeCreateToken = StripeToken.create;

//Super SAAS
exports.GetAvailableAppointments = SuperSaasAppointments.getAvailable;