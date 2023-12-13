import AddressLookupServiceInterface
import AnalyticsServiceInterface
import ComposableArchitecture
import FeatureActionLibrary
import Foundation
import LocationsRepositoryInterface
import ModelsLibrary
import StringsLibrary

@Reducer
public struct AddressLookup: Reducer {
	public struct State: Equatable {
		@BindingState public var query: String
		public var results: IdentifiedArrayOf<AddressLookupResult> = []

		public var isLoadingAddress = false
		public var loadingAddressError: String?
		public var loadingResultsError: String?
		public var lookUpResult: Location.Edit?

		public init(initialQuery: String) {
			self.query = initialQuery
		}
	}

	public enum Action: FeatureAction {
		@CasePathable public enum ViewAction: BindableAction {
			case onAppear
			case didFirstAppear
			case didTapCancelButton
			case didTapResult(AddressLookupResult.ID)
			case binding(BindingAction<State>)
		}
		@CasePathable public enum DelegateAction { case doNothing }
		@CasePathable public enum InternalAction {
			case didReceiveResults(Result<[AddressLookupResult], Error>)
			case didLoadAddress(Result<Location.Edit, Error>)
		}

		case view(ViewAction)
		case delegate(DelegateAction)
		case `internal`(InternalAction)
	}

	enum SearchID { case lookup }
	enum LookupError: Error, LocalizedError {
		case addressNotFound

		public var errorDescription: String? {
			switch self {
			case .addressNotFound: return Strings.Address.Error.notFound
			}
		}
	}

	public init() {}

	@Dependency(\.addressLookup) var addressLookup
	@Dependency(\.dismiss) var dismiss

	public var body: some ReducerOf<Self> {
		BindingReducer(action: \.view)

		Reduce<State, Action> { state, action in
			switch action {
			case let .view(viewAction):
				switch viewAction {
				case .onAppear:
					return .none

				case .didFirstAppear:
					return .merge(
						.run { send in
							for try await results in await addressLookup.beginSearch(SearchID.lookup) {
								await send(.internal(.didReceiveResults(.success(results))))
							}
						} catch: { error, send in
							await send(.internal(.didReceiveResults(.failure(error))))
						},
						.run { [query = state.query] _ in
							guard !query.isEmpty else { return }
							await addressLookup.updateSearchQuery(SearchID.lookup, query)
						}
					)

				case .didTapCancelButton:
					return .run { _ in await dismiss() }

				case let .didTapResult(id):
					guard let address = state.results[id: id] else { return .none }
					state.isLoadingAddress = true
					return .run { send in
						await send(.internal(.didLoadAddress(Result {
							guard let location = try await addressLookup.lookUpAddress(address) else {
								throw LookupError.addressNotFound
							}

							return .init(
								id: location.id,
								title: location.title,
								subtitle: location.subtitle,
								coordinate: location.coordinate
							)
						})))
					}

				case .binding(\.$query):
					state.loadingAddressError = nil
					state.loadingResultsError = nil
					return .run { [query = state.query] _ in
						await addressLookup.updateSearchQuery(SearchID.lookup, query)
					}

				case .binding:
					return .none
				}

			case let .internal(internalAction):
				switch internalAction {
				case let .didReceiveResults(.success(results)):
					state.results = .init(uniqueElements: results)
					return .none

				case let .didReceiveResults(.failure(error)):
					state.loadingResultsError = error.localizedDescription
					return .none

				case let .didLoadAddress(.success(address)):
					state.lookUpResult = address
					return .run { _ in await dismiss() }

				case let .didLoadAddress(.failure(error)):
					state.isLoadingAddress = false
					state.loadingAddressError = error.localizedDescription
					return .none
				}

			case .delegate:
				return .none
			}
		}

		BreadcrumbReducer<State, Action> { _, action in
			switch action {
			case .view(.onAppear): return .navigationBreadcrumb(type(of: self))
			default: return nil
			}
		}
	}
}
