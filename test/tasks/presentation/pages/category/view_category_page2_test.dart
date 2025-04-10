// test/features/tasks/presentation/pages/category/view_category_page_test.dart

import 'package:dataroutine6/features/tasks/domain/entities/category/category.dart';
import 'package:dataroutine6/features/tasks/domain/providers/category/category_usecase_providers.dart';
import 'package:dataroutine6/features/tasks/domain/usecases/category/get_all.dart';
import 'package:dataroutine6/features/tasks/presentation/pages/category/view_category_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../providers/category/category_state_providers_test.mocks.dart';

// Генерируем мок для юзкейса
@GenerateMocks([GetCategoriesUseCase])
void main() {
  late MockGetCategoriesUseCase mockGetCategoriesUseCase;

  setUp(() {
    mockGetCategoriesUseCase = MockGetCategoriesUseCase();
  });

  testWidgets('ViewCategoryPage отображает список категорий', (WidgetTester tester) async {
    // Подготавливаем тестовые данные
    final categories = [
      CategoryEntity(id: 1, title: 'Категория 1'),
      CategoryEntity(id: 2, title: 'Категория 2'),
    ];

    // Настраиваем поведение мока
    when(mockGetCategoriesUseCase()).thenAnswer((_) async => categories);
    
    // Оборачиваем тестируемый виджет в ProviderScope с моками
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // Переопределяем провайдер юзкейса нашим моком
          getCategoriesUseCaseProvider.overrideWithValue(mockGetCategoriesUseCase),
        ],
        child: MaterialApp(
          home: ViewCategoryPage(isFromTask: "0"),
        ),
      ),
    );
    
    // Сначала может показываться загрузка, поэтому нужен дополнительный pump
    await tester.pumpAndSettle();
    
    // Проверяем, что категории правильно отображаются
    expect(find.text('Категория 1'), findsOneWidget);
    expect(find.text('Категория 2'), findsOneWidget);
    
    // Проверяем другие UI элементы
    expect(find.text('Категории'), findsOneWidget);
    expect(find.text('Добавить категорию'), findsOneWidget);
    
    // Проверяем, что наш мок был вызван
    verify(mockGetCategoriesUseCase()).called(1);
  });
}