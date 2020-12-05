//
//  ApiEndPoint.swift
//  AdoptreeApp
//
//  Created by Ali Yussef on 01/12/2020.
//

import Foundation

enum ApiEndPoint: CustomStringConvertible {
    case bookedtourById(Int64)
    case bookedtour
    case categoryById(Int64)
    case category
    case contentById(Int64)
    case content
    case countryById(Int64)
    case country
    case forestById(Int64)
    case forest
    case wildlifeByForest(Int64)  //get wildlife of forest
    case treesByForest(Int64)  //get all trees of forest
    case imageById(Int64)
    case image
    case notifydeviceById(Int64)
    case notifydevice
    case orderById(Int64)
    case order
    case paymentStatus
    case productById(Int64)
    case product
    case settingById(Int64)
    case setting
    case telemetryById(Int64)
    case telemetry
    case tourById(Int64)
    case tour
    case treeById(Int64)
    case tree
    case trees(Int64)  ///api/v1/user/{id}/tree
    case treeImages(Int64)
    case personalize  ///api​/v1​/tree​/personalize
    case renewTree ///api/v1/tree/renew //Renew a tree with one year
    case initializeTree // /api/v1/tree/initialize // InitializeTree for the raspberry pi Values that need to be submitted to the py first are: - treeId Values that the pi needs to send are: - latitude - longitude
    case sequestration(Int64) ///api/v1/tree/{id}/sequestration
    case treesignById(Int64)
    case treesign
    case treesignByTree(Int64) ///api/v1/treesign/tree/{id}
    case treespeciesById(Int64)
    case treespecies
    case userById(Int64)
    case user
    case wildlifeById(Int64)
    case wildlife
    case forgetpassword
    case resetpassword
    
    var description: String {
        switch self {
            case .bookedtourById(let id):
                return "bookedtour/\(id)"
            case .bookedtour:
                return "bookedtour"
            case .categoryById(let id):
                return "category/\(id)"
            case .category:
                return "category"
            case .contentById(let id):
                return "content/\(id)"
            case .content:
                return "content"
            case .countryById(let id):
                return "country/\(id)"
            case .country:
                return "country"
            case .forestById(let id):
                return "forest/\(id)"
            case .forest:
                return "forest"
            case .imageById(let id):
                return "image/\(id)"
            case .image:
                return "image"
            case .notifydeviceById(let id):
                return "notifydevice/\(id)"
            case .notifydevice:
                return "notifydevice"
            case .orderById(let id):
                return "order/\(id)"
            case .order:
                return "order"
            case .productById(let id):
                return "product/\(id)"
            case .product:
                return "product"
            case .settingById(let id):
                return "setting/\(id)"
            case .setting:
                return "setting"
            case .telemetryById(let id):
                return "telemetry/\(id)"
            case .telemetry:
                return "telemetry"
            case .tourById(let id):
                return "tour/\(id)"
            case .tour:
                return "tour"
            case .treeById(let id):
                return "tree/\(id)"
            case .tree:
                return "tree"
            case .treesignById(let id):
                return "treesign/\(id)"
            case .treesign:
                return "treesign"
            case .treespeciesById(let id):
                return "treespecies/\(id)"
            case .treespecies:
                return "treespecies"
            case .userById(let id):
                return "user/\(id)"
            case .user:
                return "user"
            case .wildlifeById(let id):
                return "wildlife/\(id)"
            case .wildlife:
                return "wildlife"
            case .wildlifeByForest(let id):
                return "forest/\(id)/wildlife"
            case .treesByForest(let id):
                return "forest/\(id)/trees"
            case .paymentStatus:
                return "order/paymentStatus"
            case .treeImages(let id):
                return "tree/\(id)/image"
            case .personalize:
                return "tree/personalize"
            case .renewTree:
                return "tree/renew"
            case .initializeTree:
                return "tree/initialize"
            case .sequestration(let id):
                return "tree/\(id)/sequestration"
            case .treesignByTree(let id):
                return "treesign/tree/\(id)"
            case .trees(let id):
                return "user/\(id)/tree"
            case .forgetpassword:
                return "user/forgetpassword"
            case .resetpassword:
                return "user/resetpassword"
        }
    }
}
