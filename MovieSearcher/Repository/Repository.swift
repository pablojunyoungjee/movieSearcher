//
//  Repository.swift
//  MovieSearcher
//
//  Created by pablo.jee on 2020/10/10.
//

import Foundation
import RxSwift
import Alamofire

public enum API { }

extension API {
    public enum MovieData: HttpAPI {
        
        case movieList
        case movieImage
        
        public var api: String {
            switch self {
            case .movieList:
                return "/movie.json"
            case .movieImage:
                return "/image"
            }
        }
        
        public var method: HttpMethodTypes {
            switch self {
            case .movieList:
                return .get
            case .movieImage:
                return .get
            }
        }
    }
}

public enum HttpMethodTypes {
    case get
    case post
    case put
    case patch
    case delete
}

protocol HttpAPI {
    var api: String { get }
    var method: HttpMethodTypes { get }
    
    func request(param: Parameters?) -> Observable<Data>
}

extension HttpAPI {
    
    var CLIENT_ID: String {
        return "Ey2n7kVzVmCNCFkhzPXu"
    }
    
    var CLIENT_SECRET: String {
        return "bW29e_sxmE"
    }
    
    var httpMethod: HTTPMethod {
        switch self.method {
        case .get:
            return .get
        case .post:
            return .post
        case .put:
            return .put
        case .patch:
            return .patch
        case .delete:
            return .delete
        }
    }
    
    func apiUrl() -> String {
        return "https://openapi.naver.com/v1/search\(api)"
    }
    
    //TODO: Param Set
    public func request(param: Parameters?) -> Observable<Data> {
        
        let url = self.apiUrl()
        let method = self.httpMethod
        let encoding: ParameterEncoding = self.getEncoding(method: method)
        let httpHeader: HTTPHeaders = self.getHeader()
        
        return Observable.create { emitter in
            let request = AlamofireAPI.requestManager.request(url,
                                                              method: method,
                                                              parameters: param,
                                                              encoding: encoding,
                                                              headers: httpHeader,
                                                              interceptor: nil,
                                                              requestModifier: nil)
                .response { (dataResponse) in
                    guard let data = dataResponse.data else { return emitter.on(.error(NSError(domain: "errorerrorerror", code: 404, userInfo: nil))) }
                    emitter.on(.next(data))
            }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    internal func getHeader() -> HTTPHeaders {
        return ["X-Naver-Client-Id": self.CLIENT_ID, "X-Naver-Client-Secret": self.CLIENT_SECRET]
    }
    
    internal func getEncoding(method: HTTPMethod) -> ParameterEncoding {
        switch method {
        case .post,
             .put,
             .patch:
            return JSONEncoding.default
        default:
            return URLEncoding.queryString
        }
    }
}

internal struct AlamofireAPI {

    struct NetworkRetrier: RequestInterceptor {
        func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
            
            if request.task?.response == nil {
                completion(.retryWithDelay(3))
                if request.retryCount == 3 {
                    completion(.doNotRetryWithError(error))
                }
            } else {
                completion(.doNotRetryWithError(error))
            }
        }
    }
    
    static let requestManager: Alamofire.Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.requestCachePolicy = .reloadIgnoringCacheData
        
        let retrier = NetworkRetrier()
        
        let session = Session(configuration: configuration, delegate: SessionDelegate(), interceptor: retrier)
        return session
    }()
    
}
