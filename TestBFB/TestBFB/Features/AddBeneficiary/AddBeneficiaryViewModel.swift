import Foundation
import Combine

@Observable
class AddBeneficiaryViewModel {
    var iban = "" {
        didSet {
            ibanPublisher.send(iban)
        }
    }
    var isOwner = false
    var beneficiaryName = "" {
        didSet {
            beneficiaryNamePublisher.send(beneficiaryName)
        }
    }
    var accountLabel = "" {
        didSet {
            accountLabelPublisher.send(accountLabel)
        }
    }
    var isIBANValid = false
    var isValid = false
    
    @ObservationIgnored private var cancellables = Set<AnyCancellable>()
    
    @ObservationIgnored private let ibanPublisher = PassthroughSubject<String, Never>()
    @ObservationIgnored private let beneficiaryNamePublisher = PassthroughSubject<String, Never>()
    @ObservationIgnored private let accountLabelPublisher = PassthroughSubject<String, Never>()
    
    private var isIBANValidPublisher: AnyPublisher<Bool, Never> {
        ibanPublisher
          .map { iban in
              return !iban.isEmpty
          }
          .eraseToAnyPublisher()
    }
    
    private var isBeneficiaryNameValidPublisher: AnyPublisher<Bool, Never> {
        beneficiaryNamePublisher
          .map { beneficiaryName in
              return !beneficiaryName.isEmpty
          }
          .eraseToAnyPublisher()
    }
    
    private var isAccountLabelValidPublisher: AnyPublisher<Bool, Never> {
        accountLabelPublisher
          .map { accountLabel in
              return !accountLabel.isEmpty
          }
          .eraseToAnyPublisher()
    }
    
    private var isFormValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3(isIBANValidPublisher, isAccountLabelValidPublisher, isBeneficiaryNameValidPublisher)
          .map { ibanIsValid, accountLabelIsValid, beneficiaryNameIsValid in
            return ibanIsValid && accountLabelIsValid && beneficiaryNameIsValid
          }
        .eraseToAnyPublisher()
    }
    
    init() {
        subscribeToIBANValid()
        subscribeToIsFormValid()
    }
    
    public func addBenificiary() {
        // Call the model layer to execure the process
    }
    
    private func subscribeToIBANValid() {
        isIBANValidPublisher
            .assign(to: \.isIBANValid, on: self)
            .store(in: &cancellables)
    }
    
    private func subscribeToIsFormValid() {
        isFormValidPublisher
            .assign(to: \.isValid, on: self)
            .store(in: &cancellables)
    }
    
}
