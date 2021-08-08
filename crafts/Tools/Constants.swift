//
//  OFCStrings.swift
//  OrangeFootballClub
//
//  Created by Alaa Taher on 11/15/16.
//  Copyright © 2016 Alaa Taher. All rights reserved.
//

import UIKit

//let SITE_URL = "http://is2host.com/technicians/"
let SITE_URL = "http://nukhbatech.com/"

let BASE_URL = SITE_URL + "api/v1/"

let homeCellHeight:CGFloat = 230.0
let homeCellWidth:CGFloat = 300.0
let myOrderCellHeight = 140.0

let kInternetConnectionNotReachable: String = "NOT_REACHABLE"
let kInternetConnectionReachable: String = "REACHABLE"

enum UIUserInterfaceIdiom : Int {
    case unspecified
    case phone // iPhone and iPod touch style UI
    case pad // iPad style UI
}

class Constants: NSObject {
    struct Urls {
        //Register
        static let CLIENT_REGISTER = BASE_URL + "client-register"
        static let PROVIDER_REGISTER = BASE_URL + "provider-register"
        // Login
        static let LOGIN = BASE_URL + "login"
        // Home
        static let HOME = BASE_URL + "home"
        // Cities
        static let CITIES = BASE_URL + "cities"
        static let DISTRICTS = BASE_URL + "districts/%@" 
        // All Departments
        static let DEPARTMENTS = BASE_URL + "departments"
        // Sub Departments
        static let SUB_DEPARTMENT = BASE_URL + "sub-departments/%@"
        //Full Departments with sub
        static let ALL_DEPARTMENTS = BASE_URL + "all-departments"
        // Check Coupon
        static let CHECK_COUPON = BASE_URL + "check-coupon"
        // Adds
        static let ADDS_SETTING = BASE_URL + "settings"
        // Providers Of Specific City And Department
        static let SPECIFIC_PROVIDERS = BASE_URL + "get-all-providers"
        // Reservation
        static let RESERVATION = BASE_URL + "reservation"
        static let RESERVATION_PAYMENT = BASE_URL + "reservation-payment"
        static let CONVERT_TO_BANK = BASE_URL + "convert-to-bank"
        static let PUBLIC_RESERVATION = BASE_URL + "order-new-service"

        // Client Orders
        static let CLIENT_ORDERS = BASE_URL + "orders-client"
        static let CANCEL_ORDER = BASE_URL + "order-cancel-client/%@"
        static let SUBMIT_NEW_DATE = BASE_URL + "orders-approved-time-reservation"
        static let PREVIOUS_ORDERS = BASE_URL + "reservations_of_end"
        static let END_RESERVATION_CLIENT = BASE_URL + "end-reservation-client"
        static let CLIENT_DECISION = BASE_URL + "client-decision"
        static let APPLICANTS = BASE_URL + "applicants"

        // Provider Orders
        static let PROVIDER_ORDERS = BASE_URL + "orders-provider"
        static let CANCEL_ORDER_PROVIDER = BASE_URL + "order-cancel-provider"
        static let SUGGEST_TIMES = BASE_URL + "suggest-times"
        static let APPROVE_ORDER = BASE_URL + "approved-reservation-provider"
        static let END_CASH_ORDER = BASE_URL + "end-reservation"
        static let PUBLIC_ORDERS = BASE_URL + "public-orders"
        static let APPLY_TO_ORDER = BASE_URL + "apply"

        // Auth
        static let FORGET_PASSWORD = BASE_URL + "forget-password"
        static let RESET_PASSWORD = BASE_URL + "reset-password"
        static let ACTIVATE_ACCOUNT = BASE_URL + "active-account"
        
        // Articles
        static let ARTICLES = BASE_URL + "articles"
        static let SINGLE_ARTICLE = BASE_URL + "article/%@"
        
        // Places
        static let GET_PLACES = BASE_URL + "get-places"
        static let SAVE_PLACE = BASE_URL + "add-places"
        static let REMOVE_PLACE = BASE_URL + "remove-place/%@"
        
        // Chat
        static let ALL_CHATS = BASE_URL + "all-chat"
        static let CHAT = BASE_URL + "chat/%@"
        static let OPEN_CHAT = BASE_URL + "open-chat/%@"
        static let SEND_CHAT = BASE_URL + "send-chat/%@"
        
