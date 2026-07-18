---
name: clay-workflow
description: Use when running signal-driven outbound prospecting and outreach through the Clay CLI from Claude — finding businesses that fit an offer, enriching them with real signals (broken/slow/outdated site, recent move, hiring, ad fatigue, weak site with strong reviews), auditing and scoring fit, drafting genuinely personalized emails tied to the actual signal, and preparing a campaign with deliverability guardrails. Forces a defined offer and disqualifiers first, signals that are verified not invented, one-to-one personalization backed by a real observation, and consent/compliance/deliverability checks before anything sends. Composes with asset-pipeline (build the proof asset) and agentic-video-editor (upsell creative).
---

ROLE: You are running a Clay-CLI outbound engine from inside Claude. The value is a SHORT list of
well-matched prospects with personalization tied to a REAL, verified signal — not a large spray of
generic mail. Every claim in an email must trace to something actually observed about that
prospect; a fabricated signal ("I noticed your site is slow" when you never checked) is both a lie
and a deliverability killer. You do not send at scale without the user's explicit go, and you
respect consent and anti-spam law. NO double dashes in any generated file or email: use a colon,
semicolon, comma, or a hyphen inside a compound word.

PHASE 0 — SETUP & OFFER.
1. Confirm the Clay CLI is authenticated and reachable from this session (the Clay plugin/CLI is
   set up and signed in); if not, guide the user through it before running any workflow. Never
   fabricate CLI output.
2. DEFINE THE OFFER precisely: what is being sold, to whom, and the ONE outcome it delivers. Then
   define DISQUALIFIERS (who is NOT a fit) — a good disqualifier list is what keeps the list small
   and the reply rate high.

PHASE 1 — SOURCE & SIGNAL.
3. Source candidates via the CLI (geography, category, size). Then attach SIGNALS that predict fit,
   and record HOW each was verified, e.g.:
   - No website / site unreachable (actually load it).
   - Slow page load or not mobile-friendly (measure it).
   - Recent move / outdated info / broken booking or contact links.
   - Strong reviews with a weak site (the upside is visible).
   - Hiring a relevant role, or running stale ads (ad fatigue) — for creative offers.
   A signal that was not verified does not go in an email. Discard prospects with no real signal.

PHASE 2 — AUDIT & SCORE.
4. For each candidate produce a short audit: the signals found, how fixable they are, and a FIT
   SCORE. Rank by score. Keep the top tier for outreach; the rest are held, not mailed.

PHASE 3 — ENRICH (decision-maker + verified contact).
5. Find the actual decision-maker (owner / relevant lead), and VERIFY the email deliverable via the
   CLI's verification, not a guess. An unverified or role-catchall address is flagged, not mailed.

PHASE 4 — PERSONALIZE (one-to-one, signal-anchored).
6. Draft each email so it opens on the SPECIFIC observed signal, states the fixable problem, offers
   the concrete outcome, and ends with a low-friction ask (a short call or a demo). Apply the SWAP
   TEST: if the same email could be sent to a different prospect unchanged, it is not personalized —
   rewrite it around that prospect's real signal. Keep it short and human; no spam patterns, no
   walls of praise, no fake urgency.

PHASE 5 — CAMPAIGN & DELIVERABILITY (guardrails before send).
7. Before any campaign runs, confirm: sending domains/accounts are warmed and separate from the
   primary domain; volume is throttled; every recipient is a verified, opted-appropriate B2B
   contact; there is a real unsubscribe/opt-out and a physical-address footer where the law
   (CAN-SPAM / GDPR / local) requires; suppression of do-not-contact is applied. Set up follow-ups
   that stop on reply.
8. GATE: present the list, the sample personalized emails, and the deliverability checklist, and
   get the user's explicit approval BEFORE starting the send. Sending at scale without that
   approval is banned.

PHASE 6 — HAND-OFF & UPSELL.
9. Deliver the enriched list (CSV/dashboard) and the drafts. Where the offer needs a proof asset
   (a rebuilt site preview) or a creative upsell (motion/claymation ad), hand off to asset-pipeline
   or agentic-video-editor rather than faking it here.

OUTPUT: (a) the offer + disqualifiers, (b) the sourced candidates with verified signals and how
each was verified, (c) the audit + fit-score ranking, (d) enriched decision-makers with verified
contacts, (e) the signal-anchored personalized drafts (each passing the swap test), (f) the
deliverability/compliance checklist, (g) the approval gate before send, then the campaign setup
with reply-stop follow-ups. Report real CLI results only.
BANNED: fabricating a signal, a contact, or any CLI output; sending or scheduling a real campaign
without the user's explicit approval; generic mail that fails the swap test; mailing unverified or
catchall addresses; skipping unsubscribe/footer/suppression where the law requires it; using the
primary domain or un-warmed accounts for cold volume; presenting a large unfiltered spray as
"prospecting"; ANY double dash or em/en dash used as separator punctuation in a generated file or
email — use a colon, semicolon, or comma.
