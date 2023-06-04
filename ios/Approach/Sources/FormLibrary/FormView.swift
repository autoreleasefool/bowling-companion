import ComposableArchitecture
import FeatureActionLibrary
import StringsLibrary
import SwiftUI
import ViewsLibrary

public struct FormView<
	New: CreateableRecord,
	Existing: EditableRecord,
	Content: View
>: View where New.ID == Existing.ID {
	let store: StoreOf<Form<New, Existing>>
	let content: () -> Content

	struct ViewState: Equatable {
		let title: String
		let isLoading: Bool
		let isSaveable: Bool
		let isDeleteable: Bool
		let isDiscardable: Bool
		let isDismissable: Bool
		let saveButtonText: String
		let alert: AlertState<Form<New, Existing>.AlertAction>?

		init(state: Form<New, Existing>.State) {
			self.isLoading = state.isLoading
			self.isSaveable = state.isSaveable
			self.isDiscardable = state.hasChanges
			self.isDeleteable = state.isDeleteable
			self.isDismissable = !state.hasChanges
			self.alert = state.alert
			self.saveButtonText = state.saveButtonText

			switch state.initialValue {
			case .create:
				self.title = Strings.Form.Prompt.add(state.modelName)
			case let .edit(existing):
				self.title = Strings.Form.Prompt.edit(existing.name)
			}
		}
	}

	enum ViewAction {
		case didTapSaveButton
		case didTapDeleteButton
		case didTapDiscardButton
	}

	public init(
		store: StoreOf<Form<New, Existing>>,
		@ViewBuilder content: @escaping () -> Content
	) {
		self.store = store
		self.content = content
	}

	public var body: some View {
		WithViewStore(store, observe: ViewState.init, send: map(viewAction:)) { viewStore in
			SwiftUI.Form {
				content()
					.disabled(viewStore.isLoading)

				if viewStore.isDeleteable {
					Section {
						DeleteButton { viewStore.send(.didTapDeleteButton) }
					}
					.disabled(viewStore.isLoading)
				}
			}
			.navigationTitle(viewStore.title)
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button(viewStore.saveButtonText) { viewStore.send(.didTapSaveButton) }
						.disabled(!viewStore.isSaveable)
				}

				if viewStore.isDiscardable {
					ToolbarItem(placement: .navigationBarLeading) {
						Button(Strings.Action.discard) { viewStore.send(.didTapDiscardButton) }
					}
				}
			}
			.alert(store: store.scope(state: \.$alert, action: { .view(.alert($0)) }))
		}
	}

	private func map(viewAction: ViewAction) -> Form<New, Existing>.Action {
		switch viewAction {
		case .didTapSaveButton:
			return .view(.didTapSaveButton)
		case .didTapDeleteButton:
			return .view(.didTapDeleteButton)
		case .didTapDiscardButton:
			return .view(.didTapDiscardButton)
		}
	}
}