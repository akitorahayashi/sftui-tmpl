# Project Overview
This project is an iOS application template built with SwiftUI. It is designed to provide a robust foundation for iOS development with a focus on automation, dependency injection, and a clear separation of concerns using the MVVM architecture. The project utilizes `xcodegen` for declarative project configuration, `just` for task management, and `fastlane` for CI/CD automation.

# Directory Structure
- `TemplateApp/`: Contains the main application source code, including Views, ViewModels, and Logic.
- `TemplateAppTests/`: Contains unit tests for testing individual components and logic.
- `TemplateAppIntgTests/`: Contains integration tests for verifying feature workflows using mock dependencies.
- `TemplateAppUITests/`: Contains UI tests for end-to-end verification of user interactions.
- `fastlane/`: Stores Fastlane configuration and automation scripts (`Fastfile`, `just/` modules).
- `justfile`: The entry point for project-specific command-line tasks.
- `project.envsubst.yml`: The template configuration file for `xcodegen` to generate the `.xcodeproj` file.
- `Mintfile`: Lists Swift command-line tool dependencies (e.g., SwiftLint, SwiftFormat, XcodeGen).
- `Gemfile`: Lists Ruby dependencies for Fastlane and other tools.

# Architecture & Implementation Details
- **Architecture Pattern**: MVVM (Model-View-ViewModel).
    - **Views**: SwiftUI views that observe `ObservableObject` ViewModels.
    - **ViewModels**: Manage state and business logic interactions, communicating with Logic layers via protocols.
    - **Logic Layer**: Encapsulated business logic defined by protocols (e.g., `CountLogicProtocol`) and implemented by concrete classes (e.g., `LiveCountLogic`).
- **Dependency Injection**:
    - Centralized `AppDependencies` container manages all app dependencies.
    - `AppDependencies.live()` creates the production dependency graph.
    - `AppDependencies.mock()` (Debug only) creates a graph with mock implementations for testing and SwiftUI Previews.
- **Concurrency**: Extensive use of Swift Concurrency (`async`/`await`, `@MainActor`, `Task`) for asynchronous operations.
- **Project Generation**:
    - The Xcode project file (`.xcodeproj`) is a build artifact generated from `project.envsubst.yml` via `xcodegen`.
    - `ENABLE_USER_SCRIPT_SANDBOXING` is set to "NO".
    - `SKIP_MACRO_VALIDATION` is set to "YES" to prevent build issues with macros.
- **Testing Strategy**:
    - **Unit Tests**: Focus on isolated logic validation.
    - **Integration Tests**: Verify feature scenarios using `AppDependencies.mock()` to inject controlled behavior.
    - **UI Tests**: Black-box testing of the application UI.

# Development Commands
- **Check Commands**:
    - Lint check: `just lint` (Runs SwiftFormat lint and SwiftLint strict mode)
    - Format code: `just format` (Applies SwiftFormat and SwiftLint fixes)
- **Test Commands**:
    - Run all tests: `just test`
    - Run unit tests: `just unit-test`
    - Run integration tests: `just intg-test`
    - Run UI tests: `just ui-test`
- **Setup & Build**:
    - Initialize environment: `just setup`
    - Generate Xcode project: `just gen-pj`
    - Boot development simulator: `just boot`
    - Boot test simulator: `just boot-test`

# Development Guidelines
- **Project Configuration**: Do not edit the `.xcodeproj` file manually. Always modify `project.envsubst.yml` and run `just gen-pj` to regenerate the project.
- **Simulator Workflow**: Use separate simulators for development and testing as defined in `.env` (`DEV_SIMULATOR_UDID` vs `TEST_SIMULATOR_UDID`) to enable parallel workflows.
- **Dependency Injection**: Always use the `AppDependencies` container to pass dependencies to Views and ViewModels. Avoid instantiating concrete logic classes directly within Views.
- **Mocking**: Define mock implementations within the `AppDependencies` extension (wrapped in `#if DEBUG`) or in test targets to ensure they are available for Previews and Tests.
- **Environment Variables**: Maintain local configuration (Team ID, Simulator UDIDs) in the `.env` file (use `.env.example` as a template).

# Documentation Rules
- Documentation must be written in a **declarative** style describing the *current state* of the system. Avoid **imperative** or *changelog-style* descriptions (e.g., do NOT write 'Removed X and added Y' or 'v5.1.2 changes...').
