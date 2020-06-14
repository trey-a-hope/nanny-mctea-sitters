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
const SuperSaaSAppointments = require('./supersaas/appointments');
const SuperSaaSResources = require('./supersaas/resources');
const SuperSaaSUsers = require('./supersaas/users');
const SuperSaaSSchedules = require('./supersaas/schedules');

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

//Super SAAS Appointments
exports.GetAvailableAppointments = SuperSaaSAppointments.getAvailable;
exports.CreateAppointment = SuperSaaSAppointments.create;
exports.GetAgenda = SuperSaaSAppointments.getAgenda;

//Super SAAS Resources
exports.ListAllResources = SuperSaaSResources.list;

//Super SAAS Schedules
exports.SuperSaaSListAllSchedules = SuperSaaSSchedules.list;

//Super SAAS Users
exports.SuperSaaSCreateUser = SuperSaaSUsers.create;
exports.SuperSaaSUpdateUser = SuperSaaSUsers.update;
exports.SuperSaaSGetUser = SuperSaaSUsers.get;
exports.SuperSaaSListUsers = SuperSaaSUsers.list;
exports.SuperSaaSDeleteUser = SuperSaaSUsers.delete;
