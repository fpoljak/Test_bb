platform :ios, '13.0'

def shared_pods
    pod 'Alamofire'
    pod 'RxSwift'
    pod 'RxCocoa'
end

def testing_pods
    pod 'RxTest'
    pod 'RxBlocking'
    pod 'OHHTTPStubs'
end

target 'Test_bb' do
    use_frameworks!
    shared_pods
end

target 'Test_bbTests' do
    use_frameworks!
    shared_pods
    testing_pods
end
