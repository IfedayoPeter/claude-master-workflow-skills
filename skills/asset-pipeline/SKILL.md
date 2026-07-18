---
name: asset-pipeline
description: Use when building a polished marketing website or landing page where Claude generates its own visual assets in-pipeline (images, cutout PNGs, looping/motion video, brand animations) via a connected generative-media MCP (e.g. Higgs Field) instead of waiting on hand-supplied art. Forces a clear message and single call-to-action first, a consistent art-direction brief so every generated asset shares one look, self-generated assets slotted into a custom layout (not a recolored template), and a visual-QA pass where the model inspects the rendered result against the brief before shipping. Composes with ui-excellence for craft and clay-workflow when the site is outreach proof.
---

ROLE: You are running an end-to-end site-plus-assets pipeline: Claude plans the site, generates the
visual assets it needs through a connected generative-media tool, assembles them into a custom
layout, and inspects its own output before declaring it done. The result must look MADE FOR THIS
business — a custom layout with cohesive art direction, not a stock template with swapped colors.
Assets must share one visual system, not clash. NO double dashes in any generated file: use a
colon, semicolon, comma, or a hyphen inside a compound word.

PHASE 0 — MESSAGE & CONNECTOR.
1. Confirm the generative-media MCP/connector is connected and callable from this session (e.g.
   Higgs Field); if not, guide the user to add it before generating. Never fake generated output or
   claim an asset exists that was not produced.
2. Pin the CLEAR MESSAGE: within seconds a visitor must know WHAT this is, WHO it is for, and the
   ONE action to take. Write the hero's offer, primary benefit, and single call-to-action before
   any pixels. If the message is unclear, the visuals cannot save it — resolve it first.

PHASE 1 — ART-DIRECTION BRIEF (one look for everything).
3. Write a short brief that every asset obeys: palette (name the exact colors), mood/style,
   background treatment, subject consistency (same lighting, same treatment across shots), and
   aspect ratios needed. This is what makes the generated set feel like one brand instead of a
   grab-bag. List the concrete assets to generate (hero background, product/subject shots, cutout
   PNGs with transparent backgrounds, a looping/motion hero video, supporting graphics).

PHASE 2 — GENERATE (self-supplied assets).
4. Generate each listed asset through the connector, each prompt carrying the brief's palette,
   style, and consistency constraints. Produce transparent-background cutouts where the layout will
   composite them, and looping/motion video where the hero calls for motion. Keep the generated
   files organized in the project folder.

PHASE 3 — ASSEMBLE (custom layout, not a template).
5. Build the page as a custom layout with real sections (hero with the CTA, benefits, social proof,
   secondary CTA), compositing the generated assets. Motion is purposeful (a hero loop, tasteful
   scroll reveals), never decoration for its own sake. For craft-critical builds, compose with
   ui-excellence for hierarchy, spacing, type, depth, and the state matrix; this skill owns the
   asset pipeline, ui-excellence owns the craft score.

PHASE 4 — VISUAL QA (inspect against the brief before shipping).
6. Render the result and INSPECT it as a viewer would: does it read as made-for-this-business on
   first glance; is the message and CTA obvious in the hero; do all assets share the brief's look;
   are cutouts clean (no fringe); does the motion loop seamlessly; does it hold up at real screen
   widths (mobile included); do images not block the layout or overflow. Fix what fails and
   re-inspect. Do not ship on "it probably looks fine" — look at it.

PHASE 5 — DELIVER.
7. Deliver the assembled site plus the generated asset files, and note which model produced each
   asset. If the site is outreach proof (a rebuilt preview for a prospect), hand off to
   clay-workflow for the outreach; if it needs a motion/claymation ad, hand off to
   agentic-video-editor.

OUTPUT: (a) the clear message + single CTA, (b) the art-direction brief with the exact palette and
the asset list, (c) the generated assets (organized, each tagged with its generating model), (d)
the assembled custom-layout site, (e) the visual-QA findings and the fixes applied, (f) the
delivered files. Report only assets that were actually generated.
BANNED: faking or claiming generated assets that were not produced; a recolored stock template
presented as a custom site; assets that clash because no art-direction brief constrained them;
shipping without the visual-QA inspection against the brief; motion added as decoration with no
purpose; leaving a fringed or unclean cutout in the final composite; a hero that does not make the
offer and CTA obvious; ANY double dash or em/en dash used as separator punctuation in a generated
file — use a colon, semicolon, or comma.
