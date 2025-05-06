import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'network_status_service.g.dart'; // Не забудьте сгенерировать

/// Сервис для отслеживания статуса сетевого подключения.
class NetworkStatusService {
  final Connectivity _connectivity = Connectivity();
  // Приватные поля с префиксом _
  StreamController<bool>? _controller;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription; // Тип подписки изменен на List<>
  bool _isDisposed = false;
  bool _currentStatus = true; // Предполагаем, что онлайн при старте

  NetworkStatusService() {
    print('[INFO] NetworkStatusService initialized.');
    // Инициализируем сразу или по первому запросу - можно выбрать
    // _ensureInitialized(); // Можно инициализировать здесь
  }

  // Инициализация потока и подписки
  void _ensureInitialized() {
    if (_controller == null && !_isDisposed) {
      print('[INFO] NetworkStatusService: Initializing status stream.');
      _controller = StreamController<bool>.broadcast();

      // Проверяем начальное состояние (возвращает List<>)
      _connectivity.checkConnectivity().then((resultList) {
        // Передаем список в _mapResultToOnlineStatus
        _currentStatus = _mapResultToOnlineStatus(resultList);
        if (!(_controller?.isClosed ?? true)) { // Проверка на null и закрытие
          _controller!.add(_currentStatus);
        }
      }).catchError((e) {
         print('[ERROR] NetworkStatusService: Error checking initial connectivity: $e');
         _currentStatus = false; // Считаем оффлайн при ошибке
         if (!(_controller?.isClosed ?? true)) {
           _controller!.add(_currentStatus);
         }
      });

      // Слушаем изменения (возвращает List<>)
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
        (resultList) {
          // Передаем список в _mapResultToOnlineStatus
          final newStatus = _mapResultToOnlineStatus(resultList);
          if (newStatus != _currentStatus && !(_controller?.isClosed ?? true)) {
            _currentStatus = newStatus;
            _controller!.add(_currentStatus);
            print("[INFO] Network status changed: ${_currentStatus ? 'Online' : 'Offline'}");
          }
        },
        onError: (e) {
           print('[ERROR] NetworkStatusService: Error listening to connectivity changes: $e');
           if (!_currentStatus && !(_controller?.isClosed ?? true)) { // Если уже были оффлайн, не меняем
              return;
           }
           _currentStatus = false; // Считаем оффлайн при ошибке
           if (!(_controller?.isClosed ?? true)) {
              _controller!.add(_currentStatus);
           }
        }
      );
    }
  }

  /// Поток, транслирующий изменения статуса сети (true = онлайн, false = оффлайн).
  Stream<bool> get onlineStatusStream {
    _ensureInitialized(); // Инициализируем при первом доступе к потоку
    // Возвращаем поток или поток с false, если сервис уже уничтожен
    return _controller?.stream ?? Stream<bool>.value(false).asBroadcastStream();
  }

  /// Асинхронно проверяет текущий статус сети.
  Future<bool> isOnline() async {
    try {
      // Проверяем явно каждый раз, чтобы получить самое актуальное состояние
      final resultList = await _connectivity.checkConnectivity();
      _currentStatus = _mapResultToOnlineStatus(resultList); // Обновляем внутренний статус
      return _currentStatus;
    } catch (e) {
       print('[ERROR] NetworkStatusService: Error checking connectivity: $e');
       _currentStatus = false; // Считаем оффлайн при ошибке
       return false;
    }
  }

  /// Преобразует результат Connectivity+ (список) в булево значение онлайн-статуса.
  bool _mapResultToOnlineStatus(List<ConnectivityResult> resultList) {
    // Считаем онлайн, если есть *хотя бы одно* из активных подключений
    return resultList.any((result) =>
        result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.ethernet ||
        result == ConnectivityResult.vpn);
    // ConnectivityResult.other и .none считаются оффлайн
  }

  /// Освобождает ресурсы (закрывает StreamController и отменяет подписку).
  void dispose() {
    if (!_isDisposed) {
      print('[INFO] NetworkStatusService disposing.');
      _isDisposed = true;
      _connectivitySubscription?.cancel();
      _controller?.close();
      _controller = null;
      _connectivitySubscription = null;
    }
  }
}

// Провайдер для NetworkStatusService
@Riverpod(keepAlive: true)
NetworkStatusService networkStatusService(Ref ref) { // Используем правильный тип Ref
  final service = NetworkStatusService();
  // Очищаем ресурсы при уничтожении провайдера
  ref.onDispose(() => service.dispose());
  return service;
}