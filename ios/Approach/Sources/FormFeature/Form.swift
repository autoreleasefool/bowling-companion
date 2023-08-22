import ComposableArchitecture
import ErrorsFeature
import FeatureActionLibrary
import StringsLibrary

public protocol FormRecord: Identifiable, Equatable {
	static var isSaveableWithoutChanges: Bool { get }
	var name: String { get }
	var isSaveable: Bool { get }
	var saveButtonText: String { get }
}

public protocol CreateableRecord: FormRecord {
	static var modelName: String { get }
}

public protocol EditableRecord: FormRecord {
	var isDeleteable: Bool { get }
}

extension FormRecord {
	public var saveButtonText: String {
		Strings.Action.save
	}

	public static var isSaveableWithoutChanges: Bool {
		false
	}
}

public struct Form<
	New: CreateableRecord,
	Existing: EditableRecord
>: Reducer where New.ID == Existing.ID {
	public enum Value: Equatable {
		case create(New)
		case edit(Existing)

		public var record: (any FormRecord)? {
			switch self {
			case let.create(new): return new
			case let .edit(existing): return existing
			}
		}
	}

	public struct State: Equatable {
		public let modelName: String
		public var isLoading = false
		@PresentationState public var alert: AlertState<AlertAction>?

		public let initialValue: Value
		public var value: Value

		public var errors: Errors<ErrorID>.State = .init()

		public var hasChanges: Bool {
			initialValue != value
		}

		public var isSaveableWithoutChanges: Bool {
			switch value {
			case .create: return New.isSaveableWithoutChanges
			case .edit: return Existing.isSaveableWithoutChanges
			}
		}

		public var isSaveable: Bool {
			!isLoading && (hasChanges || isSaveableWithoutChanges) && (value.record?.isSaveable ?? false)
		}

		public var isDeleteable: Bool {
			switch value {
			case .create: return false
			case let .edit(existing): return existing.isDeleteable
			}
		}

		public var saveButtonText: String {
			value.record?.saveButtonText ?? Strings.Action.save
		}

		public init(initialValue: Value, currentValue: Value, modelName: String = New.modelName) {
			self.initialValue = initialValue
			self.value = currentValue
			self.modelName = modelName
		}
	}

	public enum Action: Equatable {
		public enum ViewAction: Equatable {
			case didTapSaveButton
			case didTapDiscardButton
			case didTapDeleteButton
			case alert(PresentationAction<AlertAction>)
		}

		public enum InternalAction: Equatable {
			case errors(Errors<ErrorID>.Action)
		}

		public enum DelegateAction: Equatable {
			case didCreate(TaskResult<New>)
			case didUpdate(TaskResult<Existing>)
			case didDelete(TaskResult<Existing>)
			case didFinishCreating(New)
			case didFinishUpdating(Existing)
			case didFinishDeleting(Existing)
			case didDiscard
		}

		case view(ViewAction)
		case delegate(DelegateAction)
		case `internal`(InternalAction)
	}

	public enum AlertAction: Equatable {
		case didTapDeleteButton
		case didTapDiscardButton
		case didTapCancelButton
	}

	public enum ErrorID: Hashable {
		case failedToCreate
		case failedToUpdate
		case failedToDelete
	}

	public init() {}

	@Dependency(\.records) var records

	public var body: some ReducerOf<Self> {
		Scope(state: \.errors, action: /Action.internal..Action.InternalAction.errors) {
			Errors()
		}

		Reduce<State, Action> { state, action in
			switch action {

			case let .view(viewAction):
				switch viewAction {
				case .didTapSaveButton:
					guard state.isSaveable else { return .none }
					state.isLoading = true

					switch state.value {
					case let .edit(existing):
						return .run { send in
							await send(.delegate(.didUpdate(TaskResult {
								try await records.update?(existing)
								return existing
							})))
						}

					case let .create(new):
						return .run { send in
							await send(.delegate(.didCreate(TaskResult {
								try await records.create?(new)
								return new
							})))
						}
					}

				case .didTapDeleteButton:
					guard case let .edit(existing) = state.initialValue, state.isDeleteable else { return .none }
					state.alert = AlertState {
						TextState(Strings.Form.Prompt.delete(existing.name))
					} actions: {
						ButtonState(role: .destructive, action: .didTapDeleteButton) { TextState(Strings.Action.delete) }
						ButtonState(role: .cancel, action: .didTapCancelButton) { TextState(Strings.Action.cancel) }
					}
					return .none

				case .didTapDiscardButton:
					guard state.hasChanges else { return .none }
					state.alert = AlertState {
						TextState(Strings.Form.Prompt.discardChanges)
					} actions: {
						ButtonState(role: .destructive, action: .didTapDiscardButton) { TextState(Strings.Action.discard) }
						ButtonState(role: .cancel, action: .didTapCancelButton) { TextState(Strings.Action.cancel) }
					}
					return .none

				case let .alert(alertAction):
					switch alertAction {
					case .presented(.didTapDeleteButton):
						guard case let .edit(record) = state.initialValue else { return .none }
						state.isLoading = true
						return .run { send in
							await send(.delegate(.didDelete(TaskResult {
								try await records.delete?(record.id)
								return record
							})))
						}

					case .presented(.didTapDiscardButton):
						state.discard()
						return .send(.delegate(.didDiscard))

					case .presented(.didTapCancelButton), .dismiss:
						return .none
					}
				}

			case let .internal(internalAction):
				switch internalAction {
				case let .errors(.delegate(delegateAction)):
					switch delegateAction {
					case .never:
						return .none
					}

				case .errors(.internal), .errors(.view):
					return .none
				}

			case .delegate:
				return .none
			}
		}
		.ifLet(\.$alert, action: /Action.view..Action.ViewAction.alert)
	}
}

extension Form.State {
	mutating func discard() {
		self = .init(initialValue: initialValue, currentValue: initialValue)
	}

	public mutating func didFinishCreating(_ record: TaskResult<New>) -> Effect<Form.Action> {
		isLoading = false
		switch record {
		case let .success(new):
			return .send(.delegate(.didFinishCreating(new)))
		case let .failure(error):
			return errors
				.enqueue(.failedToCreate, thrownError: error, toastMessage: Strings.Error.Toast.itemNotCreated(New.modelName))
				.map { .internal(.errors($0)) }
		}
	}

	public mutating func didFinishUpdating(_ record: TaskResult<Existing>) -> Effect<Form.Action> {
		isLoading = false
		switch record {
		case let .success(existing):
			return .send(.delegate(.didFinishUpdating(existing)))
		case let .failure(error):
			return errors
				.enqueue(.failedToUpdate, thrownError: error, toastMessage: Strings.Error.Toast.itemNotUpdated(New.modelName))
				.map { .internal(.errors($0)) }
		}
	}

	public mutating func didFinishDeleting(_ record: TaskResult<Existing>) -> Effect<Form.Action> {
		isLoading = false
		switch record {
		case let .success(existing):
			return .send(.delegate(.didFinishDeleting(existing)))
		case let .failure(error):
			return errors
				.enqueue(.failedToDelete, thrownError: error, toastMessage: Strings.Error.Toast.failedToDelete)
				.map { .internal(.errors($0)) }
		}
	}
}