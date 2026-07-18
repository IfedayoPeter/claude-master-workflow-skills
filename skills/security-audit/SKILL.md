---
name: security-audit
description: Use when auditing your own code or deployment for security vulnerabilities, hardening a service, or asked "is this secure" — authentication, authorization, injection, secrets, crypto, request forgery, uploads, dependencies, tenancy. Forces a category-by-category adversarial pass where every finding carries a concrete exploit scenario (attacker input → effect → gain), a severity rank, and the cheapest real fix; theoretical severity without an attack path is banned. For systems the user owns or is authorized to assess.
---

ROLE: You are auditing a system the user owns or is authorized to assess. The mindset is the
bug-hunt skill's, aimed at a different predator: for each surface, do not ask "does this look
secure?" — construct the concrete REQUEST an attacker would send and say what they gain. Only
if you genuinely cannot construct one may you move on. SCOPE: this skill audits and hardens the
user's own systems; it does not produce attack tooling or target third parties.

MANDATORY CHECKLIST — inspect each category explicitly; report "checked, nothing found" per
category rather than skipping:
1. AUTHENTICATION: password storage (adaptive hash — bcrypt/scrypt/argon2 — or it is a
   finding), token/session lifetime and revocation, JWT pitfalls (alg=none, HS/RS confusion,
   secrets in client code), missing lockout/rate limits on login and reset, credentials over
   plain HTTP.
2. AUTHORIZATION: for EVERY route/endpoint/handler, name who may call it. IDOR — change the id
   in the request: do you get someone else's record? Object-level checks missing behind
   role-level ones; role enforced only in the client; mass assignment/overposting reaching
   privileged fields.
3. INJECTION: string-built SQL/NoSQL queries; command execution with user input; path traversal
   through user-supplied filenames; template injection; XSS per output sink (reflected and
   stored — is encoding applied at THIS sink?); deserialization of untrusted data.
4. SECRETS & CONFIG: grep for hardcoded keys/connection strings/tokens (and check git history
   when in scope); secrets in logs, URLs, or error pages; verbose errors and debug endpoints
   reachable in production; permissive CORS; missing security headers; default credentials.
5. CRYPTO: home-rolled algorithms; ECB mode; static IVs or salts; MD5/SHA-1 where collision or
   speed matters; non-constant-time comparison of secrets; TLS verification disabled anywhere.
6. REQUEST FORGERY & FILES: server-side fetches of user-supplied URLs (SSRF — can it reach
   cloud metadata or internal hosts?); file uploads (type, size, path, and WHERE they are
   served from); XML external entities; open redirects; missing CSRF protection on
   cookie-authenticated state changes.
7. DEPENDENCIES & SURFACE: run the ecosystem's audit tool where available (npm audit, pip-audit,
   dotnet list package --vulnerable ...) and read the result; frameworks past end-of-life;
   management endpoints, debug ports, or admin panels exposed wider than needed.
8. TENANCY & DATA EXPOSURE (where multi-user/multi-tenant): is the tenant/user id ever taken
   from the client where the session should supply it? cross-tenant query paths; PII in logs,
   exports, and analytics.

ALSO: trace ONE complete attack path end-to-end for the most valuable asset (money, PII, admin
control): entry point → each check passed or absent → final impact. A chain proves the audit
walked the system; isolated findings alone do not.

OUTPUT: findings ranked by severity — CRITICAL / HIGH / MEDIUM / LOW, justified in one line as
impact × exploitability — each with file:line, the CONCRETE exploit scenario ("attacker sends X
→ system does Y → attacker gains Z"), and the cheapest real fix (prefer the framework's built-in
mechanism over custom middleware over rewrite). Observations without an attack path go in a
separate short list (max 3), labeled as observations, not findings. Fixes are implemented via
fix-design (failing test first — for security fixes that test is the exploit reproduced), and
the change closes with durability-check.
BANNED: "should be secure", "follows best practices" as a verdict, reciting category names
without checking them in THIS codebase, severity with no triggering input, fixes that amputate
the feature ("just remove uploads"), auditing systems the user does not own or operate.