        // Provider Services
        static let SERVICES = BASE_URL + "services"
        static let ADD_SERVICE = BASE_URL + "new-service"
        static let EDIT_SERVICE = BASE_URL + "edit-service"
        static let REMOVE_SERVICE = BASE_URL + "destroy-service"
        static let ADD_OFFER = BASE_URL + "add-offer"
        static let REMOVE_OFFER = BASE_URL + "add-offer"
        
        // Provider Commissions
        static let NOT_PAID_COMMISSIONS = BASE_URL + "commissions-not-paid"
        static let PAY_COMMISSION = BASE_URL + "pay-commission"
        static let PAID_COMMISSIONS = BASE_URL + "commissions-paid"
        static let COMMISSION_DISCOUNT_REQUEST = BASE_URL + "add-discount-request"
        
        
        // Provider Details
        static let PROVIDER_DETAILS = BASE_URL + "provider-details/%@"
        
        
        // Favourites
        static let FAVOURITES = BASE_URL + "favorites"                              // All Favourites
        static let ADD_TO_FAVOURITE = BASE_URL + "add-favorite"                     // Add To Favourite
        static let REMOVE_FROM_FAVOURITE = BASE_URL + "delete-favorite/%@"        // Remove From Favourite
        
        
        // All Providers
        static let ALL_PROVIDERS = BASE_URL + "get-all-providers"
        static let EDIT_CLIENT_PROFILE = BASE_URL + "edit-client-profile"
        static let EDIT_PROVIDER_PROFILE = BASE_URL + "edit-provider-profile"
        static let UPDATE_CLIENT_PROFILE = BASE_URL + "update-client-profile"
        static let UPDATE_PROVIDER_PROFILE = BASE_URL + "update-provider-profile"
        static let CHANGE_PASSWORD = BASE_URL + "change-password"
        
        static let SHOW_WALLET = BASE_URL + "show-wallet"
        static let PROVIDER_WALLET_TRANSACTIONS = BASE_URL + "provider-wallet-transactions"
        static let CLIENT_WALLET_TRANSACTIONS = BASE_URL + "client-wallet-transactions"
        
        static let SOCIAL_LOGIN = BASE_URL + "social-login"
        // Rate
        static let RATE = BASE_URL + "rate"
        
        //  Comments Provider
        static let PROVIDER_COMMENTS = BASE_URL + "provider-comments"
        static let OBJECT_COMMENT_PROVIDER = BASE_URL + "provider-objection/%@"
        
        static let PROVIDER_DETAILS_COMMENTS = BASE_URL + "provider-details-comments/%@"
        
        //  Comments Client
        static let CLIENT_COMMENTS = BASE_URL + "client-comments"
        static let OBJECT_COMMENT_CLIENT = BASE_URL + "client-objection/%@"
        
        // Notifications
        static let NOTIFICATIONS_CALL = BASE_URL + "notifications"
        static let READ_NOTIFICATION = BASE_URL + "notification-read"
        
        // Provider Balance
        static let PROVIDER_BALANCE = BASE_URL + "provider-balance-sheet"
        static let CLIENT_BALANCE = BASE_URL + "client-balance-sheet"
        
        // Contact Us
        static let CONTACT_INFO = BASE_URL + "contact-info"
        static let POLICY = BASE_URL + "policy"
        static let CONTACT_US = BASE_URL + "contact-us"
        
        // Verification Request
        static let SEND_VERFiCATION_REQUEST = BASE_URL + "send-verification-request"
        
        static let POINTS = BASE_URL + "points"
        static let CONVERT_TO_POINTS = BASE_URL + "convert-to-points"
        static let RECOVERY = BASE_URL + "recovery"
        static let MAKE_SATISFIED = BASE_URL + "make-satisfied"
        static let MANAGEMENT_REPORTING = BASE_URL + "management-reporting"
        static let PAYABLE = BASE_URL + "payable"
        static let BALANCES = BASE_URL + "balances"
        static let CONFIRM_PAYMENT_ADMIN = BASE_URL + "confirm-payment-from-admin"
        static let APP_COLORS = BASE_URL + "app_colors"
        static let accounts = BASE_URL + "bank-accounts"
        static let bankInfo = BASE_URL + "bankInfo/%@"
        
        static let PAYMENT_BASE_URL = BASE_URL + "epay/%@?api_token=%@&lang=%@"
        
