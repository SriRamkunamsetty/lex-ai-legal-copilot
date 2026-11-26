// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the encrypted [ChatRepository] storing persistent threads/messages.

@ProviderFor(chatRepository)
final chatRepositoryProvider = ChatRepositoryProvider._();

/// Provides the encrypted [ChatRepository] storing persistent threads/messages.

final class ChatRepositoryProvider
    extends $FunctionalProvider<ChatRepository, ChatRepository, ChatRepository>
    with $Provider<ChatRepository> {
  /// Provides the encrypted [ChatRepository] storing persistent threads/messages.
  ChatRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatRepositoryHash();

  @$internal
  @override
  $ProviderElement<ChatRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ChatRepository create(Ref ref) {
    return chatRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatRepository>(value),
    );
  }
}

String _$chatRepositoryHash() => r'4bfec5d01fd809cafa1f8b0793a89d2d59069a8c';

/// Manages document-grounded chat history, encrypted SQLite persistence,
/// explicit cloud escalation consent, streaming responses, and verification.

@ProviderFor(ChatController)
final chatControllerProvider = ChatControllerProvider._();

/// Manages document-grounded chat history, encrypted SQLite persistence,
/// explicit cloud escalation consent, streaming responses, and verification.
final class ChatControllerProvider
    extends $NotifierProvider<ChatController, ChatThreadState> {
  /// Manages document-grounded chat history, encrypted SQLite persistence,
  /// explicit cloud escalation consent, streaming responses, and verification.
  ChatControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatControllerHash();

  @$internal
  @override
  ChatController create() => ChatController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ChatThreadState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ChatThreadState>(value),
    );
  }
}

String _$chatControllerHash() => r'9261633f98e094ec7fc22412eaa5a12a1320176a';

/// Manages document-grounded chat history, encrypted SQLite persistence,
/// explicit cloud escalation consent, streaming responses, and verification.

abstract class _$ChatController extends $Notifier<ChatThreadState> {
  ChatThreadState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ChatThreadState, ChatThreadState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ChatThreadState, ChatThreadState>,
              ChatThreadState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
