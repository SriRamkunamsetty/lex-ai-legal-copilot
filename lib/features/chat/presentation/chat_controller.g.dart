// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Manages document-grounded chat history, streaming responses, verification,
/// and failure recovery for the Ask Lex screen.

@ProviderFor(ChatController)
final chatControllerProvider = ChatControllerProvider._();

/// Manages document-grounded chat history, streaming responses, verification,
/// and failure recovery for the Ask Lex screen.
final class ChatControllerProvider
    extends $NotifierProvider<ChatController, ChatThreadState> {
  /// Manages document-grounded chat history, streaming responses, verification,
  /// and failure recovery for the Ask Lex screen.
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

String _$chatControllerHash() => r'96fe04e4958cc1563e18b742c60f2982bcd280ce';

/// Manages document-grounded chat history, streaming responses, verification,
/// and failure recovery for the Ask Lex screen.

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
