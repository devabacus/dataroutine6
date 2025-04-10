// test/tasks/presentation/common_widgets/entity_list_page_test.dart

import 'package:dataroutine6/features/tasks/domain/entities/category/category.dart';
import 'package:dataroutine6/features/tasks/presentation/common_widgets/entity_list_page.dart';
import 'package:dataroutine6/features/tasks/presentation/common_widgets/entity_list_page_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('EntityListPage отображает список элементов', (
    WidgetTester tester,
  ) async {
    // Создаем тестовые данные
    final categoryItems = [
      CategoryEntity(id: 1, title: 'Категория 1'),
      CategoryEntity(id: 2, title: 'Категория 2'),
    ];

    bool onItemTapCalled = false;
    bool onItemDeleteCalled = false;

    // Создаем конфигурацию для страницы списка
    final config = EntityListConfig<CategoryEntity>(
      title: 'Тестовый список',
      addButtonText: 'Добавить элемент',
      addRouteName: 'add_route',
      editRouteName: 'edit_route',
      dataProvider: AsyncValue.data(categoryItems),
      onItemTap: (item) {
        onItemTapCalled = true;
      },
      onItemDelete: (item) {
        onItemDeleteCalled = true;
      },
      itemBuilder: (context, item, _) => Text(item.title),
    );

    // Отрисовываем виджет
    await tester.pumpWidget(
      ProviderScope(child: MaterialApp(home: EntityListPage(config: config))),
    );

    // Ждем, пока виджет построится
    await tester.pumpAndSettle();

    // Проверяем заголовок
    expect(find.text('Тестовый список'), findsOneWidget);

    // Проверяем, что все элементы отображаются
    for (final category in categoryItems) {
      expect(find.text(category.title), findsOneWidget);
    }

    // Проверяем наличие кнопки добавления
    expect(find.text('Добавить элемент'), findsOneWidget);

    // Тестируем нажатие на элемент
    await tester.tap(find.text('Категория 1'));
    await tester.pumpAndSettle();
    expect(onItemTapCalled, true);

    //TODO нужно будет что-то сделать с удалением именно по одной кнопке
    // // Включаем режим удаления (обычно через долгое нажатие)
    // await tester.longPress(find.text('Категория 2'));
    // await tester.pumpAndSettle();

    // // Теперь должна появиться иконка удаления
    // final deleteIcon = find.byIcon(Icons.delete);
    // expect(deleteIcon, findsWidgets);

    // // Проверяем нажатие на кнопку удаления
    // await tester.tap(deleteIcon);
    // await tester.pumpAndSettle();
    // expect(onItemDeleteCalled, true);
  });

  testWidgets('EntityListPage отображает пустой список корректно', (
    WidgetTester tester,
  ) async {
    // Создаем конфигурацию с пустым списком
    final config = EntityListConfig<CategoryEntity>(
      title: 'Пустой список',
      addButtonText: 'Добавить элемент',
      addRouteName: 'add_route',
      editRouteName: 'edit_route',
      dataProvider: const AsyncValue.data([]),
      onItemTap: (_) {},
      itemBuilder: (context, item, _) => Text(item.title),
    );

    // Отрисовываем виджет
    await tester.pumpWidget(
      ProviderScope(child: MaterialApp(home: EntityListPage(config: config))),
    );

    await tester.pumpAndSettle();

    // Проверяем сообщение о пустом списке
    expect(find.text('Список пуст'), findsOneWidget);
  });

  testWidgets('EntityListPage отображает индикатор загрузки', (
    WidgetTester tester,
  ) async {
    // Создаем конфигурацию в состоянии загрузки
    final config = EntityListConfig<CategoryEntity>(
      title: 'Загрузка',
      addButtonText: 'Добавить элемент',
      addRouteName: 'add_route',
      editRouteName: 'edit_route',
      dataProvider: const AsyncValue.loading(),
      onItemTap: (_) {},
      itemBuilder: (context, item, _) => Text(item.title),
    );

    // Отрисовываем виджет
    await tester.pumpWidget(
      ProviderScope(child: MaterialApp(home: EntityListPage(config: config))),
    );

    // Проверяем наличие индикатора загрузки
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('EntityListPage отображает сообщение об ошибке', (
    WidgetTester tester,
  ) async {
    // Создаем конфигурацию с ошибкой
    final config = EntityListConfig<CategoryEntity>(
      title: 'Ошибка',
      addButtonText: 'Добавить элемент',
      addRouteName: 'add_route',
      editRouteName: 'edit_route',
      dataProvider: AsyncValue.error('Ошибка загрузки', StackTrace.current),
      onItemTap: (_) {},
      itemBuilder: (context, item, _) => Text(item.title),
    );

    // Отрисовываем виджет
    await tester.pumpWidget(
      ProviderScope(child: MaterialApp(home: EntityListPage(config: config))),
    );

    await tester.pumpAndSettle();

    // Проверяем сообщение об ошибке
    expect(find.text('Ошибка загрузки данных'), findsOneWidget);
  });
}
