# AO3 HTML to EPUB

A Python and Snakemake workflow to batch-convert downloaded Archive of Our Own (AO3) HTML files into EPUB files. It's an adapted version of tachyon-orca's [ao3_to_epub](https://github.com/tachyon-orca/ao3_to_epub?tab=readme-ov-file) but now it uses snakemake to convert all html files you have in one run instead of having to run it individually per file.

## Requirements

- Python
- [uv](https://docs.astral.sh/uv/)
- Snakemake

## Setup

Clone the repository and install the dependencies:

```bash
uv sync
```

## Usage

1. Place downloaded AO3 HTML files in the `html/` directory.
2. Run the workflow:

```bash
uv run snakemake --cores 4
```

The workflow:
- Converts each HTML file into an EPUB.
- Checks that the generated EPUB is a valid ZIP archive.
- Deletes the original HTML file after successful verification.
- Removes temporary verification markers.

Generated EPUB files are stored in `epub/`.

## Notes

Keep backups of your original HTML files before running the workflow, as they are deleted after successful verification.

A modification to the original script by tachyon-orca is that now it can handle files where the author is  Anonymous.