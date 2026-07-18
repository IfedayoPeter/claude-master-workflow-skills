---
name: saaskit-creation
description: Use when turning an existing single-tenant application into a multi-tenant SaaS, or standing up a new SaaS from scratch — any stack, any cloud. Forces the decisions that make or break a SaaS in order: tenancy and data-isolation model, a control plane separate from the product app, the sign-up/onboarding and provisioning lifecycle AND its mirror deprovisioning/purge lifecycle, tenant-scoped identity and RBAC, per-tenant settings, a billing/marketplace hook, and fail-closed tenant resolution. Every isolation boundary must be proven, not assumed. Uses the Azure SaaS Dev Kit (control plane) plus a product app made multi-tenant as the worked reference implementation, but the procedure is stack-agnostic.
---

ROLE: You are converting an app into a SaaS (or building one greenfield). A SaaS is not "add a
tenantId column" — it is a control plane that manages tenants and a product plane that serves them,
with a proven isolation boundary between tenants. The single worst failure is a cross-tenant data
leak, so isolation is designed first and proven, never assumed. Decisions are DECIDED with the user
at gates, not deferred into code. NO double dashes in any generated file or doc: use a colon,
semicolon, comma, or a hyphen inside a compound word. REFERENCE IMPLEMENTATION (one concrete path,
not the only one): the Azure SaaS Dev Kit as the control plane (sign-up admin, admin/tenant
service, permissions, identity via an external-ID provider) integrated with a product app made
multi-tenant (tenant catalog, tid-from-token resolution, per-tenant database, provisioning and
deprovisioning). Map every phase below to the target's actual stack.

PHASE 0 — CLASSIFY & GATE (decide before any code).
1. State what exists: is this an EXISTING app being converted (keep its stack and conventions) or
   GREENFIELD? Name the stack, the data store, and the current auth. An existing app keeps its
   layering and response conventions — do not re-architect it under cover of "SaaS-ifying".
2. DECIDE THE TENANCY MODEL with the user (this drives everything downstream):
   - Database-per-tenant (strongest isolation, per-tenant cost/ops, easy per-tenant restore/delete)
   - Schema-per-tenant (middle ground)
   - Shared schema with a tenant discriminator (cheapest, isolation rides entirely on query
     filters — highest leak risk, needs the most defensive rigor)
   Recommend one for the target and get explicit approval. This is a GATE.
3. DECIDE THE ISOLATION ENFORCEMENT POINT: connection-level (per-tenant connection string/DB — the
   filter cannot be forgotten) vs query-level (a global filter every query must carry). Prefer the
   enforcement the developer CANNOT bypass by writing a normal query.

PHASE 1 — CONTROL PLANE vs PRODUCT PLANE (the split).
4. Separate the two planes explicitly:
   - CONTROL PLANE: tenant sign-up/onboarding, tenant catalog (the authoritative tenant → route →
     database/subscription record), user↔tenant membership, subscription/billing state, and the
     provisioning orchestration. In the reference impl this is the ASDK admin + sign-up services.
   - PRODUCT PLANE: the app itself, now tenant-aware. It does NOT own the tenant list; it RESOLVES
     the current tenant and serves that tenant's data.
5. Define how the product plane learns the current tenant: a tenant id (tid) travels in the auth
   token; the product resolves tid → tenant-catalog entry (route, database, subscription status,
   active flag) by calling the control plane, memoized per request, cached with a short TTL. No
   per-tenant table of connection secrets in the product app.

PHASE 2 — IDENTITY, MEMBERSHIP, RBAC.
6. Tenant-scoped identity: a user authenticates once (external-ID / OIDC provider) and is a member
   of one or more tenants; the token carries the tid for the active tenant. Design invites and
   first-sign-in (a user invited to a tenant gets the right membership + role on first login).
