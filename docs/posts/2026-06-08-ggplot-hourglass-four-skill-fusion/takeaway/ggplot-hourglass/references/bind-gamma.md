# BIND gate — Γ, δ, conflict

## Γ (allowed charts by data profile)

| data | allow | deny | δ default |
|------|-------|------|-----------|
| threshold-categorical | bar-template, stacked-bar, heatmap | scatter-raw | bar-template |
| discrete-heavy | bar-template, stacked-bar | — | bar-template |
| continuous | scatter-repel, box-jitter, violin-jitter | — | scatter-repel |
| binary-matrix | heatmap-tile | — | heatmap-tile |

## Commit outputs

On BIND commit set:

- `waist.chart` — registry chart id (e.g. `bar-template`)
- leaf pointer — registry `leaves` → upstream § section
- optional `stack` override (python → rosetta leaves)

## P0 utterance overrides

| Signal | Force chart |
|--------|-------------|
| comorbidity, matrix, heatmap | heatmap-tile |
| gallery select bar_chart | gallery-bundle (after STOP) |

## Cross-skill conflict matrix

| Field | explore | manuscript |
|-------|---------|------------|
| plot_title | allow | **deny** (scientific belt) |
| width_mm_85 | optional | **required** |
| png_800_dpi | default | optional |

Belt **scientific-plotting** applies Wong, viridis quantile, single Times size, no title, 85 mm PDF.
