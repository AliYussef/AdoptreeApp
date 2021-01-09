//
//  ApiEndPoint.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation

enum ApiEndPoint: CustomStringConvertible {
    case bookedtourByUser
    case bookedtour
    case bookedtourByIdDelete(Int64)
    case category
    case content
    case country
    case forest
    case wildlifeByForest(Int64)
    case notifydeviceById(Int64)
    case notifydevice
    case orderById(Int64)
    case order
    case product
    case telemetryById(Int64)
    case tour
    case treesByUser
    case treeImages(Int64)
    case personalize
    case renewTree
    case sequestration(Int64)
    case treesign
    case treesignByTree(Int64)
    case user
    case loggedInUser
    case forgetpassword
    case resetpassword
    case login
    case register
    case logout
    case refreshToken
    //case userById(Int64)
    //case categoryById(Int64)
    //case contentById(Int64)
    //case countryById(Int64)
    //case forestById(Int64)
    //case treesByForest(Int64)
    //case imageById(Int64)
    //case image
    //case paymentStatus
    //case productById(Int64)
    //case settingById(Int64)
    //case setting
    //case telemetry
    //case tourById(Int64)
    //case treeById(Int64)
    //case tree
    //case initializeTree
    //case treesignById(Int64)
    //case treespeciesById(Int64)
    //case treespecies
    //case wildlifeById(Int64)
    //case wildlife
    
    var description: String {
        switch self {
            case .bookedtourByUser:
                return "user/bookedtours"
            case .bookedtour:
                return "bookedtour"
            case .bookedtourByIdDelete(let id):
                return "bookedtour/\(id)"
            case .category:
                return "category"
            case .content:
                return "content"
            case .country:
                return "country"
            case .forest:
                return "forest"
            case .notifydeviceById(let id):
                return "notifydevice/\(id)"
            case .notifydevice:
                return "notifydevice"
            case .orderById(let id):
                return "order/\(id)"
            case .order:
                return "order"
            case .product:
                return "product"
            case .telemetryById(let id):
                return "telemetry/\(id)"
            case .tour:
                return "tour"
            case .treesign:
                return "treesign"
            case .user:
                return "user"
            case .loggedInUser:
                return "loggedinuser"
            case .wildlifeByForest(let id):
                return "forest/\(id)/wildlife"
            case .treeImages(let id):
                return "tree/\(id)/image"
            case .personalize:
                return "tree/personalize"
            case .renewTree:
                return "tree/renew"
            case .sequestration(let id):
                return "tree/\(id)/sequestration"
            case .treesignByTree(let id):
                return "treesign/tree/\(id)"
            case .treesByUser:
                return "user/trees"
            case .forgetpassword:
                return "user/forgetpassword"
            case .resetpassword:
                return "user/resetpassword"
            case .login:
                return "auth/login"
            case .register:
                return "auth/register"
            case .logout:
                return "auth/logout"
            case .refreshToken:
                return "auth/refreshToken"
            // case .userById(let id):
            //                return "user/\(id)"
            //            case .categoryById(let id):
            //                return "category/\(id)"
            //            case .contentById(let id):
            //                return "content/\(id)"
            //            case .countryById(let id):
            //                return "country/\(id)"
            //            case .forestById(let id):
            //                return "forest/\(id)"
            //            case .imageById(let id):
            //                return "image/\(id)"
            //            case .image:
            //                return "image"
            //            case .productById(let id):
            //                return "product/\(id)"
            //            case .settingById(let id):
            //                return "setting/\(id)"
            //            case .setting:
            //                return "setting"
            //            case .telemetry:
            //                return "telemetry"
            //            case .tourById(let id):
            //                return "tour/\(id)"
            //            case .treeById(let id):
            //                return "tree/\(id)"
            //            case .tree:
            //                return "tree"
            //            case .treesignById(let id):
            //                return "treesign/\(id)"
            //            case .treespeciesById(let id):
            //                return "treespecies/\(id)"
            //            case .treespecies:
            //                return "treespecies"
            //            case .wildlifeById(let id):
            //                return "wildlife/\(id)"
            //            case .wildlife:
            //                return "wildlife"
            //            case .treesByForest(let id):
            //                return "forest/\(id)/trees"
            //            case .paymentStatus:
            //                return "order/paymentStatus"
            //            case .initializeTree:
            //                return "tree/initialize"
        }
    }
}
