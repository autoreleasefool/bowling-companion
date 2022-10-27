import ComposableArchitecture

public protocol BaseFormModel: Equatable {
	static var modelName: String { get }
	var name: String { get }
}

public protocol BaseFormState: Equatable {
	associatedtype Model: BaseFormModel

	var isSaveable: Bool { get }
	var isDeleteable: Bool { get }
	func model(fromExisting: Model?) -> Model
}

public struct BaseForm<Model: BaseFormModel, FormState: BaseFormState>: ReducerProtocol where Model == FormState.Model {
	public struct State: Equatable {
		public var mode: Mode
		public var isLoading = false
		public var alert: AlertState<AlertAction>?

		public let initialForm: FormState
		public var form: FormState

		public var hasChanges: Bool {
			form != initialForm
		}

		public var isSaveable: Bool {
			!isLoading && hasChanges && form.isSaveable
		}

		public init(mode: Mode, form: FormState) {
			self.mode = mode
			self.initialForm = form
			self.form = form
		}
	}

	public enum Mode: Equatable {
		case create
		case edit(Model)
	}

	public enum Action: Equatable {
		case saveButtonTapped
		case discardButtonTapped
		case deleteButtonTapped
		case saveResult(TaskResult<Model>)
		case deleteResult(TaskResult<Model>)
		case alert(AlertAction)
	}

	public init() {}

	@Dependency(\.formModelService) var formModelService

	public var body: some ReducerProtocol<State, Action> {
		Reduce { state, action in
			switch action {
			case .saveButtonTapped:
				guard state.isSaveable else { return .none }
				state.isLoading = true

				switch state.mode {
				case let .edit(original):
					let model = state.form.model(fromExisting: original)
					return .task {
						await .saveResult(TaskResult {
							try await formModelService.update(model)
							return model
						})
					}
				case .create:
					let model = state.form.model(fromExisting: nil)
					return .task {
						await .saveResult(TaskResult {
							try await formModelService.create(model)
							return model
						})
					}
				}

			case .saveResult(.failure):
				state.isLoading = false
				// TODO: show error
				return .none

			case .deleteButtonTapped:
				state.alert = state.deleteAlert
				return .none

			case .alert(.deleteButtonTapped):
				state.alert = nil
				guard case let .edit(model) = state.mode else { return .none }
				state.isLoading = true
				return .task {
					await .deleteResult(TaskResult {
						try await formModelService.delete(model)
						return model
					})
				}

			case .deleteResult(.failure):
				state.isLoading = false
				// TODO: show error
				return .none

			case .discardButtonTapped:
				state.alert = state.discardAlert
				return .none

			case .alert(.discardButtonTapped):
				state = .init(mode: state.mode, form: state.initialForm)
				return .none

			case .alert(.dismissed):
				state.alert = nil
				return .none

			case .saveResult(.success), .deleteResult(.success):
				return .none
			}
		}
	}
}
