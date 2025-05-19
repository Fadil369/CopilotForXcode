import Foundation
import SuggestionBasic

// SuggestionCacheManager is responsible for managing the lifecycle of code suggestion caches.
//
// Thread Safety:
// - SuggestionCache is NOT thread-safe. If you need to access SuggestionCacheManager from multiple threads,
//   you must wrap all calls with a serial DispatchQueue or other synchronization mechanism.
//
// Usage:
// - Use `cacheSuggestions` to store suggestions for a given file/content/cursor/context.
// - Use `getCachedSuggestions` to retrieve cached suggestions if available and valid.
// - Use `invalidateCache(for:)` to remove cache for a specific file.
// - Use `clearCache()` to remove all cached suggestions.
//
// Example (single-threaded):
//   let manager = SuggestionCacheManager()
//   manager.cacheSuggestions([...], content: ..., cursorPosition: ..., context: ..., filePath: ...)
//   let cached = manager.getCachedSuggestions(content: ..., cursorPosition: ..., context: ..., filePath: ...)
//
// Example (multi-threaded):
//   let queue = DispatchQueue(label: "SuggestionCacheQueue")
//   queue.sync { manager.cacheSuggestions([...], ...) }
//   queue.sync { let cached = manager.getCachedSuggestions(...) }
//
// Note: SuggestionCacheManager is designed for use within the Copilot for Xcode toolchain.

/// Manager for the suggestion cache
class SuggestionCacheManager {
    
    /// The underlying cache instance
    private let cache: SuggestionCache
    
    /// Initialize with a suggestion cache
    /// - Parameter cache: The cache to use
    init(cache: SuggestionCache) {
        self.cache = cache
    }
    
    /// Convenience initializer with a new SuggestionCache
    convenience init() {
        self.init(cache: SuggestionCache())
    }
    
    /// Store suggestions in the cache
    /// - Parameters:
    ///   - suggestions: The suggestions to cache
    ///   - content: The file content
    ///   - cursorPosition: The cursor position
    ///   - context: The context used for generating suggestions
    ///   - filePath: The file path
    func cacheSuggestions(
        _ suggestions: [CodeSuggestion],
        content: String,
        cursorPosition: CursorPosition,
        context: [String],
        filePath: String
    ) {
        cache.cacheSuggestions(
            suggestions,
            content: content,
            cursorPosition: cursorPosition,
            context: context,
            filePath: filePath
        )
    }
    
    /// Get cached suggestions if available and still valid
    /// - Parameters:
    ///   - content: The current file content
    ///   - cursorPosition: The current cursor position
    ///   - context: The current context
    ///   - filePath: The file path
    /// - Returns: Cached suggestions if available, nil otherwise
    func getCachedSuggestions(
        content: String,
        cursorPosition: CursorPosition,
        context: [String],
        filePath: String
    ) -> [CodeSuggestion]? {
        cache.getCachedSuggestions(
            content: content,
            cursorPosition: cursorPosition,
            context: context,
            filePath: filePath
        )
    }
    
    /// Invalidate cache for a specific file
    /// - Parameter filePath: The file path to invalidate
    func invalidateCache(for filePath: String) {
        cache.invalidateCache(for: filePath)
    }
    
    /// Clear the entire cache
    func clearCache() {
        cache.clearCache()
    }
}
