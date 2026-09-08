---
name: mobile
description: Mobile development for React Native, Expo, Flutter, iOS, and Android — platform-scope decisions, navigation, atomic UI reuse, native APIs, permissions, storage, networking, performance, and app lifecycle. Use when creating, modifying, debugging, or reviewing mobile application code.
---

# Mobile Development Skill

Make the smallest correct change while respecting the project's existing mobile architecture, platform requirements, and conventions.

---

# Mobile-Specific Principles

- Check for an existing shared/atomic component before creating a new one — mobile UI should compose from the project's shared layer, not duplicate it per screen.
- Prefer the project's existing native-module/Expo wrappers over calling native APIs directly.
- Don't introduce a second navigation, state, or native-module library when one is already established.
- Don't add native dependencies, permissions, or build config changes without checking what's already declared.

General reuse, smallest-change, and no-unrelated-refactor rules are already covered by CLAUDE.md — this skill only adds what's specific to mobile.

---

# Trivial vs Non-Trivial

**Trivial** (styling tweak, copy change, prop addition, logic confined to one file): inspect the directly relevant file/component, follow its nearby patterns, make the smallest change, run minimal verification. Skip architecture discovery and platform-scope questions for these.

**Non-trivial** (permissions, native modules, navigation structure, lifecycle, background execution, anything cross-cutting): inspect relevant architecture and existing platform-handling patterns, briefly plan the approach, then implement and verify per platform actually touched.

---

# Platform Scope

Before implementing anything that may behave differently on iOS vs Android, classify the task:

- **Clearly cross-platform** (TS logic, data transforms, API calls, shared state, generic validation): proceed without asking.
- **Potentially platform-specific** (permissions, camera, microphone, notifications, biometrics, file system, keyboard, status bar, safe areas, deep linking, background execution, native modules, gestures, lifecycle, build config): if the user hasn't said whether it targets both platforms or one, ask:
  > Should this change apply to both iOS and Android, or only one platform?

Don't ask for the cross-platform case. Don't silently default to one platform for the ambiguous case.

---

# Cross-Platform Compatibility

When a change targets both platforms, don't assume identical behavior — check platform APIs, permissions, native config, keyboard/safe-area/lifecycle handling, and native-module compatibility. Prefer one shared implementation; branch only where platforms actually diverge. Never state both platforms were tested unless both were actually run.

---

# Platform-Specific Code

Branch only at the point of actual divergence, using the project's existing pattern:

- **React Native / Expo**: `Platform.select({ ios: ..., android: ... })` or `Platform.OS === 'ios'` for inline branches; `Component.ios.tsx` / `Component.android.tsx` for full file-level splits. Prefer an existing `expo-*` module (already cross-platform) over a raw native module.
- **Flutter**: `Platform.isIOS` / `Platform.isAndroid` for inline branches, or platform channels for native calls not covered by an existing plugin.

---

# Navigation, Native APIs, Performance, Lifecycle

- **Navigation**: follow the existing navigator/router setup; don't add a second navigation library.
- **Native APIs / storage / networking / permissions**: reuse the project's existing wrapped access (hooks/services) instead of calling native, storage, or network APIs directly from a component.
- **Performance**: virtualize long lists and avoid unnecessary re-renders; profile only when a real issue is reported, not preemptively.
- **App lifecycle**: check for existing foreground/background/AppState listeners before adding new ones.