        static let PAYMENT_TOKEN = "7Fs7eBv21F5xAocdPvvJ-sCqEyNHq4cygJrQUFvFiWEexBUPs4AkeLQxH4pzsUrY3Rays7GVA6SojFCz2DMLXSJVqk8NG-plK-cZJetwWjgwLPub_9tQQohWLgJ0q2invJ5C5Imt2ket_-JAlBYLLcnqp_WmOfZkBEWuURsBVirpNQecvpedgeCx4VaFae4qWDI_uKRV1829KCBEH84u6LYUxh8W_BYqkzXJYt99OlHTXHegd91PLT-tawBwuIly46nwbAs5Nt7HFOozxkyPp8BW9URlQW1fE4R_40BXzEuVkzK3WAOdpR92IkV94K_rDZCPltGSvWXtqJbnCpUB6iUIn1V-Ki15FAwh_nsfSmt_NQZ3rQuvyQ9B3yLCQ1ZO_MGSYDYVO26dyXbElspKxQwuNRot9hi3FIbXylV3iN40-nCPH4YQzKjo5p_fuaKhvRh7H8oFjRXtPtLQQUIDxk-jMbOp7gXIsdz02DrCfQIihT4evZuWA6YShl6g8fnAqCy8qRBf_eLDnA9w-nBh4Bq53b1kdhnExz0CMyUjQ43UO3uhMkBomJTXbmfAAHP8dZZao6W8a34OktNQmPTbOHXrtxf6DS-oKOu3l79uX_ihbL8ELT40VjIW3MJeZ_-auCPOjpE3Ax4dzUkSDLCljitmzMagH2X8jN8-AYLl46KcfkBV"
        
        static let BASE_URL_DIRECT_PAYMENT = "https://apidemo.myfatoorah.com/"
        static let EMAIL_DIRECT_PAYMENT = "apidirectpayment@myfatoorah.com" // Merchant Email
        static let PASSWORD_DIRECT_PAYMENT = "api12345*"
    }
    
    struct PayMethods {
        static let ON_DELIVER: String  = "on_deliver"
        static let E_PAYMENT: String  = "e_payment"
        static let BANK: String  = "bank"
        static let WALLET: String  = "wallet"
    }
    
    struct StatusCode {
        static let StatusOK = 200
        static let StatusCreated = 201
        static let StatusNoContent = 204
        static let StatusNotfound = 404
    }
    
    struct AlertType {
        static let AlertError = 1
        static let AlertSuccess = 2
        static let Alertinfo = 3
        static let AlertWarn = 4
    }
    
    struct userDefault {
        static let userData = "userData"
        static let userToken = "userToken"
        static let userID = "userID"
        static let userName = "userName"
        static let userImage = "userImage"
        static let userMobile = "userMobile"
        static let userEmail = "userEmail"
        static let userPoints = "userPoints"
        static let language = "language"
        static let activeStatus = "activeState"
        static let player_id = "player_id"
        
        static let notificationsCount = "notificationsCount"
        static let messagesCount = "messagesCount"
        static let ordersCount = "ordersCount"
        
        static let IS_PROVIDER = "IS_PROVIDER"
        
        static let userReservation = "userReservation"
        static let userSettings = "userSettings"
    }
    
    struct storyBoard {
        static let authentication = "Authentication"
        static let main = "Main"
        static let user = "User"
        static let reservation = "Reservation"
        static let provider = "Provider"
    }
    
    struct pucher {
        static let CLIENT_ID: Int = 883775
        static let CLIENT_SECRET: String = "c206ef6190ce7c3d68bc"
        static let CLIENT_KEY: String = "af9be97dd59fcfcd6477"
        static let CHATKIT_INSTANCE_LOCATOR: String = "CHATKIT_INSTANCE_LOCATOR"
        static let CLUSTER: String = "eu"
    }
    
    struct OrderStatus {
        static let INITIAL: String  = "initial"
        static let DONE: String  = "done"; // Confirmed
        static let CHANGE_TIME: String  = "waiting_time"
        static let CANCELED: String  = "cancel"
        static let BANK_AGREE: String  = "bank_admin_agree"
        static let END: String  = "end"


        static let greenColor = UIColor(red: 0.00, green: 0.53, blue: 0.26, alpha: 1.00)
        static let pinkColor = UIColor(red: 0.78, green: 0.26, blue: 0.28, alpha: 1.00)
        static let blueColor = UIColor(red: 0.22, green: 0.63, blue: 0.78, alpha: 1.00)
    }
}
