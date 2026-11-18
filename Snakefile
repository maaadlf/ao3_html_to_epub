from pathlib import Path
import zipfile

HTML_DIR = "html"
EPUB_DIR = "epub"

# Find HTML files
html_files = [
    p.stem for p in Path(HTML_DIR).glob("*.html")
]

# Create output directory
Path(EPUB_DIR).mkdir(parents=True, exist_ok=True)


rule all:
    input:
        expand(
            f"{HTML_DIR}/{{book}}.deleted",
            book=html_files
        )


rule html_to_epub:
    input:
        html = f"{HTML_DIR}/{{book}}.html"
    output:
        epub = f"{EPUB_DIR}/{{book}}.epub"
    shell:
        """
        uv run python ao3_to_epub.py "{input.html}" "{output.epub}"
        """


rule verify_epub:
    input:
        epub = f"{EPUB_DIR}/{{book}}.epub"
    output:
        touch(f"{EPUB_DIR}/{{book}}.verified")
    run:
        assert zipfile.is_zipfile(input.epub), \
            f"Invalid EPUB: {input.epub}"

        with zipfile.ZipFile(input.epub) as z:
            assert z.testzip() is None, \
                f"Corrupted EPUB: {input.epub}"
            assert "mimetype" in z.namelist(), \
                "Missing mimetype file"

        print(f"Validated: {input.epub}")


rule delete_html:
    input:
        verified = f"{EPUB_DIR}/{{book}}.verified",
        html = f"{HTML_DIR}/{{book}}.html"
    output:
        touch(f"{HTML_DIR}/{{book}}.deleted")
    run:
        # Delete original HTML
        Path(input.html).unlink()

        # Delete verification marker
        Path(input.verified).unlink()

        # Create completion marker
        Path(output[0]).touch()