7. RBAC: define the role catalog (e.g. Admin, plus domain roles) and a permissions feed the
   frontend can read (an endpoint returning the current user's effective permissions), so the UI
   shows only what the role allows and the API enforces it server-side regardless.

PHASE 3 — PROVISIONING LIFECYCLE (onboarding a tenant).
8. Design the provision seam end to end: control-plane wizard creates the tenant (name + route,
   no DB/password fields) → activation computes the database/schema name and calls a product-plane
   provision endpoint (service-to-service, app-only auth, with retry) → the product creates the
   store if absent, runs migrations, seeds reference data, and records the tenant config → returns
   success. Make it IDEMPOTENT: re-running provision with the same inputs is a no-op success, no
   duplicate rows, no error (activation retries).
9. USE MANAGED IDENTITY / NO SECRETS where the platform allows: the product connects to the tenant
   store via a managed identity, not a per-tenant password in a vault. If a secret truly must
   exist, say so explicitly and scope it; "no DB secret created" is the target.

PHASE 4 — DEPROVISION / UNSUBSCRIBE / PURGE LIFECYCLE (the mirror — usually forgotten).
10. Design the reverse path with equal care: subscription cancelled or tenant deleted → export/
    archive the tenant's data (with a parameterized retention/expiry) → verify the archive → drop
    the tenant store → a periodic sweep enforces archive expiry and purges. Gate the deprovision
    endpoint with the same app-only auth as provision. Data deletion is irreversible, so the
    export-verify-drop ORDER is mandatory and the archive expiry must be actually enforced by a
    sweep, not merely stamped as metadata.

PHASE 5 — TENANT SETTINGS & CONFIG.
11. Per-tenant settings (branding, feature flags, limits) live in a tenant-scoped store the product
    reads after resolution; changing platform-level tenant config (e.g. the database name) is done
    by re-provisioning, not an ad-hoc edit path, so the control plane stays the source of truth.

PHASE 6 — BILLING / MARKETPLACE HOOK.
12. Wire subscription state into resolution: a resolved tenant carries an active/suspended/
    unsubscribed status; suspended or unsubscribed tenants are refused at the resolver (a clear
    403/paywall), not served stale data. If integrating a marketplace, capture the buyer's tid at
    purchase and store it on the subscription record so tid → subscription → tenant resolves later.

PHASE 7 — PROVE ISOLATION (fail closed — the non-negotiable gate).
13. Write and run tenant-isolation checks against a TWO-TENANT setup:
    - Tenant A's token returns only A's data; Tenant B's only B's; neither ever returns the other's
      rows in either direction.
    - A write as A lands only in A's store.
    - A request whose tenant CANNOT be resolved (missing tid, missing catalog entry, suspended)
      FAILS CLOSED — an error, never a silent read of a shared or default store.
14. Run the provisioning and deprovisioning flows end to end against the live-ish stack (or with
    faithful fakes for the cloud calls, clearly labelled UNVERIFIED where a real cloud resource was
    not touched), and confirm idempotency and no-secret.

OUTPUT: (a) the tenancy-model decision with rationale and the user's approval, (b) the
control-plane/product-plane split with the tid-resolution flow, (c) the identity/membership/RBAC
design with the permissions feed, (d) the provisioning seam (idempotent, managed-identity) and its
mirror deprovision/purge lifecycle, (e) per-tenant settings + billing/subscription gating, (f) the
isolation proof (two-tenant, both directions, fail-closed) as the definition of done, (g) a
migration/rollout note (roll the tenancy flag to ONE tenant first, verify isolation, then widen).
Map each to the target's real stack; where the reference impl differs from the target, follow the
target. Compose with arch-recon first if the existing app is unfamiliar, test-first for each new
behavior, security-audit on the auth/tenancy/isolation surface, and durability-check before done.
BANNED: shipping tenancy without an isolation proof in BOTH directions; a resolver that fails OPEN
(silently serving a shared/default store when the tenant cannot be resolved) instead of failing
closed; "add a tenantId column" presented as a SaaS conversion; a provision path that is not
idempotent; designing provisioning without its deprovision/purge mirror; creating a per-tenant DB
secret when managed identity was available without flagging it; deferring the tenancy-model choice
into code instead of deciding it with the user; ANY double dash or em/en dash used as separator
punctuation in a generated file — use a colon, semicolon, or comma.
