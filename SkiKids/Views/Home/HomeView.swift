import SwiftUI
import SwiftData

struct HomeView: View {
    @Query(sort: \Child.createdAt, order: .reverse) private var children: [Child]
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = ChildViewModel()
    @State private var showingAddChild = false
    @State private var selectedChild: Child?
    @State private var childToDelete: Child?
    @State private var showingDeleteAlert = false
    @State private var showingSettings = false

    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background.ignoresSafeArea()

                if children.isEmpty {
                    emptyStateView
                } else {
                    List {
                        ForEach(children) { child in
                            NavigationLink(destination: childDestination(for: child)) {
                                ChildCardView(child: child) {
                                    viewModel.deleteChild(child, from: modelContext)
                                }
                            }
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    childToDelete = child
                                    showingDeleteAlert = true
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
            }
            .alert("Delete profile?", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    if let child = childToDelete {
                        viewModel.deleteChild(child, from: modelContext)
                        childToDelete = nil
                    }
                }
            } message: {
                if let child = childToDelete {
                    Text("This will permanently remove \(child.name.isEmpty ? "this profile" : child.name) and all saved measurements.")
                }
            }
            .navigationTitle("My Kids")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.body)
                            .foregroundStyle(AppColors.textSecondary)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddChild = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(AppColors.accent)
                    }
                }
            }
            .sheet(isPresented: $showingAddChild) {
                CalculatorFormView(existingChild: nil)
            }
            .sheet(isPresented: $showingSettings) {
                AppearanceSettingsView()
            }
        }
    }

    @ViewBuilder
    private func childDestination(for child: Child) -> some View {
        ChildResultsView(child: child)
    }

    private var emptyStateView: some View {
        VStack(spacing: 24) {
            Image(systemName: "figure.skiing.downhill")
                .font(.system(size: 72))
                .foregroundStyle(
                    LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            VStack(spacing: 8) {
                Text("No Profiles Yet")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(AppColors.textPrimary)

                Text("Add your first child to get personalized ski equipment recommendations.")
                    .font(.body)
                    .foregroundStyle(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }

            Button {
                showingAddChild = true
            } label: {
                Label("Add Child Profile", systemImage: "plus")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [AppColors.accent, AppColors.accent.opacity(0.85)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .padding(.horizontal, 40)
        }
    }
}
