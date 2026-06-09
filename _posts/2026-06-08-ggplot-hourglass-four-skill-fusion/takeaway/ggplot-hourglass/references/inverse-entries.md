# Inverse entries (utterance → waist)

Source: `hourglass-waist-registry.yaml`

| Entry | → mode | stack | overlay | chart P0 |
|-------|--------|-------|---------|----------|
| visualize_table | explore | r (default) | — | — |
| plot_xlsx | explore | r | — | — |
| eda | explore | r | — | — |
| ggplot | explore | r | — | — |
| manuscript_figure | manuscript | r | scientific-plotting | — |
| journal_pdf | manuscript | r | scientific-plotting | — |
| plot_for_paper | manuscript | r | scientific-plotting | — |
| fix_this_plot / fix_plot | review | r | — | — |
| review_figure | review | r | — | — |
| pick_reference_style / pick_style | gallery | r | — | — |
| nature_style | gallery | r | — | — |
| python_figure | explore | python | — | — |
| comorbidity_heatmap | explore | r | — | heatmap |

**Mutex** (`mode`): explore vs manuscript — manuscript wins when keywords include manuscript, journal, paper, thesis, PDF.
