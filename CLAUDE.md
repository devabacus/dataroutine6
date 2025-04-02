# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build/Lint/Test Commands
- Run app: `flutter run`
- Run tests: `flutter test`
- Run single test: `flutter test test/path_to_test.dart`
- Generate code: `flutter pub run build_runner build --delete-conflicting-outputs`
- Watch code generation: `flutter pub run build_runner watch --delete-conflicting-outputs`
- Lint: `flutter analyze`

## Code Style Guidelines
- **Formatting**: Follow Dart style guide with 2-space indentation
- **Imports**: Order by dart, flutter, packages, then relative imports
- **State Management**: Use Riverpod (flutter_riverpod, riverpod_annotation)
- **Navigation**: Use GoRouter for routing
- **Models**: Use Freezed for immutable models, DTO pattern for data
- **Database**: Use Drift for local database access
- **Architecture**: Follow Clean Architecture with data/domain/presentation layers
- **Error Handling**: Use talker for logging, propagate errors to UI when appropriate
- **Testing**: Write unit tests for domain layer, widget tests for UI